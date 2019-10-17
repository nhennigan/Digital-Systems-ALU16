-- Title / Description / Signal dictionary
-- Description: 16-bit ALU (ALU16), including 16-to-1 Multiplexer for output select
-- Authors: Niamh Hennigan, National University of Ireland, Galway 
-- Date: 29/9/2019
-- Change History: Original
-- 
-- Specification, including context diagram, signal dictionary and function tables
--   http://vicilogic.com/static/ext/FODS/ALU16/ALU16%20Design%20Specification.pdf
-- Design docs
--   https://vicilogic.com/static/ext/FODS/ALU16/ALU16%20Design%20Data%20Flow%20Diagram%20Level%200%20(DFD0).pdf
--   https://vicilogic.com/static/ext/FODS/ALU16/ALU16%20Design%20Functional%20Partition%20(FP).pdf
-- vicilogic ALU16 lesson (Sept 2019) 
--   https://www.vicilogic.com/vicilearn/run_step/?c_id=22&c_pos=130


-- Reference: https://tinyurl.com/vicilogicVHDLTips   	A: VHDL IEEE library source code VHDL code
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ALU16 is
    Port ( opCode   : in STD_LOGIC_VECTOR (4 downto 0);
           A        : in STD_LOGIC_VECTOR (15 downto 0);
           B        : in STD_LOGIC_VECTOR (15 downto 0);
           carryIn  : in STD_LOGIC;
           ALUOut   : out STD_LOGIC_VECTOR (15 downto 0);
           carryOut : out STD_LOGIC 
		  );
end ALU16;

architecture combinational of ALU16 is
-- Reference: https://tinyurl.com/vicilogicVHDLTips  	C: Signal declaration examples
-- declare internal signals
signal selLogical : STD_LOGIC;
signal pickArith : STD_LOGIC_VECTOR (2 downto 0);
signal logicalOut : STD_LOGIC_VECTOR (15 downto 0);
signal arithOut17 : STD_LOGIC_VECTOR (16 downto 0);
signal picklogic : STD_LOGIC_VECTOR (3 downto 0);
signal carryInVec: STD_LOGIC_VECTOR (16 downto 0);

begin
asgnSelLogical_i: selLogical <= opCode(4);

--change selLogical to ALUOut 
logicalUnit_i: process (A,B,opCode)
begin
picklogic <= opCode(3 downto 0);
if opCode(3 downto 0) = "0000" then
    logicalOut <= A;
elsif opCode(3 downto 0) = "0001" then 
    logicalOut <= B;
elsif opCode(3 downto 0) = "0010" then 
    logicalOut <= not A; 
elsif opCode(3 downto 0) = "0011" then 
    logicalOut <= not B; 
elsif opCode(3 downto 0) = "0100" then 
    logicalOut <= A and B;
elsif opCode(3 downto 0) = "0101" then 
    logicalOut <= A or B;
elsif opCode(3 downto 0) = "0110" then 
    logicalOut <= A xor B;
elsif opCode(3 downto 0) = "0111" then 
    logicalOut <= not (A and B);
elsif opCode(3 downto 0) = "1000" then 
    logicalOut <= not (A or B);
elsif opCode(3 downto 0) = "1001" then 
    logicalOut <= not (A xor B);
else 
    logicalOut <= A;      
end if;
end process;


--arithUnit_i:      arithOut17 <=  
arithUnit_i: process (A,B,carryIn,opCode)
begin
pickArith <= opCode( 2 downto 0);
carryInVec(0) <= carryIn;
carryInVec(16 downto 1) <= "0000000000000000";

if opCode( 2 downto 0) = "000" then
    arithOut17 <= '0'&A;
elsif opCode( 2 downto 0) = "001" then 
    arithOut17 <= std_logic_vector( unsigned('0'&A) + unsigned('0'&B) + unsigned(carryInVec) );
elsif opCode( 2 downto 0) = "010" then 
    arithOut17 <= std_logic_vector( unsigned('0'&A) - 1); 
elsif opCode( 2 downto 0) = "011" then 
    arithOut17 <= std_logic_vector(unsigned('0'&A) + 1); 
elsif opCode( 2 downto 0) = "100" then 
    arithOut17 <= std_logic_vector(unsigned('0'&A) - unsigned(B));
else  
    arithOut17 <= '0'&A ;
end if;
end process;

selALUOut_i:
with selLogical select 
    ALUOut <= arithOut17(15 downto 0) when '0',
    logicalOut when others;


--asgnCarryOut_i:   carryOut   <= 
asgnCarryOut_i: carryOut <= arithOut17(16);

end combinational;