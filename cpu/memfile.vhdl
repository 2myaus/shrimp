library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

architecture memfile_a of memfile is
    type memfile is array(16#FFFF# downto 0) of halfword; -- index 15 is zero-reg
    signal bytes : memfile;
begin
  process is
    variable in_addr_int : integer := to_integer(unsigned(in_addr));
  begin
    read_val(15 downto 7) <= bytes(in_addr_int);
    read_val(7 downto 0) <= bytes(in_addr_int+1);
  end process;

  process(clock) is
    variable in_addr_int : integer := to_integer(unsigned(in_addr));
  begin
    if rising_edge(clock) then
      if write_enable then
        bytes(in_addr_int) <= write_val;
      end if;
    end if;
  end process;
end architecture;
