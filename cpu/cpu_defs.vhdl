library IEEE;
use IEEE.std_logic_1164.all;

use work.reg_defs.all;

package cpu_defs is

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
    ALUOP_ADD,  -- add unsigned A+B
    ALUOP_NEG,  -- negate by 2's comp -A
    ALUOP_CMP,  -- compare A>B (in LSB 001 A>B, 010 A<B, 100 A=B)
    ALUOP_SLL,  -- bitshift left logical A<<B
    ALUOP_SRL,  -- bitshift right logical A>>B
    ALUOP_SRA   -- bitshift right arithmatic A>>>B
  );

  --! CPU arithmatic logic unit. does basic combinational arithmetic
  component alu is
  port(
    opcode : in alu_opcode;
    operand_a : in word;
    operand_b : in word;
    result : out word
  );
  end component;

  --! internal CPU registers, there are 16. addressed with 4 bits
  component regfile is
  port(
    reg_r_a : in reg_addr;
    reg_r_b : in reg_addr;
    reg_w : in reg_addr; -- Register to write to
    write_val : in word; -- Value that gets written to reg_w
    write_enable : in word; -- Whether to write on clock signal
    clock : in std_logic;

    reg_r_a_val : out word; -- Value in reg_r_a
    reg_r_b_val : out word  -- Value in reg_r_b
  );
  end component;

  --! memory / RAM
  component memfile is
  port(
    in_addr : in word; -- address for reading and writing
    write_val : in word; -- value to write to in_addr
    write_enable : in std_logic; -- whether to update memory address on clock
    clock : in std_logic;

    read_val : out word -- address currently at in_addr
  );
  end component;
end package;
