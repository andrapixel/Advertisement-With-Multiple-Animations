library ieee;
use ieee.std_logic_1164.all;

entity ShiftMemoryUnit is
	port (selection: in std_logic_vector(2 downto 0);
	word_address: in integer;  -- address that points to the start of each word
	enable: in std_logic;
	letter_out0: out std_logic_vector(6 downto 0); 
	letter_out1: out std_logic_vector(6 downto 0);
	letter_out2: out std_logic_vector(6 downto 0);
	letter_out3: out std_logic_vector(6 downto 0));
end ShiftMemoryUnit;		

architecture ARCH_SMUnit of ShiftMemoryUnit is 
component ALPHABET_ROM is
	port(ADDRESS: in std_logic_vector(4 downto 0);
	CS: in std_logic;	-- chip select(ROM Enable)
	OUTPUT: out std_logic_vector(6 downto 0));
end component;	

component ShiftMemory is
	port (sel: in std_logic_vector(2 downto 0);
	address: in integer;  -- address that points to the start of each word
	temp_letter0: out std_logic_vector(4 downto 0); 
	temp_letter1: out std_logic_vector(4 downto 0);
	temp_letter2: out std_logic_vector(4 downto 0);
	temp_letter3: out std_logic_vector(4 downto 0));
end component;

signal intern0, intern1, intern2, intern3: std_logic_vector(4 downto 0);

begin
	MapShiftMemory: ShiftMemory port map (selection, word_address, intern0, intern1, intern2, intern3);	
	
	Map0: ALPHABET_ROM port map (intern0, enable, letter_out0);
	Map1: ALPHABET_ROM port map (intern1, enable, letter_out1);   
	Map2: ALPHABET_ROM port map (intern2, enable, letter_out2);
	Map3: ALPHABET_ROM port map (intern3, enable, letter_out3);

end architecture ARCH_SMUnit;
	


