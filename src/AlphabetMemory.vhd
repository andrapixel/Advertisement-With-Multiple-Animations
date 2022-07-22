library ieee;
use ieee.std_logic_1164.all;

entity ALPHABET_ROM is
	port(ADDRESS: in std_logic_vector(4 downto 0);
	CS: in std_logic;	-- chip select(ROM Enable)
	OUTPUT: out std_logic_vector(6 downto 0));
end ALPHABET_ROM;

architecture ARCH_ROM of ALPHABET_ROM is	 
type alphabet is array (0 to 28) of std_logic_vector (6 downto 0);	  

begin
	computeAlphabet: process(ADDRESS, CS) is	
	
	variable a: alphabet := (
		"1111111", -- no character is being displayed -> a(0)
		"0001000", -- A/R -> a(1)
		"0000000", -- B	-> a(2)
		"0110001", -- C	-> a(3)
		"0110000", -- E	-> a(4)
		"0111000", -- F	-> a(5)
		"0100000", -- G	-> a(6)
		"1001000", -- H/K -> a(7)
		"1001111", -- I	-> a(8)
		"0000011", -- J	-> a(9)
		"1110001", -- L	-> a(10)
		"0000001", -- O/D -> a(11)
		"0011000", -- P	-> a(12)
		"0100100", -- S	-> a(13)
		"1000001", -- U	-> a(14)
		"1000100", -- Y	-> a(15)
		"0010010", -- Z	-> a(16)
		"1100000", -- b	-> a(17)
		"1110010", -- c	-> a(18)
		"1000010", -- d	-> a(19)
		"1101000", -- h	-> a(20)
		"1101111", -- i	-> a(21)
		"1111001", -- l	-> a(22)
		"1101010", -- n	-> a(23)
		"1100010", -- o	-> a(24)
		"1111010", -- r	-> a(25)
		"1111000", -- t	-> a(26)
		"1100011", -- u	-> a(27)
		"1110111"); -- the character "_" - for empty spaces -> a(28)
	
	begin
        if CS = '1' then 
            case ADDRESS is
                when "00000" => OUTPUT <= a(0);	-- the 7 segments are turned off
                when "00001" => OUTPUT <= a(1);	-- A/R
                when "00010" => OUTPUT <= a(2);	-- B
                when "00011" => OUTPUT <= a(3);	-- C
                when "00100" => OUTPUT <= a(4);	-- E
                when "00101" => OUTPUT <= a(5);	-- F
                when "00110" => OUTPUT <= a(6);	-- G
                when "00111" => OUTPUT <= a(7);	-- H/K
                when "01000" => OUTPUT <= a(8);	-- I
                when "01001" => OUTPUT <= a(9);	-- J
                when "01010" => OUTPUT <= a(10); -- L
                when "01011" => OUTPUT <= a(11); -- O/D
                when "01100" => OUTPUT <= a(12); -- P
                when "01101" => OUTPUT <= a(13); -- S
                when "01110" => OUTPUT <= a(14); -- U
                when "01111" => OUTPUT <= a(15); -- Y
                when "10000" => OUTPUT <= a(16); -- Z
                when "10001" => OUTPUT <= a(17); -- b
                when "10010" => OUTPUT <= a(18); -- c
                when "10011" => OUTPUT <= a(19); -- d
                when "10100" => OUTPUT <= a(20); -- h
                when "10101" => OUTPUT <= a(21); -- i
                when "10110" => OUTPUT <= a(22); -- l
                when "10111" => OUTPUT <= a(23); -- n
                when "11000" => OUTPUT <= a(24); -- o
                when "11001" => OUTPUT <= a(25); -- r
                when "11010" => OUTPUT <= a(26); -- t
                when "11011" => OUTPUT <= a(27); -- u
                when others => OUTPUT <= a(28); -- "_" (empty space)
            end case;
        else OUTPUT <= a(0);  
        end if;
	end process computeAlphabet;
end architecture ARCH_ROM;