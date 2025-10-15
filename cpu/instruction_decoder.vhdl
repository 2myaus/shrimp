library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! instruction decoder
--! configures connnections and provides values to CPU components based on the instruction input
entity instruction_decoder is
  port(
    instruction_in : in word; -- instruction input

    alu_b_src: out std_logic; -- source for alu_b input (0: regfile value 2, 1: immediate)
    regfile_src : out std_logic_vector(1 downto 0); -- source for regfile input (00: memfile, 01: alu, 10: immediate)
    inc_counter: out std_logic; -- connects to instruction counter; whether to increment address or otherwise defer to regfile_src output
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
        opcode => word_in(15 downto 12),
        reg_operand_a => word_in(11 downto 8),
        reg_operand_b => word_in(7 downto 4),
        reg_c => word_in(3 downto 0)
      );
    end function;

    pure function word_to_instr_imm(word_in : word) return cpu_instruction_imm is
    begin
      return (
        opcode => word_in(15 downto 12),
        data => word_in(11 downto 4),
        reg_dest => word_in(3 downto 0)
      );
    end function;

    pure function word_to_instr_immshort(word_in : word) return cpu_instruction_immshort is
    begin
      return (
        opcode => word_in(15 downto 12),
        reg_operand_a => word_in(11 downto 8),
        data => word_in(7 downto 4),
        reg_c => word_in(3 downto 0)
      );
    end function;

    variable instruction_in_std : cpu_instruction_std := word_to_instr_std(instruction_in);
    variable instruction_in_imm : cpu_instruction_imm:= word_to_instr_imm(instruction_in);
    variable instruction_in_immshort : cpu_instruction_immshort:= word_to_instr_immshort(instruction_in);

  begin
    -- TODO
    case instruction_in_std.opcode is
    when CPUOP_AND =>
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      -- imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_AND;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_OR =>
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      -- imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_OR;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_XOR =>
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      -- imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_XOR;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_ADD =>
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      -- imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_ADD;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_ADDI =>
      -- (short-immediate-type) add reg_a + imm to reg_c; imm is unsigned
      alu_b_src <= '1'; -- immediate source for alu b
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_immshort.reg_operand_a;
      -- r_b <= ZERO_REG;
      r_o <= instruction_in_immshort.reg_c;
      imm <= (7 downto 0 => instruction_in_immshort.data, others => '0');
      alu_sign <= '1';
      alu_op <= ALUOP_ADD;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_SUB =>
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      -- imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_SUB;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';

    when CPUOP_SUBI =>
      -- (short-immediate-type) subtract reg_a - imm to reg_c; imm is unsigned
      alu_b_src <= '1'; -- immediate source for alu b
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_immshort.reg_operand_a;
      -- r_b <= ZERO_REG;
      r_o <= instruction_in_immshort.reg_c;
      imm <= (7 downto 0 => instruction_in_immshort.data, others => '0');
      alu_sign <= '1';
      alu_op <= ALUOP_SUB;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_CMP =>
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      -- imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_CMP;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_NEG =>
      -- NEG 0: 1's complement (XOR 1); NEG 1: 2's complement (arithmetic negate)
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
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
      -- alu_b_src <= '0';
      regfile_src <= "00";
      inc_counter <= '1';
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
      alu_b_src <= '0';
      regfile_src <= "01"; -- select ALU
      inc_counter <= '0'; -- allow ALU to control jump
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      reg_write <= '0';
      mem_write <= '0';
      -- memfile_byte <= '0';
      -- imm <= (others => '0');
      -- alu_sign <= '0';
      -- alu_op <= ALUOP_NEG;

    when CPUOP_SRA =>
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      -- imm <= (others => '0');
      alu_sign <= '1';
      alu_op <= ALUOP_BS;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    -- when CPUOP_SRL =>
    when CPUOP_SLL =>
      alu_b_src <= '0';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_std.reg_operand_a;
      r_b <= instruction_in_std.reg_operand_b;
      r_o <= instruction_in_std.reg_c;
      -- imm <= (others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_BS;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_SRAI =>
      alu_b_src <= '1';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_immshort.reg_operand_a;
      -- r_b <= ZERO_REG;
      r_o <= instruction_in_immshort.reg_c;
      imm <= (7 downto 0 => instruction_in_immshort.data, others => '0');
      alu_sign <= '1';
      alu_op <= ALUOP_BS;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_SLLI =>
      alu_b_src <= '1';
      regfile_src <= "01";
      inc_counter <= '1';
      r_a <= instruction_in_immshort.reg_operand_a;
      -- r_b <= ZERO_REG;
      r_o <= instruction_in_immshort.reg_c;
      imm <= (7 downto 0 => instruction_in_immshort.data, others => '0');
      alu_sign <= '0';
      alu_op <= ALUOP_BS;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    when CPUOP_LOAD_IMM =>
      alu_b_src <= '1';
      regfile_src <= "01";
      inc_counter <= '1';
      -- r_a <= ZERO_REG;
      -- r_b <= ZERO_REG;
      r_o <= instruction_in_imm.reg_dest;
      imm <= instruction_in_imm.data;
      -- alu_sign <= '0';
      -- alu_op <= ALUOP_BS;
      reg_write <= '1';
      mem_write <= '0';
      -- memfile_byte <= '0';
    end case;
  end process;
end architecture;

