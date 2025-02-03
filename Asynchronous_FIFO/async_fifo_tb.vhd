----------------------------------------------------------------------------------

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity async_fifo_tb is
--  Port ( );
end async_fifo_tb;

architecture Testbench of async_fifo_tb is
component async_fifo
    Port ( rst_r,clk_r,en_r,rst_w,clk_w,en_w : in STD_LOGIC;
           empty_r,full_w : out STD_LOGIC;
           data_r : out STD_LOGIC_VECTOR (7 downto 0);
           data_w : in STD_LOGIC_VECTOR (7 downto 0)); 
end component;

signal rst_r,clk_r,en_r,rst_w,clk_w,en_w : STD_LOGIC:='0';
signal empty_r,full_w : STD_LOGIC;
signal data_r : STD_LOGIC_VECTOR (7 downto 0);
signal data_w : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');

constant clk_r_period: time := 10 ns;
constant clk_w_period: time := 10 ns;

begin
uut: async_fifo port map(
                            rst_r=>rst_r,
                            clk_r=>clk_r,
                            en_r=>en_r,
                            rst_w=>rst_w,
                            clk_w=>clk_w,
                            en_w=>en_w,
                            empty_r=>empty_r,
                            full_w=>full_w,
                            data_r=>data_r,
                            data_w=>data_w);

clk_r_process: process
begin
    clk_r<='0';
    wait for clk_r_period/2;
    clk_r<='1';
    wait for clk_r_period/2;
end process;
                               
clk_w_process: process
begin
    clk_w<= '0';
    wait for clk_w_period/2;
    clk_w<= '1';
    wait for clk_w_period/2;
end process;

stim_reset: process
begin
    rst_r<='1';
    rst_w<='1';
    wait for 100 ns;
    rst_r<='0';
    rst_w<='0';
    wait;
end process;

stim_write: process
begin
    wait for 100 ns;
    wait for clk_w_period*10;
    en_w<='1';
    data_w<="10101100";
    wait for clk_w_period;
    data_w<= "10110111";
    wait for clk_w_period;
    en_w<='0';
    wait for clk_w_period*30;
    en_w<='1';
    data_w<="01101101";
    wait for clk_w_period;
    data_w<="10011011";
    wait for clk_w_period*40;
    en_w<='0';
    wait;
end process;

stim_read: process
begin
    wait for 100 ns;
    wait for clk_r_period*20;
    en_r<='1';
    wait for clk_r_period*8;
    en_r<='0';
    wait for clk_r_period*8;
    en_r<='1';
    wait;
    
end process;    
    
end Testbench;
