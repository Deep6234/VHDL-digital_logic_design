-- File: testbench_half_adder.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_half_adder is
end tb_half_adder;

architecture Behavioral of tb_half_adder is

component half_adder
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Sum : out STD_LOGIC;
           Carry : out STD_LOGIC);
end component;

signal A, B, Sum, Carry: STD_LOGIC;

begin
    -- Instantiate the half adder
    UUT: half_adder Port map (A => A, B => B, Sum => Sum, Carry => Carry);

    -- Test process
    process
    begin
        -- Test Case 1: A = 0, B = 0
        A <= '0'; B <= '0'; wait for 10 ns;
        -- Test Case 2: A = 0, B = 1
        A <= '0'; B <= '1'; wait for 10 ns;
        -- Test Case 3: A = 1, B = 0
        A <= '1'; B <= '0'; wait for 10 ns;
        -- Test Case 4: A = 1, B = 1
        A <= '1'; B <= '1'; wait for 10 ns;

        wait;
    end process;
end Behavioral;
