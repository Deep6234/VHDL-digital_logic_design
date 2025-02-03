----------------------------------------------------------------------------------

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity async_fifo is

    generic(
            w: natural:= 8;
            d: natural:=256;
            b: natural:=16);
    
    Port ( rst_r,clk_r,en_r,rst_w,clk_w,en_w : in STD_LOGIC;
           empty_r,full_w : out STD_LOGIC;
           data_r : out STD_LOGIC_VECTOR (b/2-1 downto 0);
           data_w : in STD_LOGIC_VECTOR (b/2-1 downto 0));
end async_fifo;

architecture Behavioral of async_fifo is

signal full,empty,toggle: std_logic;
signal 
        writeptr,
        syncreadptrbin,
        readptrgraysync0,
        readptrgraysync1,
        writeptrgray,
        readptrbin,
        readptr,
        syncwriteptrbin,
        writeptrgraysync0,
        writeptrgraysync1,
        readptrgray,
        writeptrbin
        : std_logic_vector(w-1 downto 0);

type ramT is array(d-1 downto 0) of std_logic_vector(b/2-1 downto 0);
signal ram: ramT;

begin
    write_side: process(clk_w)
    begin
        if rising_edge(clk_w) then
            if rst_w = '1' then
                writeptr <= (others=>'0');
                writeptrgray <= (others =>'0');
                syncreadptrbin <= (others=>'0');
                readptrgraysync0 <= (others=>'0');
                readptrgraysync1 <= (others=>'0');
            else
                if en_w='1' and not full='1' then
                    writeptr <= writeptr + 1;
                end if;
                
                writeptrgray <= writeptr xor ('0' & writeptr(w-1 downto 1));
                
                readptrgraysync0 <= readptrgray;
                readptrgraysync1 <= readptrgraysync0;
                
                syncreadptrbin <= readptrbin;
            end if;
        end if;
    end process;
    
    readptrbin(w-1) <= readptrgraysync1(w-1);
    gray2bin_w: for i in w-2 downto 0 generate
        readptrbin(i) <= readptrbin(i+1) xor readptrgraysync1(i);
    end generate;
    
    full <= '1' when writeptr + '1' = syncreadptrbin else '0';
    full_w <= full;
    
    read_side:process(clk_r)
    begin
        if rising_edge(clk_r) then
            if rst_r = '1' then
                toggle <= '0';
                readptr <= (others=>'0');
                readptrgray <= (others=>'0');
                syncwriteptrbin <= (others=>'0');
                writeptrgraysync0 <= (others=>'0');
                writeptrgraysync1 <= (others=>'0');
            else
                if en_r ='1' and not empty ='1' then
                    if toggle = '1' then
                        toggle <='0';
                        readptr <= readptr + 1;
                    else
                        toggle <='1';
                    end if;
                end if;
                
                readptrgray <= readptr xor ('0' & readptr(w-1 downto 1));
                
                writeptrgraysync0 <= writeptrgray;
                writeptrgraysync1 <= writeptrgraysync0;
                
                syncwriteptrbin <= writeptrbin;
            end if;
        end if;
    end process;
      
    writeptrbin(w-1)<= writeptrgraysync1(w-1);
    gray2bin_r: for i in w-2 downto 0 generate
        writeptrbin(i) <= writeptrbin(i+1) xor writeptrgraysync1(i);
    end generate;
     
    empty <='1' when  readptr = syncwriteptrbin else '0';
    empty_r <= empty;
    
    dual_port_ram: process(clk_w)
    begin
        if rising_edge(clk_w) then 
            if en_w = '1' and not full = '1' then
            ram(conv_integer(writeptr)) <= data_w;
            end if;
        end if;
    end process;
    
data_r <= ram(conv_integer(readptr))(b/2-1 downto 0) when toggle ='1' else ram(conv_integer(readptr))(b/2-1 downto 0) when toggle ='0';
            
end Behavioral;
