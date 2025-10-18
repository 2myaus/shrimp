library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! internal CPU registers, there are 16. addressed with 4 bits
entity regfile is
  generic(
    debug_logs : boolean := false
  );
  port(
    reg_r_a : in reg_addr;
    reg_r_b : in reg_addr;
    reg_w : in reg_addr; -- Register to write to
    write_val : in word; -- Value that gets written to reg_w
    reg_write_enable : in std_logic; -- Whether to write on clock signal
    clock : in std_logic;

    reg_r_a_val : out word; -- Value in reg_r_a
    reg_r_b_val : out word;  -- Value in reg_r_b
    reg_w_val : out word  -- Value in reg_w
  );
end entity;


architecture regfile_a of regfile is
  signal reg_r_a_mod : word := "0000000000000000";
  signal reg_r_b_mod : word := "0000000000000000";
  signal reg_w_mod : word := "0000000000000000";
begin
  reg_r_a_val <= (others => '0') when reg_r_a = ZERO_REG else reg_r_a_mod;
  reg_r_b_val <= (others => '0') when reg_r_b = ZERO_REG else reg_r_b_mod;
  reg_w_val <= (others => '0') when reg_w = ZERO_REG else reg_w_mod;

  m1 : entity work.memfile generic map(
    debug_logs => debug_logs,
    channels => 3,
    address_width => reg_addr'length,
    word_width => word'length,
    data => ((2**reg_addr'length)*word'length-1 downto 0 => '0')
  ) port map(
    in_addrs(reg_addr'length-1 downto 0) => reg_r_a,
    in_addrs(reg_addr'length*2-1 downto reg_addr'length) => reg_r_b,
    in_addrs(reg_addr'length*3-1 downto reg_addr'length*2) => reg_w,
    write_vals(word'length*3-1 downto word'length*2) => write_val,
    write_vals(word'length*2-1 downto 0) => (others => '0'),
    write_enable(0) => '0',
    write_enable(1) => '0',
    write_enable(2) => reg_write_enable,
    clock => clock,
    read_vals(word'length-1 downto 0) => reg_r_a_mod,
    read_vals(word'length*2-1 downto word'length) => reg_r_b_mod,
    read_vals(word'length*3-1 downto word'length*2) => reg_w_mod
  );
end architecture;
