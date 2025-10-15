library IEEE;
use IEEE.std_logic_1164.all;

package cpu_types is

  --! register word (16 bits / 2 bytes)
  subtype word is std_logic_vector(15 downto 0);

  --! register half-word (8 bits / 1 byte)
  subtype halfword is std_logic_vector(7 downto 0);

  --! register quarter-word (4 bits)
  subtype quarterword is std_logic_vector(3 downto 0);

  --! a 4-bit address for a CPU register
  subtype reg_addr is std_logic_vector(3 downto 0);

  --! opcode for the CPU arithmatic logic unit
  subtype alu_opcode is std_logic_vector(2 downto 0);
  constant ALUOP_XOR : alu_opcode := "000"; -- xor A^B
  constant ALUOP_AND: alu_opcode := "001"; -- and A&B
  constant ALUOP_OR: alu_opcode := "010"; -- or A|B
  constant ALUOP_ADD: alu_opcode := "011"; -- add A+B (carry/overflow flags depend on value of signed)
  constant ALUOP_SUB: alu_opcode := "100"; -- compare A and B (A>B: 1, A<B: -1, A=B: 0)
  constant ALUOP_NEG: alu_opcode := "101"; -- negate A by 2's comp if signed=1, by 1's comp if signed=0
  constant ALUOP_CMP: alu_opcode := "110"; -- compare A and B (A>B: 1, A<B: -1, A=B: 0)
  constant ALUOP_SR: alu_opcode := "111"; -- bitshift right; arithmatic if signed=1, logical if signed=0, A>>B, B is always signed
  
  --! opcode for CPU instructions
  subtype cpu_opcode is std_logic_vector(3 downto 0);
  constant CPUOP_AND : cpu_opcode := "0000"; -- bitwise AND A&B
  constant CPUOP_OR : cpu_opcode := "0001"; -- OR A|B
  constant CPUOP_XOR : cpu_opcode := "0010"; -- XOR A^B
  constant CPUOP_ADD : cpu_opcode := "0011"; -- add A+B
  constant CPUOP_SUB : cpu_opcode := "0100"; -- subtract A-B
  constant CPUOP_CMP : cpu_opcode := "0101"; -- <, >, or =
  constant CPUOP_NEG : cpu_opcode := "0110"; -- (short-immediate-type) negate
  -- NEG 0: 1's complement (XOR 1); NEG 1: 2's complement (arithmetic negate)
  constant CPUOP_MEMORY : cpu_opcode := "0111"; -- (short-immediate-type) interface with memory
  -- MEMORY 0: read full word; MEMORY 1: write full word; MEMORY 2: read byte; MEMORY 3: write byte
  constant CPUOP_BRANCH_EQ : cpu_opcode := "1000"; -- jump to position if equal
  constant CPUOP_SRA : cpu_opcode := "1001"; -- arithmatic rightshift
  constant CPUOP_SRL : cpu_opcode := "1010"; -- logical rightshift
  constant CPUOP_SLL : cpu_opcode := "1011"; -- logical leftshift
  constant CPUOP_SRAI : cpu_opcode := "1100"; -- (short-immediate-type) arithmatic rightshift
  constant CPUOP_SRLI : cpu_opcode := "1101"; -- (short-immediate-type) logical rightshift
  constant CPUOP_SLLI : cpu_opcode := "1110"; -- (short-immediate-type) logical leftshift
  constant CPUOP_LOAD_IMM : cpu_opcode := "1111"; -- (immediate-type) Load immediate value

  --! immediate-type CPU instruction
  type cpu_instruction_imm is record
    opcode : cpu_opcode; -- opcode
    data : halfword; -- immediate value
    reg_dest : reg_addr; -- destination register
  end record;

  --! short-immediate-type CPU instruction
  type cpu_instruction_immshort is record
    opcode : cpu_opcode; -- opcode
    reg_operand_a : reg_addr; -- operand a
    data : quarterword; -- immediate value
    reg_dest : reg_addr; -- destination register
  end record;

  --! standard-type CPU instuction
  type cpu_instruction_std is record
    opcode : cpu_opcode;
    reg_operand_a : reg_addr; -- operand a
    reg_operand_b : reg_addr; -- operand b
    reg_c: reg_addr; -- destination register or operand c
  end record;

end package;
