library IEEE;
use IEEE.std_logic_1164.all;

package cpu_types is

  --! register word (16 bits / 2 bytes)
  subtype word is std_logic_vector(15 downto 0);

  --! register half-word (8 bits / 1 byte)
  subtype halfword is std_logic_vector(7 downto 0);

  --! a 4-bit address for a CPU register
  subtype reg_addr is std_logic_vector(3 downto 0);

  --! opcode for the CPU arithmatic logic unit
  type alu_opcode is (
    ALUOP_XOR,  -- xor A^B
    ALUOP_AND,  -- and A&B
    ALUOP_OR,   -- or A|B
    ALUOP_ADD,  -- add A+B (carry/overflow flags depend on value of signed)
    ALUOP_NEG,  -- negate A by 2's comp if signed=1, by 1's comp if signed=0
    ALUOP_CMP,  -- compare A and B (A>B: 1, A<B: -1, A=B: 0)
    ALUOP_SR   -- bitshift right; arithmatic if signed=1, logical if signed=0, A>>B, B is always signed
    );
end package;
