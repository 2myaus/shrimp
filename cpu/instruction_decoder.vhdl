library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! instruction address counter.
--! Increments stored address by 2 for each clock pulse, or jumps to jump_addr if jump=1 during the clock pulse
entity instruction_decoder is
  port(
    instruction_in : in word; -- instruction input

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
  process is
    -- conversions from 16bit word to useful instruction records
    pure function word_to_instr_std(word_in : word) return cpu_instruction_std is
    begin
      return (
        opcode => "0000",
        reg_operand_a => "0000",
        reg_operand_b => "0000",
        reg_c => "0000"
      );
    end function;

    pure function word_to_instr_imm(word_in : word) return cpu_instruction_imm is
    begin
      return (
        opcode => "0000",
        data => "0000",
        reg_dest => "0000"
      );
    end function;

    pure function word_to_instr_immshort(word_in : word) return cpu_instruction_immshort is
    begin
      return (
        opcode => "0000",
        reg_operand_a => "0000",
        data => "0000",
        reg_c => "0000"
      );
    end function;

    variable instruction_in_std : cpu_instruction_std := word_to_instr_std(instruction_in);
    variable instruction_in_imm : cpu_instruction_imm:= word_to_instr_imm(instruction_in);
    variable instruction_in_immshort : cpu_instruction_immshort:= word_to_instr_immshort(instruction_in);

  begin
    -- TODO
    case instruction_in_std.opcode is
    when CPUOP_AND =>
      regfile_src <= "01";
      jump <= '0';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_AND;
      reg_write <= '1';
      mem_write <= '0';
      memfile_byte <= '0';
    when CPUOP_OR =>
      regfile_src <= "01";
      jump <= '0';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_OR;
      reg_write <= '1';
      mem_write <= '0';
      memfile_byte <= '0';
    when CPUOP_XOR =>
      regfile_src <= "01";
      jump <= '0';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_XOR;
      reg_write <= '1';
      mem_write <= '0';
      memfile_byte <= '0';
    when CPUOP_ADD =>
      regfile_src <= "01";
      jump <= '0';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_ADD;
      reg_write <= '1';
      mem_write <= '0';
      memfile_byte <= '0';
    when CPUOP_SUB =>
      regfile_src <= "01";
      jump <= '0';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_SUB;
      reg_write <= '1';
      mem_write <= '0';
      memfile_byte <= '0';
    when CPUOP_CMP =>
      regfile_src <= "01";
      jump <= '0';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_CMP;
      reg_write <= '1';
      mem_write <= '0';
      memfile_byte <= '0';
    when CPUOP_NEG =>
      -- NEG 0: 1's complement (XOR 1); NEG 1: 2's complement (arithmetic negate)
      regfile_src <= "01";
      jump <= '0';
      r_a <= instruction_in_immshort.reg_operand_a;
      -- r_b <= ZERO_REG;
      r_o <= instruction_in_immshort.reg_c;
      -- imm <= (others => '0');
      alu_sign <= instruction_in_immshort.data(0);
      alu_op <= ALUOP_NEG;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_MEMORY =>
      -- MEMORY 0: read full word; MEMORY 1: write full word; MEMORY 2: read byte; MEMORY 3: write byte
      -- reg a: memory address
      -- reg c: register address for read/write
      regfile_src <= "00";
      jump <= '0';
      r_a <= instruction_in_immshort.reg_operand_a;
      r_b <= instruction_in_immshort.reg_c;
      r_o <= instruction_in_immshort.reg_c;
      -- imm <= (others => '0');
      -- alu_sign <= '0';
      -- alu_op <= ALUOP_NEG;
      case to_integer(unsigned(instruction_in_immshort.data)) is
        when 0 =>
          reg_write <= '1';
          mem_write <= '0';
          memfile_byte <='0';
        when 1 =>
          reg_write <= '0';
          mem_write <= '1';
          memfile_byte <='0';
        when 2 =>
          reg_write <= '1';
          mem_write <= '0';
          memfile_byte <='1';
        when others =>
          reg_write <= '0';
          mem_write <= '1';
          memfile_byte <='1';
      end case;
    when CPUOP_BRANCH_EQ =>
    when CPUOP_SRA =>
    when CPUOP_SRL =>
    when CPUOP_SLL =>
    when CPUOP_SRAI =>
    when CPUOP_SRLI =>
    when CPUOP_SLLI =>
    when CPUOP_LOAD_IMM =>
    end case;
  end process;
end architecture;

