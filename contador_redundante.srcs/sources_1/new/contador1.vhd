----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Module Name: contador1 - Behavioral
-- Description: Contador simple sin control de enable. Solo se reinicia con RESET.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador1 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (7 downto 0));
end contador1;

architecture Behavioral of contador1 is
    signal temp_count : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            temp_count <= (others => '0');
        elsif rising_edge(clk) then
            temp_count <= temp_count + 1;
        end if;
    end process;
    count <= temp_count;
end Behavioral;