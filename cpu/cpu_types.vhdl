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
  subtype alu_opcode is std_logic_vector(2 downto 0);
  constant ALUOP_XOR : alu_opcode := "000"; -- xor A^B
  constant ALUOP_AND: alu_opcode := "001"; -- and A&B
  constant ALUOP_OR: alu_opcode := "010"; -- or A|B
  constant ALUOP_ADD: alu_opcode := "011"; -- add A+B (carry/overflow flags depend on value of signed)
  constant ALUOP_NEG: alu_opcode := "100"; -- negate A by 2's comp if signed=1, by 1's comp if signed=0
  constant ALUOP_CMP: alu_opcode := "101"; -- compare A and B (A>B: 1, A<B: -1, A=B: 0)
  constant ALUOP_SR: alu_opcode := "111"; -- bitshift right; arithmatic if signed=1, logical if signed=0, A>>B, B is always signed
  
  --! opcode for CPU instructions
  subtype cpu_opcode is std_logic_vector(3 downto 0);
  constant CPUOP_AND : cpu_opcode := "0000"; -- bitwise AND A&B
  constant CPUOP_OR : cpu_opcode := "0001"; -- OR A|B
  constant CPUOP_XOR : cpu_opcode := "0010"; -- XOR A^B
  constant CPUOP_ADD : cpu_opcode := "0011"; -- add A+B
  constant CPUOP_SUB : cpu_opcode := "0100"; -- subtract A-B
  constant CPUOP_CMP : cpu_opcode := "0101"; -- <, >, or =
  constant CPUOP_NEG : cpu_opcode := "0110"; -- negate
  constant CPUOP_WRITE_MEM_WORD : cpu_opcode := "0111"; -- full register
  constant CPUOP_WRITE_MEM_BYTE : cpu_opcode := "1000"; -- least significant 8 bits
  constant CPUOP_READ_MEM : cpu_opcode := "1001"; -- read full 16bit word from memory
  constant CPUOP_BRANCH_EQ : cpu_opcode := "1010"; -- on some condition
  constant CPUOP_SYSCALL : cpu_opcode := "1011";
  constant CPUOP_SRA : cpu_opcode := "1100"; -- arithmatic rightshift
  constant CPUOP_SRL : cpu_opcode := "1101"; -- logical rightshift
  constant CPUOP_SLL : cpu_opcode := "1110"; -- logical leftshift
  constant CPUOP_LOAD_IMM   : cpu_opcode := "1111"; -- (immediate-type) Load immediate value

end package;
