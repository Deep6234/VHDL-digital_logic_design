-- File: full_adder.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Sum : out STD_LOGIC;
           Cout : out STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is
begin
    -- Logic for Full Adder
    Sum <= (A XOR B) XOR Cin;
    Cout <= (A AND B) OR (Cin AND (A XOR B));
end Behavioral;

