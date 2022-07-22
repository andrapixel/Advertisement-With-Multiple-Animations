library ieee;
use ieee.std_logic_1164.all;

entity MUX8to1 is
	port(selMUX: in std_logic_vector(2 downto 0);
	output: out std_logic_vector(2 downto 0));
end MUX8to1;

architecture ARCH_MUX8to1 of MUX8to1 is
begin
	mux: process(selMUX)
	begin
		case selMUX is
			when "000" => output <= "000";
			when "001" => output <= "001";
			when "010" => output <= "010";
			when "011" => output <= "011"; 
			when "100" => output <= "100"; 
			when "101" => output <= "101";
			when "110" => output <= "110";
			when "111" => output <= "111"; 
			when others => output <= "111";	 
		end case;
	end process mux;
end architecture ARCH_MUX8to1;