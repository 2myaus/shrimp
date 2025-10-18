library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

use work.cpu_types.all;
use work.testvec_data.all;

entity cpu_tb is
  generic(
    debug_logs : boolean := false
  );
end entity;

architecture cpu_tb_a of cpu_tb is
  signal clock : std_logic := '0';

  signal memadd1 : word := "0000000010000000";
  signal memadd2 : word := "0000000010000001";

  signal memin1 : halfword := "00000000";
  signal memin2 : halfword := "00000000";
  
  signal memout1 : halfword := "00000000";
  signal memout2 : halfword := "00000000";

  signal memw1 : std_logic := '0';
  signal memw2 : std_logic := '0';

  constant mem_size : integer := (2**word'length) * halfword'length;
  
  constant mem_data_in : std_logic_vector(mem_size - 1 downto 0) := (
    testvec'range => testvec,
    others => '0'
  );

begin
  cpu_inst: entity work.cpu
    generic map(
      debug_logs => debug_logs,
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

  process(memout2) is
  begin
    report "mem_val_2=" & integer'image(to_integer(unsigned(memout2)));
  end process;

  process(memout1) is
  begin
    report "mem_val_1=" & integer'image(to_integer(unsigned(memout1)));
  end process;
end architecture;
