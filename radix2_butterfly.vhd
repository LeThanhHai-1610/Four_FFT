library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity radix2_butterfly is
Port 
  ( 
    Re1, Im1, Re2, Im2, ReW, ImW : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    outRe1, outIm1, outRe2, outIm2 : buffer STD_LOGIC_VECTOR(7 DOWNTO 0) 
  );
end radix2_butterfly ;
architecture Behavioral of radix2_butterfly  is

component Complex_Mul is
  Port ( 
    Re1, Im1, Re2, Im2 : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    o_Re, o_Im : buffer STD_LOGIC_VECTOR(15 DOWNTO 0) );
end component;

component Complex_AddSub is
  Port ( 
    Re1, Im1, Re2, Im2 : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	 mode : in STD_LOGIC; -- 0: add; 1: sub
    o_Re, o_Im : buffer STD_LOGIC_VECTOR(7 DOWNTO 0) );
end component;
signal s_Re1, s_Im1, s_Re2, s_Im2: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal w_Re2, w_Im2: STD_LOGIC_VECTOR(7 DOWNTO 0);

begin

w_Re2 <= s_Re2(7 downto 0); w_Im2 <= s_Im2(7 downto 0);
Mul1: Complex_Mul port map (Re2, Im2, ReW, ImW, s_Re2, s_Im2); -- B*W
Add: Complex_AddSub port map (Re1, Im1, w_Re2, w_Im2, '0', outRe1, outIm1); -- A + B*W
Sub: Complex_AddSub port map (Re1, Im1, w_Re2, w_Im2, '1', outRe2, outIm2); -- A - B*W
end Behavioral;