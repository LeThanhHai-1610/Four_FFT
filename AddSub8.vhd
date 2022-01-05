library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
entity AddSub8 is
Port 
  ( 
    in1,in2 : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	 mode : in STD_LOGIC; -- 0: add; 1: sub
    out1 : buffer STD_LOGIC_VECTOR(7 DOWNTO 0) 
  );
end AddSub8 ;
architecture Behavioral of AddSub8  is
signal carry:  STD_LOGIC_VECTOR(8 DOWNTO 0);
signal s_in2:  STD_LOGIC_VECTOR(7 DOWNTO 0);
begin
  G1: for m in 0 to 7 generate
  s_in2(m) <= in2(m) xor mode;
end generate G1;
  carry(0) <= mode;
  G2: for m in 0 to 7 generate
  out1(m) <= in1(m) xor s_in2(m) xor carry(m);
  carry(m+1) <= (in1(m) and s_in2(m)) or (s_in2(m) and carry(m)) or (in1(m) and carry(m));
end generate G2;
end Behavioral;