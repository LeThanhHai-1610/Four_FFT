library ieee;
use ieee.std_logic_1164.all;

entity mux81 is
port(
	dataout 		: out  std_logic_vector(7 downto 0);
	sel        : in    	std_logic_vector(2 downto 0);
	in1,in2,in3,in4,in5,in6,in7,in8   :in  std_logic_vector(7 downto 0)
);
end entity;
architecture rtl of mux81 is

begin
-- body --
process(sel,in1,in2,in3,in4,in5,in6,in7,in8)
begin
case(sel) is
when "000" => dataout <= in1;
when "001" => dataout <= in2;
when "010" => dataout <= in3;
when "011" => dataout <= in4;
when "100" => dataout <= in5;
when "101" => dataout <= in6;
when "110" => dataout <= in7;
when "111" => dataout <= in8;
when others =>dataout <= in1;
end case;
end process;
end rtl;