-----------------------------------------------
-- TRABALHO TP3 - THIAGO ZILBERKNOP  2/JUNHO/23
-----------------------------------------------
-- thiago.zilberknop@edu.pucrs.br -------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--------------------------------------
-- Entidade
--------------------------------------
entity tp3 is 
  port (clock   : in std_logic;
        reset   : in std_logic;
        din     : in std_logic;
        padrao  : in std_logic_vector(7 downto 0);
        prog    : in std_logic_vector(2 downto 0);

        dout    : out std_logic;
        alarme  : out std_logic;
        numero  : out std_logic_vector(1 downto 0)
        );
end entity; 

--------------------------------------
-- Arquitetura
--------------------------------------
architecture tp3 of tp3 is
  type state is (idle, buscando, progA, progB, progC, progD, zerando, bloqueio);
  signal EA, PE: state;
  signal found : std_logic := '0';
  signal match : std_logic_vector(3 downto 0) := "0000";
  signal program : std_logic_vector(3 downto 0) := "0000";
  signal sel : std_logic_vector(3 downto 0) := "0000";
  signal data : std_logic_vector(7 downto 0) := x"00";
begin

  -- REGISTRADOR DE DESLOCAMENTO QUE RECEBE O FLUXO DE ENTRADA
  registrador : process(clock)
  begin
    if clock'event and clock = '1' then
      data(6 downto 0) <= data(7 downto 1);
      data(7) <= din;
    end if;
  end process registrador;
      

  -- 4 PORT MAPS PARA OS compara_dado -------------------------
  comp_dado_A : entity work.compara_dado
  port map (
    clock       =>    clock,
    reset       =>    reset,
    prog        =>    program(0),
    habilita    =>    sel(0),
    dado        =>    data,
    pattern     =>    padrao,
    match       =>    match(0)
  );
  comp_dado_B : entity work.compara_dado
  port map (
    clock       =>    clock,
    reset       =>    reset,
    prog        =>    program(1),
    habilita    =>    sel(1),
    dado        =>    data,
    pattern     =>    padrao,
    match       =>    match(1)
  );
  comp_dado_C : entity work.compara_dado
  port map (
    clock       =>    clock,
    reset       =>    reset,
    prog        =>    program(2),
    habilita    =>    sel(2),
    dado        =>    data,
    pattern     =>    padrao,
    match       =>    match(2)
  );
  comp_dado_D : entity work.compara_dado
  port map (
    clock       =>    clock,
    reset       =>    reset,
    prog        =>    program(3),
    habilita    =>    sel(3),
    dado        =>    data,
    pattern     =>    padrao,
    match       =>    match(3)
  );
  -- DISPARO DO found -------------------------------------------------------
  found   <=  '0' when match = "0000" else 
              '1';
    
  -- FLIP FLOPS --------------------------------------------------------------
  -- registro ------------------
  registro: process(clock)
  begin
    if clock'event and clock = '1' then
      case EA is
        when progA  => program <= "1000";
        when progB  => program <= "0100";
        when progC  => program <= "0010";
        when progD  => program <= "0001";
        when others => program <= "0000";
       end case;
    end if;
  end process registro;
      
  -- FSM ---------------------------------------------------------
  fsm : process(clock)
  begin
    if clock'event and clock = '1' then
      EA <= PE;
    end if;
  end process fsm;

  -- DECODER DE ESTADOS -----------------------------------------
  decoder_states: process(EA, prog)
  begin
    case EA is
      -- IDLE ------------------------
      when idle =>
        case prog is
          when "001"  => PE <= progA;
          when "010"  => PE <= progB;
          when "011"  => PE <= progC;
          when "100"  => PE <= progD;
          when "101"  => PE <= buscando;
          when "111"  => PE <= zerando;
          when others => PE <= EA;
        end case;
      -- BUSCANDO -------------------
      when buscando => 
        if prog = "000" then
          PE <= EA;
          else if prog = "111" then
            PE <= zerando;
            else if found = '1' then
              PE <= bloqueio;
            end if;
          end if;
        end if;
      -- PROGS ----------------------
      when progA => 
        PE <= idle;
        sel(0) <= '1';
      when progB => 
        PE <= idle;
        sel(1) <= '1';
      when progC => 
        PE <= idle;
        sel(2) <= '1';
      when progD => 
        PE <= idle;
        sel(3) <= '1';
      -- ZERANDO --------------------
      when zerando =>
          found <= '0';
          match <= "0000";
          program <= "0000";
          sel <= "0000";
          data <= x"00";
          PE <= idle;
      -- BLOQUEIO -------------------
      when bloqueio =>
        case prog is
          when "111" => PE <= zerando;
          when "101" => PE <= buscando;
          when "110" =>
            alarme <= '0';
            PE <= buscando;
          when others => PE <= EA;
        end case;  
    end case;
  end process decoder_states;

  -- SAIDAS -------------------------------------------------------
  dout <= '0' when EA = bloqueio else din;
  alarme <= '1' when EA = bloqueio else '0';
  numero <= match when EA = bloqueio else "00";

end architecture;
