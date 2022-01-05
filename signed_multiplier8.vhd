
---------------------------------------------------------
--  This code is generated by Terasic System Builder
---------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity signed_multiplier8 is
port
(
	x                 :in		std_logic_vector(7 downto 0);
	y                 :in		std_logic_vector(7 downto 0);
	result            :out		std_logic_vector(15 downto 0)
);

end entity;

---------------------------------------------------------
--  Structural coding
---------------------------------------------------------

architecture rtl of signed_multiplier8 is

-- declare --
signal a0,b0,r1            :    	 std_logic_vector(10 downto 0);
signal a,b                 :    	 std_logic_vector(15 downto 0);
signal c1		   	      :		 std_logic_vector(8 downto 0);
signal r                   :		 std_logic_vector(15 downto 0);
signal xb,x1,y1            :      std_logic_vector(7 downto 0);
component Booth_decoder is
Port (
c : in STD_LOGIC_VECTOR(4 DOWNTO 0) ;
h : buffer STD_LOGIC_VECTOR(10 DOWNTO 0)   ;
x1,xb : in STD_LOGIC_VECTOR(7 DOWNTO 0))  ;
end component;
component AddSub16 is
  Port ( in1,in2 : in STD_LOGIC_VECTOR(15 DOWNTO 0) ;
    mode : in STD_LOGIC; -- 0: add; 1: sub
    out1 : buffer STD_LOGIC_VECTOR(15 DOWNTO 0) );
end component;
----------------------------------------------------------------
begin
process(x,y)
begin
if (x(7) xor y(7)) = '1' then
	if (x(7) = '1') then x1 <= not(x) + '1'; else x1<=x; end if;
	if (y(7) = '1') then y1 <= not(y) + '1'; else y1<=y; end if;
else x1<=x; y1<=y;
end if;
end process;

-- body --
-- Multiplication pre-processing ---

c1 <= y1 & '0'; xb <= not(x1) + '1'; 

Booth_decoder1: Booth_decoder PORT MAP (c1(4 downto 0),a0,x1,xb);
Booth_decoder2: Booth_decoder PORT MAP (c1(8 downto 4),b0,x1,xb);


process(a0,b0)
begin
if (a0 (10) = '1') then a <= "11111" & a0;
else a <=                    "00000" & a0; end if;

if (b0 (10) = '1') then b <=  '1' & b0 & "0000";
else b <=                    '0' & b0 & "0000"; end if;
end process;
A6: AddSub16 port map (a,b,'0',r);
process(a,b,r)
begin
if (x(7) xor y(7)) = '1' then
	result <= not(r) + '1'; else result <= r; 
end if;
end process;

end rtl;
---------------------------------------------------------
---------------------------------------------------------
-- Weighted 2-stage Booth algorithm --
library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
entity Booth_decoder is
Port ( 
c : in STD_LOGIC_VECTOR(4 DOWNTO 0) ;
h : buffer STD_LOGIC_VECTOR(10 DOWNTO 0) ;
x1,xb : in STD_LOGIC_VECTOR(7 DOWNTO 0)) ;
end Booth_decoder ;

architecture Behavioral of Booth_decoder  is
signal k :  STD_LOGIC_VECTOR(10 DOWNTO 0) ;
signal j :  STD_LOGIC_VECTOR(10 DOWNTO 0) ;
signal cr6    :  STD_LOGIC;
component RCA11 is
	Port (  
	in1,in2 : in STD_LOGIC_VECTOR(10 DOWNTO 0) ;
	out1 : buffer STD_LOGIC_VECTOR(10 DOWNTO 0)) ;
end component;

begin
process(c)
 begin
  case c(2 downto 0) is
		when "000" => j <= "00000000000";  
		when "001" => if (x1(7)='1') then j  <= "111" & x1; else j <= "000" & x1; end if;
		when "010" => if (x1(7)='1') then j  <= "111" & x1; else j <= "000" & x1; end if;
		when "011" => if (x1(7)='1') then j  <= "11" & x1 & '0'; else j <= "00" & x1 & '0'; end if;
		when "100" => if (xb(7)='1') then j  <= "11" & xb & '0'; else j <= "00" & xb & '0'; end if;
		when "101" => if (xb(7)='1') then j  <= "111" & xb; else j <= "000" & xb; end if;
		when "110" => if (xb(7)='1') then j  <= "111" & xb; else j <= "000" & xb; end if;
		when "111" => j <= "00000000000";
		when others => j <= "00000000000";
  end case;

  case c(4 downto 2) is
		when "000" => k <= "00000000000"; 
		when "001" => if (x1(7)='1') then k  <= '1' & x1 & "00"; else k <= '0' & x1 & "00"; end if;
		when "010" => if (x1(7)='1') then k  <= '1' & x1 & "00"; else k <= '0' & x1 & "00"; end if;
		when "011" => if (x1(7)='1') then k  <=  x1 & "000"; else k <=   x1 & "000"; end if;
		when "100" => if (xb(7)='1') then k  <=  xb & "000"; else k <=  xb & "000"; end if;
		when "101" => if (xb(7)='1') then k  <= '1' & xb & "00"; else k <= '0' & xb & "00"; end if; 
		when "110" => if (xb(7)='1') then k  <= '1' & xb & "00"; else k <= '0' & xb & "00"; end if; 
		when "111" => k <= "00000000000";
		when others => k <= "00000000000";
  end case;
  --end if;
end process;
A7: RCA11 port map (j,k,h);
end Behavioral;
-------------------------------------------------------------

-- RCA11 --
library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
entity RCA11 is
Port ( 
in1,in2 : in STD_LOGIC_VECTOR(10 DOWNTO 0) ;
out1 : buffer STD_LOGIC_VECTOR(10 DOWNTO 0) );
end RCA11 ;
architecture Behavioral of RCA11  is
signal carry:  STD_LOGIC_VECTOR(11 DOWNTO 0);

begin
carry(0) <='0';
G1: for m in 0 to 10 generate
out1(m) <= in1(m) xor in2(m) xor carry(m);
carry(m+1) <= (in1(m) and in2(m)) or (in2(m) and carry(m)) or (in1(m) and carry(m));
end generate G1;
end Behavioral;