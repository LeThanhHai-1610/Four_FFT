library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
entity core_fourFFT is
port
(
    clk,start       : in std_logic;
    Re1, Im1, Re2, Im2, Re3, Im3, Re4, Im4 :in    	std_logic_vector(7 downto 0);
	 done : buffer std_logic;
	 addr_r: in std_logic_vector(4 downto 0);
	 dataout: out    	std_logic_vector(7 downto 0)
	 --outRe1, outIm1, outRe2, outIm2 : buffer STD_LOGIC_VECTOR(7 DOWNTO 0);
	 --outRe3, outIm3, outRe4, outIm4 : buffer STD_LOGIC_VECTOR(7 DOWNTO 0)
);
end entity;

architecture rtl of core_fourFFT is

type mem is array (9 to 17) of std_logic_vector(7 downto 0);
signal mem2         			  : mem;
signal w_outRe1, w_outIm1, w_outRe2, w_outIm2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal w_outRe3, w_outIm3, w_outRe4, w_outIm4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ww_outRe1, ww_outIm1, ww_outRe2, ww_outIm2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ww_outRe3, ww_outIm3, ww_outRe4, ww_outIm4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal w_sel: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal w_reg_done:std_logic_vector(7 downto 0);
signal w_done,w_read_enb: std_logic;
component radix2_butterfly is
Port ( 
    Re1, Im1, Re2, Im2, ReW, ImW : in STD_LOGIC_VECTOR(7 DOWNTO 0) ;
    outRe1, outIm1, outRe2, outIm2 : buffer STD_LOGIC_VECTOR(7 DOWNTO 0) );
end component;

component mux81 is
Port ( 
    dataout 		: out  std_logic_vector(7 downto 0);
	 sel        : in    	std_logic_vector(2 downto 0);
	 in1,in2,in3,in4,in5,in6,in7,in8   :in  std_logic_vector(7 downto 0)
	);
end component;

begin

-- body --
TwoDFTa: radix2_butterfly PORT MAP(Re1, Im1, Re2, Im2,"00000001","00000000",w_outRe1, w_outIm1, w_outRe2, w_outIm2);
TwoDFTb: radix2_butterfly PORT MAP(Re3, Im3, Re4, Im4,"00000001","00000000",w_outRe3, w_outIm3, w_outRe4, w_outIm4);

TwoDFTc: radix2_butterfly PORT MAP(w_outRe1, w_outIm1, w_outRe3, w_outIm3,"00000001","00000000",ww_outRe1, ww_outIm1, ww_outRe3, ww_outIm3);
TwoDFTd: radix2_butterfly PORT MAP(w_outRe2, w_outIm2, w_outRe4, w_outIm4,"00000000","11111111",ww_outRe2, ww_outIm2, ww_outRe4, ww_outIm4);

process (clk)
variable n : integer := 0;
begin
    if rising_edge (clk) and (start = '1') then
	     w_done <= '1';
	 end if;
	 if rising_edge (clk) and (w_done = '1') then
	     mem2(10) <= ww_outRe1;
		  mem2(11) <= ww_outIm1;
		  mem2(12) <= ww_outRe2;
		  mem2(13) <= ww_outIm2;
		  mem2(14) <= ww_outRe3;
		  mem2(15) <= ww_outIm3;
		  mem2(16) <= ww_outRe4;
		  mem2(17) <= ww_outIm4;
		  --mem2(8) <= "0000000"&w_done;
		  w_done <= '0'; w_read_enb <= '1';
	 end if;
	 if rising_edge (clk) and (w_read_enb = '1') then
	     dataout <= mem2 (to_integer(unsigned(addr_r))); 
		  if (n = 8) then mem2(9) <= "00000000"; n:= 0; w_read_enb <= '0';
		  else n:= n+1; mem2(9) <= "00000001";
		  end if;
	 end if;
end process;
w_reg_done <= mem2(9);
done <= w_reg_done(0);
--process(clk,rst)
--variable n : integer := 0;
--begin
--    if rising_edge (clk) and (start = '1') then
--	     done <= '1';
--	 end if;
--	   if rising_edge (clk) and (done = '1') then
--		  w_sel <= w_sel + 1; n:= n + 1;
--		  if (n = 8) then
--		      w_sel <= "000"; n:= 0; done <= '0';
--		  end if;
--	   end if;
--end process;
--
--mux: mux81 port map (dataout,w_sel,ww_outRe1,ww_outIm1,ww_outRe2,ww_outIm2,ww_outRe3, ww_outIm3, ww_outRe4, ww_outIm4);
end rtl;

