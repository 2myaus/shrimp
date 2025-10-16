library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! internal CPU registers, there are 16. addressed with 4 bits
entity regfile is
  port(
    reg_r_a : in reg_addr;
    reg_r_b : in reg_addr;
    reg_w : in reg_addr; -- Register to write to
    write_val : in word; -- Value that gets written to reg_w
    write_enable : in std_logic; -- Whether to write on clock signal
    clock : in std_logic;

    reg_r_a_val : out word; -- Value in reg_r_a
    reg_r_b_val : out word;  -- Value in reg_r_b
    reg_w_val : out word  -- Value in reg_w
  );
end entity;


architecture regfile_a of regfile is
  signal reg_r_a_mod : std_logic_vector(3 downto 0);
  signal reg_r_b_mod : std_logic_vector(3 downto 0);
  signal reg_w_mod : std_logic_vector(3 downto 0);
begin
  process is begin
    if reg_r_a = ZERO_REG then
      reg_r_a_val <= (others => '0');
    else
      reg_r_a_val <= reg_r_a_mod;
    end if;

    if reg_r_b = ZERO_REG then
      reg_r_b_val <= (others => '0');
    else
      reg_r_b_val <= reg_r_b_mod;
    end if;

    if reg_w = ZERO_REG then
      reg_w_val <= (others => '0');
    else
      reg_w_val <= reg_w_mod;
    end if;
  end process;

  m1 : entity work.memfile generic map(
    channels => 3,
    address_width => 4,
    word_width => 16
  ) port map(
    in_addrs(3 downto 0) => reg_r_a_mod,
    in_addrs(7 downto 4) => reg_r_b_mod,
    in_addrs(11 downto 8) => reg_w_mod,
    write_vals(11 downto 8) => write_val,
    write_vals(7 downto 0) => (others => '0'),
    write_enable(2) => write_enable,
    clock => clock,
    read_vals(3 downto 0) => reg_r_a_val,
    read_vals(7 downto 4) => reg_r_b_val,
    read_vals(11 downto 8) => reg_w_val
  );
end architecture;
