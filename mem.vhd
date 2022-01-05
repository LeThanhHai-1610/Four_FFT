library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
entity mem is
	port
	(
	    clk 	 		: in  std_logic;
		 WR,rst 		: in  std_logic;
		 addr			: in  std_logic_vector(4 downto 0);
		 datain		: in  std_logic_vector(7 downto 0);
		 start      : buffer  std_logic;
		 --done       : in std_logic;
		 q1,q2,q3,q4,q5,q6,q7,q8     : out std_logic_vector(7 downto 0)
	);
end entity;

architecture rtl of mem is
type mem is array (0 to 8) of std_logic_vector(7 downto 0);
signal mem1         			  : mem;
signal start1: std_logic_vector(7 downto 0);
--signal start: std_logic;

begin

process(clk,rst)
begin
    if (rst = '1') then mem1 <= (others => "00000000");
    elsif rising_edge (clk) and (WR = '1') then
        mem1 (to_integer(unsigned(addr))) <= datain;
    end if;
start1 <= mem1(8);
start <= start1(0);
    if rising_edge (clk) and (start = '1') then
        q1 <= mem1(0);
        q2 <= mem1(1);
        q3 <= mem1(2);
	     q4 <= mem1(3);
	     q5 <= mem1(4);
        q6 <= mem1(5);
        q7 <= mem1(6);
	     q8 <= mem1(7);
    end if;
end process;

end rtl;
