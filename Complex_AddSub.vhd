library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
entity Complex_AddSub is
Port 
  ( 
    Re1, Im1, Re2, Im2 : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	 mode : in STD_LOGIC; -- 0: add; 1: sub
    o_Re, o_Im : buffer STD_LOGIC_VECTOR(7 DOWNTO 0) 
  );
end Complex_AddSub ;
architecture Behavioral of Complex_AddSub  is
component AddSub8 is
  Port ( in1,in2 : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    mode : in STD_LOGIC; -- 0: add; 1: sub
    out1 : buffer STD_LOGIC_VECTOR(7 DOWNTO 0) );
end component;

begin
ADDRe: AddSub8		PORT MAP(Re1,Re2,mode,o_Re);
ADDIm: AddSub8		PORT MAP(Im1,Im2,mode,o_Im);
end Behavioral;