-- <This is a template for creation of combinational VHDL testbench model, based on mux21_1_TB VHDL testbench reference>
-- <Modify for your specific design>
-- <Remove all unnecessary elements, all text within <> marks, and all <> characters>

-- Testbench title / Description 
-- Description: Testbench for ...
-- Created by: <>
-- Organisation: <>
-- Creation date: <>
-- Change History: <Initial version>

-- Reference: https://tinyurl.com/vicilogicVHDLTips   	A: VHDL IEEE library source code VHDL code
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity <design_TB_name, e.g, mux21_1_TB> is end <design_TB_name>; -- testbench has no inputs or outputs

architecture Behavioral of <design_TB_name> is -- <common TB arch name is behave, behavior, behavioral (US spelling)>
 
COMPONENT <designName, e.g, mux21_1> is
    Port ( sel 	  : in  STD_LOGIC;  
           muxIn1 : in  STD_LOGIC;  
           muxIn0 : in  STD_LOGIC;  
           muxOut : out STD_LOGIC); -- <final signal declaration terminated with  );  (can be on next line)>
END COMPONENT;

-- Declare internal testbench signals, typically the same as the component entity signals, within in/out descriptor
signal sel      : std_logic; 
signal muxIn1   : STD_LOGIC; 
signal muxIn0   : STD_LOGIC; 
signal muxOut   : STD_LOGIC;   

constant interval   : time := 20 ns;  -- simulation interval 
signal   endOfSim : boolean := false; -- Default FALSE. Assigned TRUE at end of process stim
signal   testNo   : integer;          -- facilitates test numbers. Aids locating each simulation waveform test 
 
BEGIN

-- instantiate unit under test (UUT)
uut: <designName, e.g, mux21_1> -- <include label, e.g, UUT>
-- <map the following:  component signal names (left side) => testbench signals names (right side)>
  PORT MAP (sel    => sel, 
            muxIn1 => muxIn1,
		    muxIn0 => muxIn0,
		    muxOut => muxOut);  -- <final signal declaration terminated with  );  (can be on next line)>

-- Stimulus process
stim_i: process -- no process sensitivity list to enable automatic process execution in the simulator
-- if wish to apply a pattern to a group of bits, can

-- 1. apply each bit individually, e.g, 
--    sel <= '0';
--    muxIn1 <= '0';
--    muxIn0 <= '1';
--    wait for interval; -- delay, time progresses in simulation. Can simulate for a time defined as a CONSTANT
--    muxIn0 <= '0';
--    wait for 10 ns; -- delay, time progresses in simulation. Can simulate for a specific time

-- 2. declare variable as the concatenated signals
--    variable value, declared inside a process, changes immediately on assignment in process  
--    Here, using tempVec to define the TB i/p signal vector sel, muxIn1, muxIn0
variable tempVec : std_logic_vector(2 downto 0); 
begin
    report "%N : Simulation start";
    endOfSim <= false;

    testNo <= 0; -- test number 
    -- for loop for automated stimulus application 
    -- VHDL ieee.numeric_std TO_UNSIGNED function converts i to 4-bit unsigned vector
    -- VHDL std_logic_vector(unsigned) converts type to std_logic_vector, with size the same as the unsigned vector 
    for i in 0 to 7 loop
	  tempVec := std_logic_vector(TO_UNSIGNED(i, 3)); -- generate 3-bit vector
	  sel    <= tempVec(2);  -- assign variable bits to the mux2_1 input signals
	  muxIn1 <= tempVec(1);
	  muxIn0 <= tempVec(0);
      wait for interval;        -- delay, time progresses in simulation 
    end loop; 

    testNo <= 1; -- test number 
	sel    <= '0';  -- clear all inputs
	muxIn1 <= '0';  
	muxIn0 <= '0';  
    wait for 10 ns; -- can simulate for a specific time (or use value interval)

    endOfSim <= true;   -- assert flag. Stops clk signal generation in process clkStim
    report "simulation done";   
    wait; -- include to prevent the stim process from repeating execution, since it does not include a sensitivity list
	
end process;

END behavior;