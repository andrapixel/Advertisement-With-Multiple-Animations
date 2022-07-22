library ieee;
use ieee.std_logic_1164.all;

entity WordMemory is
	port(SEL: in std_logic_vector(2 downto 0); -- selects the word that will be displayed
	LET0, LET1, LET2, LET3: inout std_logic_vector(4 downto 0)); 
end WordMemory ;																							  

architecture ARCH_WordMemory of WordMemory is  				  
type WordMem is array (0 to 19) of std_logic_vector(4 downto 0);

signal word: WordMem := (
	0 => "01011",	-- O
	1 => "11001",	-- r
	2 => "00100",	-- E
	3 => "01011",	-- O
	-----
	4 => "01010",	-- L
	5 => "01000",	-- I
	6 => "10011",	-- d
	7 => "01010",	-- L
	-----
	8 => "00001",   -- A
	9 => "00111",	-- H
	10 => "10011",	-- d
	11 => "01010",	-- L
	-----
	12 => "00101", 	-- F
	13 => "01100",	-- P
	14 => "00110",	-- G
	15 => "00001",	-- A
	-----
	16 => "10000",	-- Z
	17 => "00001",	-- A
	18 => "11001",	-- r
	19 => "00001");	-- A

begin
	memorizeSelectedWord: process(SEL)
	begin
		case SEL is 
			when "000" => 	
				LET0 <= word(0);  
				LET1 <= word(1);
				LET2 <= word(2);
				LET3 <= word(3);
			when "001" => 
				LET0 <= word(4);  
				LET1 <= word(5);
				LET2 <= word(6);
				LET3 <= word(7);
			when "010" =>		   
				LET0 <= word(8);  
				LET1 <= word(9);
				LET2 <= word(10);
				LET3 <= word(11);
			when "011" =>
				LET0 <= word(12);  
				LET1 <= word(13);
				LET2 <= word(14);
				LET3 <= word(15);
			when "100" =>
				LET0 <= word(16);  
				LET1 <= word(17);
				LET2 <= word(18);
				LET3 <= word(19);
			when others => LET0 <= "11111"; LET1 <= "11111"; LET2 <= "11111"; LET3 <= "11111";
		end case;
	end process memorizeSelectedWord;
end architecture ARCH_WordMemory;