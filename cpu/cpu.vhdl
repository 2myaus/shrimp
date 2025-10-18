library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

entity cpu is
  generic(
    debug_logs : boolean := false;
    mem_data : std_logic_vector((2**word'length) * halfword'length - 1 downto 0) := (others => '0');
    program_start_addr : word := (others => '0')
  );
  port(
    clock : in std_logic;
    memory_addr1 : in word;
    memory_addr2 : in word;
    memory_in_val1 : in halfword; -- for writing
    memory_in_val2 : in halfword; -- for writing
    memory_write1 : in std_logic;
    memory_write2 : in std_logic;

    memory_out_val1 : out halfword;
    memory_out_val2 : out halfword
  );
end entity;

architecture cpu_a of cpu is
  signal clock_wire : std_logic := '0';
  signal instruction_wire : cpu_instruction := "0000000000000000";
  signal regfile_src_wire : std_logic := '0';
  signal increment_counter_wire : std_logic := '0';
  signal reg1_wire : reg_addr := ZERO_REG;
  signal reg2_wire : reg_addr := ZERO_REG;
  signal rego_wire : reg_addr := ZERO_REG;
  signal immediate_wire : halfword := "00000000";
  signal alusign_wire : std_logic := '0';
  signal aluop_wire : alu_opcode := ALUOP_XOR;
  signal regw_wire : std_logic := '0';
  signal memw_wire : std_logic := '0';
  signal membyte_wire : std_logic := '0';
  signal alusrc_b_wire : std_logic := '0';
  signal instruction_address_1_wire : word := "0000000000000000";
  signal instruction_address_2_wire : word := "0000000000000000";
  signal instruction_offset_wire : word := "0000000000000000";
  signal mem_address_wire : word := "0000000000000000";
  signal mem_address2_wire : word := "0000000000000000";
  signal reg_val1_wire : word := "0000000000000000";
  signal reg_val2_wire : word := "0000000000000000";
  signal reg_val3_wire : word := "0000000000000000";
  signal memval_wire : word := "0000000000000000";
  signal memval_byte2_wire : halfword := "00000000";
  signal reg_in_wire : word := "0000000000000000";
  signal alub_wire : word := "0000000000000000";
  signal alures_wire : word := "0000000000000000";
  signal memw2_wire : std_logic := '0';
begin
  clock_wire <= clock;

  instruction_decoder_inst : entity work.instruction_decoder
    generic map(
      debug_logs => debug_logs
    )
    port map(
      instruction_in => instruction_wire,
      alu_b_src => alusrc_b_wire,
      regfile_src => regfile_src_wire,
      inc_counter => increment_counter_wire,
      r_a => reg1_wire,
      r_b => reg2_wire,
      r_o => rego_wire,
      imm => immediate_wire,
      alu_sign => alusign_wire,
      alu_op => aluop_wire,
      reg_write => regw_wire,
      mem_write => memw_wire,
      memfile_byte => membyte_wire
  );

  instruction_counter_inst : entity work.instruction_counter
    generic map(
      start_addr => program_start_addr
    )
    port map(
      offset => instruction_offset_wire,
      increment => increment_counter_wire,
      clock => clock_wire,
      instruction_addr => instruction_address_1_wire,
      instruction_addr_2 => instruction_address_2_wire
    );

  mem_address_wire <= reg_val1_wire;
  mem_address2_wire <= std_logic_vector(to_unsigned(to_integer(unsigned(mem_address_wire)) + 1, word'length));
  memval_wire(halfword'length-1 downto 0) <= memval_byte2_wire and (memval_byte2_wire'length-1 downto 0 => (not membyte_wire));

  memw2_wire <= memw_wire and (not membyte_wire);
  memfile_inst: entity work.memfile
    generic map(
      debug_logs => debug_logs,
      channels => 6,
      address_width => word'length,
      word_width => halfword'length,
      data => mem_data
    )
    port map(
      in_addrs(word'length-1 downto 0) => mem_address_wire,
      in_addrs(word'length*2-1 downto word'length) => mem_address2_wire,
      in_addrs(word'length*3-1 downto word'length*2) => instruction_address_1_wire,
      in_addrs(word'length*4-1 downto word'length*3) => instruction_address_2_wire,
      in_addrs(word'length*5-1 downto word'length*4) => memory_addr1,
      in_addrs(word'length*6-1 downto word'length*5) => memory_addr2,
      write_vals(halfword'length*2-1 downto 0) => reg_val2_wire,
      write_vals(halfword'length*4-1 downto halfword'length*2) => (others => '0'),
      write_vals(halfword'length*5-1 downto halfword'length*4) => memory_in_val1,
      write_vals(halfword'length*6-1 downto halfword'length*5) => memory_in_val2,
      write_enable(0) => memw_wire,
      write_enable(1) => memw2_wire,
      write_enable(2) => '0',
      write_enable(3) => '0',
      write_enable(4) => memory_write1,
      write_enable(5) => memory_write2,
      clock => clock_wire,
      read_vals(halfword'length-1 downto 0) => memval_wire(halfword'length*2-1 downto halfword'length),
      read_vals(halfword'length*2-1 downto halfword'length) => memval_byte2_wire,
      read_vals(halfword'length*4-1 downto halfword'length*2) => instruction_wire,
      read_vals(halfword'length*5-1 downto halfword'length*4) => memory_out_val1,
      read_vals(halfword'length*6-1 downto halfword'length*5) => memory_out_val2
  );

  reg_in_wire <= alures_wire when regfile_src_wire='1' else memval_wire;
  regfile_inst: entity work.regfile
    generic map(
      debug_logs => false --debug_logs
    )
    port map(
      reg_r_a => reg1_wire,
      reg_r_b => reg2_wire,
      reg_w => rego_wire,
      write_val => reg_in_wire,
      reg_write_enable => regw_wire,
      clock => clock_wire,
      reg_r_a_val => reg_val1_wire,
      reg_r_b_val => reg_val2_wire,
      reg_w_val => reg_val3_wire
  );

  alub_wire(7 downto 0) <= reg_val2_wire(7 downto 0) when alusrc_b_wire='0' else immediate_wire; 
  alub_wire(15 downto 8) <= reg_val2_wire(15 downto 8) when alusrc_b_wire='0' else (others => '0'); 
  alu_inst: entity work.alu
    port map(
      do_signed => alusign_wire,
      opcode => aluop_wire,
      operand_a => reg_val1_wire,
      operand_b => alub_wire,
      result => alures_wire
      -- overflow => overflow,
      -- carry => carry
  );

  process(clock) is begin
    if rising_edge(clock) then
      report "running instruction " & to_hstring(instruction_wire) & " AKA " & to_bstring(instruction_wire);
    end if;
  end process;
end architecture;
