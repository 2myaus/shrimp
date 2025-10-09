library ieee;
use ieee.std_logic_1164.all;

use work.cpu_types.all;

--! internal CPU registers, there are 16. addressed with 4 bits
entity regfile is
  port(
    reg_r_a : in reg_addr;
    reg_r_b : in reg_addr;
    reg_w : in reg_addr; -- Register to write to
    write_val : in word; -- Value that gets written to reg_w
    write_enable : in word; -- Whether to write on clock signal
    clock : in std_logic;

    reg_r_a_val : out word; -- Value in reg_r_a
    reg_r_b_val : out word  -- Value in reg_r_b
  );
end entity;
