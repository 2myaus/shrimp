library IEEE;
use IEEE.std_logic_1164.all;

--!
--! datatypes and utilities used in the CPU
package cpu_types is

  --! register word;
  --! generic 16-bit / 2-byte data structure used in registers
  subtype word is std_logic_vector(15 downto 0);

  --! register half-word / memory word;
  --! generic 8-bit / 2-byte data structure used in memory
  subtype halfword is std_logic_vector(7 downto 0);

  --! register quarter-word / memory half-word;
  --! generic 4-bit / half-byte data structure
  subtype quarterword is std_logic_vector(3 downto 0);

  --!
  --! a 4-bit address for a CPU register
  subtype reg_addr is std_logic_vector(3 downto 0);

  constant ZERO_REG : reg_addr := "1111";

  --!
  --! opcode for the CPU arithmatic logic unit
  subtype alu_opcode is std_logic_vector(2 downto 0);

  
  --! xor A^B -- xor A^B
  constant ALUOP_XOR : alu_opcode := "000";
  --! and A&B -- and A&B
  constant ALUOP_AND: alu_opcode := "001";
  --! or A|B -- or A|B
  constant ALUOP_OR: alu_opcode := "010";
  --! add A+B (carry/overflow flags depend on value of signed) -- add A+B (carry/overflow flags depend on value of signed)
  constant ALUOP_ADD: alu_opcode := "011";
  --! subtract A - B (carry/overflow flags depend on value of signed) -- subtract A - B (carry/overflow flags depend on value of signed)
  constant ALUOP_SUB: alu_opcode := "100";
  --! negate A by 2's comp if signed=1, by 1's comp if signed=0 -- negate A by 2's comp if signed=1, by 1's comp if signed=0
  constant ALUOP_NEG: alu_opcode := "101";
  --! compare A and B (A>B: 1, A<B: -1, A=B: 0) -- compare A and B (A>B: 1, A<B: -1, A=B: 0)
  constant ALUOP_CMP: alu_opcode := "110";
  --! arithmatic bitshift; right if signed=1, left if signed=0, B is always unsigned -- arithmatic bitshift; right if signed=1, left if signed=0, B is always unsigned
  constant ALUOP_BS: alu_opcode := "111";

  --!
  --! opcode for CPU instructions
  subtype cpu_opcode is std_logic_vector(3 downto 0);

  --! bitwise AND reg_a & reg_b to reg_c
  constant CPUOP_AND : cpu_opcode := "0000";
  
  --! bitwise OR reg_a & reg_b to reg_c
  constant CPUOP_OR : cpu_opcode := "0001";

  --! bitwise XOR reg_a & reg_b to reg_c
  constant CPUOP_XOR : cpu_opcode := "0010";

  --! add reg_a + reg_b to reg_c
  constant CPUOP_ADD : cpu_opcode := "0011";

  --! (short-immediate-type) add reg_a + imm to reg_c; imm is unsigned
  constant CPUOP_ADDI : cpu_opcode := "0100";
  
  --! subtract reg_a - reg_b to reg_c
  constant CPUOP_SUB : cpu_opcode := "0101";
  
  --! (short-immediate-type) subtract reg_a - imm to reg_c; imm is unsigned
  constant CPUOP_SUBI : cpu_opcode := "0110";

  --! compare reg_a and reg_b to reg_c (if A>B, C=1; if A<B, C=-1, if A=B, C=0)
  constant CPUOP_CMP : cpu_opcode := "0111";

  --! (short-immediate-type) negate reg_a to reg_c (if imm=0, 1's comp; if imm=1, 2's comp)
  constant CPUOP_NEG : cpu_opcode := "1000";

  /*!
    (short-immediate-type) read/write memory at address reg_a to/from reg_c with short-instant sub-op;
    MEMORY 0: read full word; MEMORY 1: write full word; MEMORY 2: read byte to MSB end; MEMORY 3: write byte from MSB end
  */
  constant CPUOP_MEMORY : cpu_opcode := "1001";

  --! jump/offset pc by reg_c if reg_a = reg_b
  constant CPUOP_BRANCH_EQ : cpu_opcode := "1010";

  --! arithmatic rightshift reg_a by reg_b to reg_c
  constant CPUOP_SRA : cpu_opcode := "1011";

  --! logical leftshift reg_a by reg_b to reg_c
  constant CPUOP_SLL : cpu_opcode := "1100";

  --! (short-immediate-type) arithmatic rightshift reg_a by imm to reg_c
  constant CPUOP_SRAI : cpu_opcode := "1101";

  --! (short-immediate-type) logical leftshift reg_a by imm to reg_c
  constant CPUOP_SLLI : cpu_opcode := "1110";

  --! (immediate-type) load imm into reg_dest/reg_c
  constant CPUOP_LOAD_IMM : cpu_opcode := "1111";

  --! 
  --! generic 16bit vector representing any binary instruction
  subtype cpu_instruction is std_logic_vector(15 downto 0);
  
  --! immediate-type CPU instruction
  type cpu_instruction_imm is record
    opcode : cpu_opcode; --! operation (i.e ADD, XOR, SLLI)
    data : halfword; --! immediate value
    reg_dest : reg_addr; --! destination register
  end record;

  --! short-immediate-type CPU instruction
  type cpu_instruction_immshort is record
    opcode : cpu_opcode; --! operation (i.e ADD, XOR, SLLI)
    reg_operand_a : reg_addr; --! operand a
    data : quarterword; --! immediate value
    reg_c : reg_addr; --! destination register or operand c
  end record;

  --! standard-type CPU instuction
  type cpu_instruction_std is record
    opcode : cpu_opcode; --! operation (i.e ADD, XOR, SLLI)
    reg_operand_a : reg_addr; --! operand a
    reg_operand_b : reg_addr; --! operand b
    reg_c: reg_addr; --! destination register or operand c
  end record;

end package;
