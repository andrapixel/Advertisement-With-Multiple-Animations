library work, std;
library IEEE;
use ieee.STD_logic_1164.ALL;
use ieee.STD_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL; 


entity CompleteSystem is
	port(intCLK, ENABLE: in std_logic;
	MESSAGE_SEL, ANIM_SEL: in std_logic_vector(2 downto 0);
	ANODES: inout std_logic_vector(3 downto 0) := "1110"; 	-- ANODES(0) is active
	SEGMENT: out std_logic_vector(6 downto 0));
end CompleteSystem;

architecture ARCH_CS of CompleteSystem is	 
component MemoryUnit is
	port(WORD_SEL: in std_logic_vector(2 downto 0);
	EN: in std_logic;
	LETTER0, LETTER1, LETTER2, LETTER3: out std_logic_vector(6 downto 0));
end component;	   

component ShiftMemoryUnit is
	port (selection: in std_logic_vector(2 downto 0);
	word_address: in integer;  -- address that points to the start of each word
	enable: in std_logic;
	letter_out0: out std_logic_vector(6 downto 0); 
	letter_out1: out std_logic_vector(6 downto 0);
	letter_out2: out std_logic_vector(6 downto 0);
	letter_out3: out std_logic_vector(6 downto 0));
end component;

component MUX8to1 is
	port(selMUX: in std_logic_vector(2 downto 0);
	output: out std_logic_vector(2 downto 0));
end component;	
---------
type MEM_SHIFT is array (0 to 15) of STD_LOGIC_VECTOR(6 downto 0);
type MEM_BLINK is array (7 downto 0) of STD_LOGIC_VECTOR(6 downto 0); 
type MEM_MESSAGE is array (3 downto 0) of STD_LOGIC_VECTOR(6 downto 0);

signal selected_word: MEM_MESSAGE; 	-- used for animation 0	
signal shift: MEM_SHIFT; 	   		-- used for animations 1, 2
signal oneLetter: MEM_SHIFT := (others => "1111111");	-- used for animation 4
signal oneLetter2: MEM_SHIFT := (others => "1111111");	-- used for animation 5

signal blink: MEM_BLINK := (	  	-- used for animation 3
4 => "1111111",
5 => "1111111",	       --____
6 => "1111111",
7 => "1111111",
others => "0000000");

signal blink2: MEM_BLINK := (		-- used for animation 6
1 => "1111111",	       
2 => "1111111",
4 => "1111111",       
7 => "1111111",
others => "0000000");

signal blink3: MEM_BLINK := (		-- used for animation 7
1 => "1111111",	       
2 => "1111111",
4 => "1111111",       
7 => "1111111",
others => "0000000");

signal counter: std_logic_vector(25 downto 0) := "00000000000000000000000000";
signal counter2: std_logic_vector(15 downto 0) := "0000000000000000";
signal anim_mode: STD_LOGIC_VECTOR(2 downto 0) := "000"; 

begin  		   
	MapAnimationMUX: MUX8to1 port map(ANIM_SEL, anim_mode);		
	
	MapMemoryUnit: MemoryUnit port map(MESSAGE_SEL, ENABLE, selected_word(0), selected_word(1), selected_word(2), selected_word(3));	-- A0	
	
	MapMemoryShift0: ShiftMemoryUnit port map(MESSAGE_SEL, 0, ENABLE, shift(0), shift(1), shift(2), shift(3));	  	-- A1, A2
	MapMemoryShift1: ShiftMemoryUnit port map(MESSAGE_SEL, 4, ENABLE, shift(4), shift(5), shift(6), shift(7));
	MapMemoryShift2: ShiftMemoryUnit port map(MESSAGE_SEL, 8, ENABLE, shift(8), shift(9), shift(10), shift(11));
	MapMemoryShift3: ShiftMemoryUnit port map(MESSAGE_SEL, 12, ENABLE, shift(12), shift(13), shift(14), shift(15));	  
	
	BlinkingEffect: MemoryUnit port map(MESSAGE_SEL, ENABLE, blink(0), blink(1), blink(2), blink(3));	  	-- A3
	BlinkingEffect2: MemoryUnit port map(MESSAGE_SEL, ENABLE, blink2(0), blink2(3), blink2(5), blink2(6));	-- A6
	BlinkingEffect3: MemoryUnit port map(MESSAGE_SEL, ENABLE, blink3(0), blink3(3), blink3(5), blink3(6));	-- A7
	
	LetterByLetter: MemoryUnit port map(MESSAGE_SEL, ENABLE, oneLetter(0), oneLetter(4), oneLetter(8), oneLetter(12));		  	-- A4   
	LetterByLetter2: MemoryUnit port map(MESSAGE_SEL, ENABLE, oneLetter2(0), oneLetter2(5), oneLetter2(10), oneLetter2(15));		-- A5
	---------
	Animations: process(intCLK)	 
	variable index: integer := 0;
	variable index2: integer := 12;
	begin
      if intCLK = '1' and intCLK'EVENT then	 -- rising edge
          case anim_mode is
          -- Animation 0: static effect (simply displays the word as it is)
              when "000" =>		
              if counter2 = "1111000000000000" then 
                      if ANODES(0) = '0' then
                          ANODES(0) <= '1';  
                          SEGMENT <= selected_word(0);
                          ANODES(3) <= '0';
                      elsif ANODES(3)= '0' then
                          ANODES(3) <= '1';
                          SEGMENT <= selected_word(1);
                          ANODES(2) <= '0'; 
                      elsif ANODES(2) = '0' then 
                          ANODES(2) <= '1';
                          SEGMENT <= selected_word(2);
                          ANODES(1) <= '0';
                      elsif ANODES(1) = '0' then
                          ANODES(1) <= '1';
                          SEGMENT <= selected_word(3);
                          ANODES(0) <= '0';
                      end if;	 
                  end if;	 
                  
                  if counter2 = "1111000000000000" then  
                      counter2 <= "0000000000000000" ;
                  end if;
                              
                  counter2 <= counter2 + 1;
                  counter <= counter + 1;		   
          
                  if counter = "10111110101111000010111111" then 	 
                      counter <= "00000000000000000000000000";										
                  end if;	
              
              -- Animation 1: left shift effect 	
              when "001" =>	  					       
                  if counter2 = "000000000001010" then
                      if ANODES(0) = '0' then
                          ANODES(0) <= '1';
                          SEGMENT <= shift(index);
                          ANODES(3) <= '0';
                      elsif ANODES(3)='0' then
                          ANODES(3) <= '1';
                          SEGMENT <= shift(index + 1);
                          ANODES(2) <= '0';	
                      elsif ANODES(2) = '0' then
                          ANODES(2) <= '1';
                          SEGMENT <= shift(index + 2);
                          ANODES(1) <= '0';			
                      elsif ANODES(1) = '0' then
                          ANODES(1) <= '1';
                          SEGMENT <= shift(index + 3);
                          ANODES(0) <= '0';
                      end if;	  
                  end if;
                      
                  if counter2 = "000000000001010" then  
                      counter2 <= "0000000000000000";
                  end if;
                                  
                  counter2 <= counter2 + 1;
                  counter <= counter + 1;		   
                              
                  if index = 16  then
                      index := 0;
                  end if;	
                      
                  if counter = "10111110101111000010111111" then 
                      index := index + 4; 	 
                      counter <= "00000000000000000000000000";										
                  end if;	
                  
              -- Animation 2: right shift effect 	
              when "010" =>	  					       
                  if counter2 = "000000000001010" then
                      if ANODES(0) = '0' then
                          ANODES(0) <= '1';
                          SEGMENT <= shift(index2);
                          ANODES(3) <= '0';
                      elsif ANODES(3)='0' then
                          ANODES(3) <= '1';
                          SEGMENT <= shift(index2 + 1);
                          ANODES(2) <= '0';	
                      elsif ANODES(2) = '0' then
                          ANODES(2) <= '1';
                          SEGMENT <= shift(index2 + 2);
                          ANODES(1) <= '0';			
                      elsif ANODES(1) = '0' then
                          ANODES(1) <= '1';
                          SEGMENT <= shift(index2 + 3);
                          ANODES(0) <= '0';
                      end if;	  
                  end if;
                      
                  if counter2 = "000000000001010" then  
                      counter2 <= "0000000000000000";
                  end if;
                                  
                  counter2 <= counter2 + 1;
                  counter <= counter + 1;		   
                              
                  if index2 = 0  then
                      index := 12;
                  end if;	
                      
                  if counter = "10111110101111000010111111" then 
                      index2 := index2 - 4; 	 
                      counter <= "00000000000000000000000000";										
                  end if;
                  
              -- Animation3: intermittent blinking effect of ALL the letters at the same time 
              when "011" =>                       			
                  if counter2 = "1111000000000000" then
                      if ANODES(0) = '0' then
                          ANODES(0) <= '1';
                          SEGMENT <= blink(index);
                          ANODES(3) <= '0';	
                      elsif ANODES(3) = '0' then
                          ANODES(3) <= '1';
                          SEGMENT <= blink(index + 1);
                          ANODES(2) <= '0';
                      elsif ANODES(2) = '0' then
                          ANODES(2) <= '1';
                          SEGMENT <= blink(index + 2);
                          ANODES(1) <= '0';			
                      elsif ANODES(1) = '0' then
                          ANODES(1) <= '1';
                          SEGMENT <= blink(index + 3);
                          ANODES(0)<='0';
                      end if;	
                  end if;
                          
                  if counter2 = "1111000000000000" then
                      counter2 <= "0000000000000000" ;
                  end if;
                          
                  counter2 <= counter2 + 1;
                  counter <= counter + 1;
                          
                  if index = 8 then
                      index := 0;	
                  end if;
                  if counter = "10111110101111000010111111" then 
                      index := index + 4;  
                      counter <= "00000000000000000000000000";
                  end if;	
                  
              -- Animation 4: displays each letter one by one (on A SINGLE 7-segm. display)
              when "100" =>	 								 
                  if counter2 = "1111000000000000" then
                      if ANODES(0) = '0' then
                          ANODES(0) <= '1';
                          SEGMENT <= oneLetter(index);
                          ANODES(3) <= '0';	
                      elsif ANODES(3) = '0' then
                          ANODES(3) <= '1';
                          SEGMENT <= oneLetter(index + 1);
                          ANODES(2) <= '0';
                      elsif ANODES(2) = '0' then
                          ANODES(2) <= '1';
                          SEGMENT <= oneLetter(index + 2);
                          ANODES(1) <= '0';			
                      elsif ANODES(1) = '0' then
                          ANODES(1) <= '1';
                          SEGMENT <= oneLetter(index + 3);
                          ANODES(0)<='0';
                      end if;	
                  end if;
                          
                  if counter2 = "1111000000000000" then
                      counter2 <= "0000000000000000" ;
                  end if;
                          
                  counter2 <= counter2 + 1;
                  counter <= counter + 1;
                      
                  if index = 16 then  
                      index := 0;
                  end if;	 
                          
                  if counter = "10111110101111000010111111" then 
                      index := index + 4;  
                      counter <= "00000000000000000000000000"; 
                  end if;
				  
				 -- Animation 5: "flowing" of the text from left to right 
                  when "101" =>	 								 
                  if counter2 = "1111000000000000" then
                      if ANODES(0) = '0' then
                          ANODES(0) <= '1';
                          SEGMENT <= oneLetter2(index);
                          ANODES(3) <= '0';	
                      elsif ANODES(3) = '0' then
                          ANODES(3) <= '1';
                          SEGMENT <= oneLetter2(index + 1);
                          ANODES(2) <= '0';
                      elsif ANODES(2) = '0' then
                          ANODES(2) <= '1';
                          SEGMENT <= oneLetter2(index + 2);
                          ANODES(1) <= '0';			
                      elsif ANODES(1) = '0' then
                          ANODES(1) <= '1';
                          SEGMENT <= oneLetter2(index + 3);
                          ANODES(0)<='0';
                      end if;	
                  end if;
                          
                  if counter2 = "1111000000000000" then
                      counter2 <= "0000000000000000" ;
                  end if;
                          
                  counter2 <= counter2 + 1;
                  counter <= counter + 1;
                      
                  if index = 16 then  
                      index := 0;
                  end if;	 
                          
                  if counter = "10111110101111000010111111" then 
                      index := index + 4;  
                      counter <= "00000000000000000000000000"; 
                  end if;
				  
				 -- Animation 6: blinking of 2-letter pairs: the first and last two letters 
                 when "110" =>                       			
                  if counter2 = "1111000000000000" then
                      if ANODES(0) = '0' then
                          ANODES(0) <= '1';
                          SEGMENT <= blink2(index);
                          ANODES(3) <= '0';	
                      elsif ANODES(3) = '0' then
                          ANODES(3) <= '1';
                          SEGMENT <= blink2(index + 3);
                          ANODES(2) <= '0';
                      elsif ANODES(2) = '0' then
                          ANODES(2) <= '1';
                          SEGMENT <= blink2(index + 1);
                          ANODES(1) <= '0';			
                      elsif ANODES(1) = '0' then
                          ANODES(1) <= '1';
                          SEGMENT <= blink2(index + 2);
                          ANODES(0)<='0';
                      end if;	
                  end if;
                          
                  if counter2 = "1111000000000000" then
                      counter2 <= "0000000000000000" ;
                  end if;
                          
                  counter2 <= counter2 + 1;
                  counter <= counter + 1;
                          
                  if index = 8 then
                      index := 0;	
                  end if;
                  if counter = "10111110101111000010111111" then 
                      index := index + 4;  
                      counter <= "00000000000000000000000000";
                  end if;
				  
				  -- Animation 7: blinking of 2-letter pairs: the middle and outer two letters
                  when "111" =>                       			
                  if counter2 = "1111000000000000" then
                      if ANODES(0) = '0' then
                          ANODES(0) <= '1';
                          SEGMENT <= blink3(index);
                          ANODES(3) <= '0';	
                      elsif ANODES(3) = '0' then
                          ANODES(3) <= '1';
                          SEGMENT <= blink3(index + 1);
                          ANODES(2) <= '0';
                      elsif ANODES(2) = '0' then
                          ANODES(2) <= '1';
                          SEGMENT <= blink3(index + 2);
                          ANODES(1) <= '0';			
                      elsif ANODES(1) = '0' then
                          ANODES(1) <= '1';
                          SEGMENT <= blink3(index + 3);
                          ANODES(0)<='0';
                      end if;	
                  end if;
                          
                  if counter2 = "1111000000000000" then
                      counter2 <= "0000000000000000" ;
                  end if;
                          
                  counter2 <= counter2 + 1;
                  counter <= counter + 1;
                          
                  if index = 8 then
                      index := 0;	
                  end if;
                  if counter = "10111110101111000010111111" then 
                      index := index + 4;  
                      counter <= "00000000000000000000000000";
                  end if;
                  
              when others =>
                  ANODES <= "0000";	
                  SEGMENT <= "0001000";
              end case;
      end if;
	end process Animations;
end architecture ARCH_CS;