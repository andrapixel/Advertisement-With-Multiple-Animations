library ieee;
use ieee.std_logic_1164.all;

entity MemoryUnit is
	port(WORD_SEL: in std_logic_vector(2 downto 0);
	EN: in std_logic;
	LETTER0, LETTER1, LETTER2, LETTER3: out std_logic_vector(6 downto 0));
end MemoryUnit;

architecture ARCH_MemUnit of MemoryUnit is	   
component ALPHABET_ROM is
	port(ADDRESS: in std_logic_vector(4 downto 0);
	CS: in std_logic;	-- chip select(ROM Enable)
	OUTPUT: out std_logic_vector(6 downto 0));
end component;

component WordMemory is
	port(SEL: in std_logic_vector(2 downto 0); -- selects the word that will be displayed
	LET0, LET1, LET2, LET3: inout std_logic_vector(4 downto 0)); 
end component;		

signal intern0, intern1, intern2, intern3: std_logic_vector(4 downto 0);

begin  
	MapWordMemory: WordMemory port map(WORD_SEL, intern0, intern1, intern2, intern3);

	Map0: ALPHABET_ROM port map (intern0, EN, LETTER0);
	Map1: ALPHABET_ROM port map (intern1, EN, LETTER1);
	Map2: ALPHABET_ROM port map (intern2, EN, LETTER2);
	Map3: ALPHABET_ROM port map (intern3, EN, LETTER3);
end architecture ARCH_MemUnit;