-----------------------------------------------
-- TRABALHO TP3 - THIAGO ZILBERKNOP  16/MAIO/23
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
begin

  -- REGISTRADOR DE DESLOCAMENTO QUE RECEBE O FLUXO DE ENTRADA

  -- 4 PORT MAPS PARA OS compara_dado  
  comp_dado_A : entity work.comp
  port map (
    
  found   <=  . . . 

  program(0) <= . . .
  program(1) <= . . .
  program(2) <= . . .
  program(3) <= . . .
  
  --  registradores para ativar as comparações

  --  registrador para o alarme interno

  -- DECODER DE ESTADOS --------------
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
          when others => PE <= EA;
        end case;
      -- BUSCANDO -------------------
      when buscando =>
      -- PROGS ----------------------
      when progA =>
      when progB =>
      when progC =>
      when progD =>
      -- ZERANDO --------------------
      when zerando =>
      -- BLOQUEIO -------------------
      when bloqueio =>
    end case;
  end process decoder_states;
        

  -- SAIDAS
  alarme <= . . . 
  dout   <= . . . 
  numero <=  . . . 

end architecture;
