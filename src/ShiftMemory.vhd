library ieee;
use ieee.std_logic_1164.all;

entity ShiftMemory is
	port (sel: in std_logic_vector(2 downto 0);
	address: in integer;  -- address that points to the start of each word
	temp_letter0: out std_logic_vector(4 downto 0); 
	temp_letter1: out std_logic_vector(4 downto 0);
	temp_letter2: out std_logic_vector(4 downto 0);
	temp_letter3: out std_logic_vector(4 downto 0));
end ShiftMemory;

architecture ARCH_ShiftMem of ShiftMemory is
component WordMemory is
	port(SEL: in std_logic_vector(2 downto 0); -- selects the word that will be displayed
	LET0, LET1, LET2, LET3: inout std_logic_vector(4 downto 0)); 
end component;

type MemShift is array (0 to 19) of std_logic_vector(4 downto 0);

signal shift: MemShift;
signal intern0, intern1, intern2, intern3: std_logic_vector(4 downto 0);

begin
	MapWordMemory: WordMemory port map (sel, intern0, intern1, intern2, intern3);
	
	shift(0) <= intern0;
	shift(1) <= intern1;
	shift(2) <= intern2;
	shift(3) <= intern3;
	---------------------
	shift(4) <= intern1;
	shift(5) <= intern2;
	shift(6) <= intern3;
	shift(7) <= intern0;
	---------------------
	shift(8) <= intern2;
	shift(9) <= intern3;
	shift(10) <= intern0;
	shift(11) <= intern1;
	----------------------
	shift(12) <= intern3;
	shift(13) <= intern0;
	shift(14) <= intern1;
	shift(15) <= intern2; 
	---------------------- 
	
	letterShifting: process		
	begin
		case address is
			when 0 =>
				temp_letter0 <= shift(0);
				temp_letter1 <= shift(1);
				temp_letter2 <= shift(2);
				temp_letter3 <= shift(3); 
			when 4 =>
				temp_letter0 <= shift(4);
				temp_letter1 <= shift(5);
				temp_letter2 <= shift(6);
				temp_letter3 <= shift(7);
			when 8 =>
				temp_letter0 <= shift(8);
				temp_letter1 <= shift(9);
				temp_letter2 <= shift(10);
				temp_letter3 <= shift(11);
			when 12 =>
				temp_letter0 <= shift(12);
				temp_letter1 <= shift(13);
				temp_letter2 <= shift(14);
				temp_letter3 <= shift(15); 
			when 16 =>
				temp_letter0 <= shift(16);
				temp_letter1 <= shift(17);
				temp_letter2 <= shift(18);
				temp_letter3 <= shift(19); 
			when others =>
				temp_letter0 <= (others => '0');
				temp_letter1 <= (others => '0');
				temp_letter2 <= (others => '0'); 
				temp_letter3 <= (others => '0'); 
		end case;	
		wait for 10 ns;
	end process letterShifting;

end architecture ARCH_ShiftMem; 