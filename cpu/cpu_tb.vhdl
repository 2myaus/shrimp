library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

entity cpu_tb is
end entity;

architecture cpu_tb_a of cpu_tb is
  signal clock : std_logic := '0';

  signal memadd1 : word := "0000000000001000";
  signal memadd2 : word := "0000000000001001";

  signal memin1 : halfword := "00000000";
  signal memin2 : halfword := "00000000";
  
  signal memout1 : halfword := "00000000";
  signal memout2 : halfword := "00000000";

  signal memw1 : std_logic := '0';
  signal memw2 : std_logic := '0';

  constant instr1 : std_logic_vector(cpu_instruction'range) := (15 downto 12 => CPUOP_LOAD_IMM, 11 downto 4 => "11111111", 3 downto 0 => "0000"); -- load 1s into reg 0
  constant instr2 : std_logic_vector(cpu_instruction'range) := (15 downto 12 => CPUOP_LOAD_IMM, 11 downto 4 => "00001000", 3 downto 0 => "0001"); -- load mem addr into reg 1
  constant instr3 : std_logic_vector(cpu_instruction'range) := (15 downto 12 => CPUOP_MEMORY, 11 downto 8 => "0001", 7 downto 4 => "0001", 3 downto 0 => "0000"); -- store 1s into mem address

  constant mem_data_in : std_logic_vector((2**word'length) * halfword'length - 1 downto 0) := (
    15 downto 0 => instr1,
    31 downto 16 => instr2,
    47 downto 32 => instr3,
    others => '0'
  );
begin
  cpu_inst: entity work.cpu
    generic map(
      mem_data => mem_data_in,
      program_start_addr => (others => '0')
    )
    port map(
      clock => clock,
      memory_addr1 => memadd1,
      memory_addr2 => memadd2,
      memory_in_val1 => memin1,
      memory_in_val2 => memin2,
      memory_write1 => memw1,
      memory_write2 => memw2,
      memory_out_val1 => memout1,
      memory_out_val2 => memout2
  );
  
  
  clock_cycle: process is begin
    wait for 100 ns;
    clock <= not clock;
    report "clock=" & std_logic'image(clock);
  end process clock_cycle;

  process(memout1, memout2) is
  begin
    report "mem_val_1=" & integer'image(to_integer(unsigned(memout1)));
    report "mem_val_2=" & integer'image(to_integer(unsigned(memout2)));
  end process;
end architecture;
