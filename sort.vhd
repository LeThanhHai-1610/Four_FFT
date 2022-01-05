library ieee;
use ieee.std_logic_1164.all;

entity sort is
port(
   clk        	: in 	std_logic;
	WR,rst 		: in  std_logic;
	addr			: in    	std_logic_vector(4 downto 0);
	data        : in    	std_logic_vector(7 downto 0);
	start       : buffer std_logic;
	--done        : in std_logic;
	Re1,Im1, Re2, Im2, Re3, Im3, Re4,Im4            :buffer  std_logic_vector(7 downto 0)
);
end entity;
architecture rtl of sort is
--signal start: std_logic;
component mem is
Port ( 
       clk 	 		: in  std_logic;
		 WR,rst 		: in  std_logic;
		 addr			: in    	std_logic_vector(4 downto 0);
		 datain		: in  std_logic_vector(7 downto 0);
		 start      : buffer  std_logic;
		 --done       : in std_logic;
		 q1,q2,q3,q4,q5,q6,q7,q8     : out std_logic_vector(7 downto 0)
	);
end component;

begin
-- body --
sortEvenOdd: mem	 PORT MAP(clk,WR,rst,addr,data,start,Re1,Im1, Re3, Im3, Re2, Im2, Re4,Im4);
end rtl;