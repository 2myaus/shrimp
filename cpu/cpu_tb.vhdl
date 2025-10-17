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
  
  signal memout1 : halfword;
  signal memout2 : halfword;

  signal memw1 : std_logic := '0';
  signal memw2 : std_logic := '0';

  signal count : integer := 0;

begin
  cpu_inst: entity work.cpu
    generic map(
      -- mem_data(15 downto 0) => (15 downto 12 => CPUOP_LOAD_IMM, 11 downto 4 => "11111111", 3 downto 0 => "0000"), -- load 1s into reg 0
      -- mem_data(31 downto 16) => (15 downto 12 => CPUOP_LOAD_IMM, 11 downto 4 => "00001000", 3 downto 0 => "0001"), -- load mem address into reg 1
      -- mem_data(47 downto 32) => (15 downto 12 => CPUOP_MEMORY, 11 downto 8 => "0001", 7 downto 4 => "0001", 3 downto 0 => "0000"), -- store 1s into mem address
      mem_data(15 downto 0) => "1111111111110000",
      mem_data(31 downto 16) => "1111000010000001",
      mem_data(47 downto 32) => "1001000100010000",
      mem_data((2**word'length)*halfword'length-1 downto 48) => (others => '0'),
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
  process is
  begin
    clock <= not clock;
    count <= count + 1;
    report "mem_val=" & integer'image(to_integer(unsigned(memout1)));
    report "mem_val=" & integer'image(to_integer(unsigned(memout2)));
    wait for 100 ns;
    if count = 10 then
      wait until false;
    end if;
  end process;
end architecture;
