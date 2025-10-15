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
    reg_r_b_val : out word  -- Value in reg_r_b
  );
end entity;


architecture regfile_a of regfile is
    type regfile is array(14 downto 0) of word; -- index 15 is zero-reg
    signal registers : regfile;
begin
  process is
    variable reg_r_a_int : integer := to_integer(unsigned(reg_r_a));
    variable reg_r_b_int : integer := to_integer(unsigned(reg_r_b));
  begin
  registers(15) <= (others => '0');
  reg_r_a_val <= registers(reg_r_a_int);
  reg_r_b_val <= registers(reg_r_b_int);
  end process;

  process(clock) is
    variable reg_w_int : integer := to_integer(unsigned(reg_w));
  begin
    if rising_edge(clock) then
      if write_enable then

        if (reg_w /= ZERO_REG) then -- Exclude 0-register from writing
          registers(reg_w_int) <= write_val;
        end if;

      end if;
    end if;
  end process;
end architecture;
