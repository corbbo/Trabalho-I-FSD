-------------------------------------------------------
-- MODULO COMPARA DADO  -  THIAGO ZILBERKNOP 16/MAIO/23
-------------------------------------------------------
-- thiago.zilberknop@edu.pucrs.br ---------------------


library IEEE;
  use IEEE.std_logic_1164.all;

entity compara_dado is 
  port (clock    : in std_logic;
        reset    : in std_logic;
        prog     : in std_logic;
        habilita : in std_logic;
        dado     : in std_logic_vector(7 downto 0);
        pattern  : in std_logic_vector(7 downto 0);

        match    : out std_logic
      );
end compara_dado; 

architecture al of compara_dado is

  signal padrao : std_logic_vector(7 downto 0):= x"00";
  signal igual  : std_logic := '0';

begin
  process(clock)
    if clock'event and clock = '1' then
      -- RESET --------------------
      if reset = '1' then
        match <= '0';
        padrao <= x"00";
      else
        -- REGISTRO ---------------
        if prog = '1' then
          padrao <= pattern;
        end if;
        -- IGUAL ------------------
        if dado = padrao then
          igual <= '1';
          end if;
      end if;
    end if;
  end process;
  -- MATCH ------------------------
  match <= '1' when habilita = '1' and igual = '1' else '0';
end al;