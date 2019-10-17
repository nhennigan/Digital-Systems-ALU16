-- Title / Description / Signal dictionary
-- Description: Testbench for Arithmetic and Logical Unit 
-- Authors: Fearghal Morgan, National University of Ireland, Galway 
-- Date: 16/9/2019
-- Change History: Original

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY ALU16_TB IS END ALU16_TB;
 
architecture behave of ALU16_TB is
COMPONENT ALU16 is
    Port ( A        : in STD_LOGIC_VECTOR (15 downto 0);
           B        : in STD_LOGIC_VECTOR (15 downto 0);
           opCode    : in STD_LOGIC_VECTOR (4 downto 0);
           carryIn  : in STD_LOGIC;
           ALUOut   : out STD_LOGIC_VECTOR (15 downto 0);
           carryOut : out STD_LOGIC 
		  ); 
END COMPONENT;

-- declare testbench signals

signal A        :  STD_LOGIC_VECTOR (15 downto 0);
signal B        :  STD_LOGIC_VECTOR (15 downto 0);
signal opCode   : STD_LOGIC_VECTOR (4 downto 0);
signal carryIn  :  STD_LOGIC;
--signal ALUOut   :  STD_LOGIC_VECTOR (15 downto 0):= ("0000000000000000");
signal ALUOut   :  STD_LOGIC_VECTOR (15 downto 0);
signal carryOut :  STD_LOGIC;

signal testNo   : integer; -- test numbers aid locating each simulation waveform test 
signal  endOfSim : boolean := false;  -- assert at end of simulation to show end point
 
BEGIN
-- Instantiate the Unit Under Test (UUT)
uut: ALU16
    PORT MAP (
              A      => A,
              B      => B,
              opCode => opCode,
              carryIn => carryIn,
              ALUOut  => ALUOut,
              carryOut => carryOut);

--setALUout_i: ALUOut <= "0000000000000000";
stim_i1: process -- Stimulus process

variable opCodeVar : std_logic_vector(4 downto 0);
begin
   report "%N : Simulation start";
   endOfSim <= false;
   carryIn <= '0';

   testNo <= 0; 
  
   A <= "0000000000000000";
   B <= "0000000000000000";
   opCode <= "00000";
   wait for 10ns;
   A <= "0000000000000001";
   B <= "0000000000000011";
  
  carryIn <='1';
   for i in 0 to 7 loop
    opCode <= std_logic_vector(to_unsigned(i,5));
         A <= "0000000000000001";
        B <= "0000000000000011";
    wait for 10 ns;
   end loop;
   
  testNo <=1;
  carryIn <= '0';
  for j in 16 to 27 loop
      opCode <=std_logic_vector(to_unsigned(j,5));
      A <="0000000000000001";
      B <="0000000000000011";
      wait for 10 ns;
     end loop;
   
  endOfSim <= true;
  report "%N : Simulation end";
   
   wait;
   
end process;


END;