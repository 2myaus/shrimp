library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! instruction address counter.
--! Increments stored address by 2 for each clock pulse, or jumps to jump_addr if jump=1 during the clock pulse
entity instruction_decoder is
  port(
    instruction_in : in cpu_instruction_std; -- instruction input

    regfile_src : out std_logic_vector(1 downto 0); -- source for regfile input (00: memfile, 01: alu, 10: immediate)
    jump : out std_logic; -- connects to instruction counter; whether to jump to the jump address
    r_a : out reg_addr; -- register addr/operand a
    r_b : out reg_addr; -- register addr/operand b
    r_o : out reg_addr; -- register addr/output/operand c
    imm : out halfword; -- immediate value
    alu_sign : out std_logic; -- sign value for ALU
    alu_op : out alu_opcode;
    reg_write : out std_logic; -- whether to write to regfile
    mem_write : out std_logic; -- whether to write to memfile
    memfile_byte: out std_logic -- whether to use bytes or words in memfile
  );
end entity;

architecture instruction_decoder_a of instruction_decoder is
begin
  process is begin
    -- TODO
    case instruction_in.opcode is
      when CPUOP_AND =>
      when CPUOP_OR =>
      when CPUOP_XOR =>
      when CPUOP_ADD =>
      when CPUOP_SUB =>
      when CPUOP_CMP =>
      when CPUOP_NEG =>
      when CPUOP_WRITE_MEM_WORD =>
      when CPUOP_WRITE_MEM_BYTE =>
      when CPUOP_READ_MEM_WORD =>
      when CPUOP_READ_MEM_BYTE =>
      when CPUOP_BRANCH_EQ =>
      when CPUOP_SRA =>
      when CPUOP_SRL =>
      when CPUOP_SLL =>
      when CPUOP_LOAD_IMM =>
      when others =>
    end case;
  end process;
end architecture;
