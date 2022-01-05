library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
entity Complex_Mul is
Port 
  ( 
    Re1, Im1, Re2, Im2 : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    o_Re, o_Im : buffer STD_LOGIC_VECTOR(15 DOWNTO 0) 
  );
end Complex_Mul ;
architecture Behavioral of Complex_Mul  is
component AddSub16 is
  Port ( in1,in2 : in STD_LOGIC_VECTOR(15 DOWNTO 0) ;
    mode : in STD_LOGIC; -- 0: add; 1: sub
    out1 : buffer STD_LOGIC_VECTOR(15 DOWNTO 0) );
end component;
component signed_multiplier8 is
  Port ( 
    x,y : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    result : out STD_LOGIC_VECTOR(15 DOWNTO 0))  ;
end component;
signal s_Re1, s_Re2, s_Im1, s_Im2: STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
Mul1: signed_multiplier8	PORT MAP(Re1,Re2,s_Re1);
Mul2: signed_multiplier8	PORT MAP(Im1,Im2,s_Re2);
Mul3: signed_multiplier8	PORT MAP(Re1,Im2,s_Im1);
Mul4: signed_multiplier8	PORT MAP(Im1,Re2,s_Im2);
ADD1: AddSub16		PORT MAP(s_Re1,s_Re2,'1',o_Re);
ADD2: AddSub16		PORT MAP(s_Im1,s_Im2,'0',o_Im);
end Behavioral;