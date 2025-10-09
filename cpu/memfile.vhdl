library ieee;
use ieee.std_logic_1164.all;

use work.cpu_types.all;

--! memory / RAM
entity memfile is
  port(
    in_addr : in word; -- address for reading and writing
    write_val : in word; -- value to write to in_addr
    write_enable : in std_logic; -- whether to update memory address on clock
    clock : in std_logic;

    read_val : out word -- address currently at in_addr
  );
end entity;
