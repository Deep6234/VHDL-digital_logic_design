-- File: testbench_full_adder.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_full_adder is
end tb_full_adder;

architecture Behavioral of tb_full_adder is

component full_adder
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Sum : out STD_LOGIC;
           Cout : out STD_LOGIC);
end component;

signal A, B, Cin, Sum, Cout : STD_LOGIC;

begin
    -- Instantiate the full adder
    UUT: full_adder Port map (A => A, B => B, Cin => Cin, Sum => Sum, Cout => Cout);

    -- Test process
    process
    begin
        -- Test Case 1: A = 0, B = 0, Cin = 0
        A <= '0'; B <= '0'; Cin <= '0'; wait for 10 ns;
        -- Test Case 2: A = 0, B = 1, Cin = 0
        A <= '0'; B <= '1'; Cin <= '0'; wait for 10 ns;
        -- Test Case 3: A = 1, B = 0, Cin = 0
        A <= '1'; B <= '0'; Cin <= '0'; wait for 10 ns;
        -- Test Case 4: A = 1, B = 1, Cin = 0
        A <= '1'; B <= '1'; Cin <= '0'; wait for 10 ns;
        -- Test Case 5: A = 0, B = 0, Cin = 1
        A <= '0'; B <= '0'; Cin <= '1'; wait for 10 ns;
        -- Test Case 6: A = 1, B = 1, Cin = 1
        A <= '1'; B <= '1'; Cin <= '1'; wait for 10 ns;

        wait;
    end process;
end Behavioral;

