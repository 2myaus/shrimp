library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! memory / RAM
--! Stores a halfword (byte) at each address. in_addr_1 outputs to read_val_1
--! and determines which address is written to, while in_addr_2 outputs to
--! read_val_2 only.
entity memfile is
  port(
    in_addr_1 : in word; -- address for reading and writing
    in_addr_2 : in word; -- second address for reading
    write_val : in word; -- value to write to in_addr
    write_enable : in std_logic; -- whether to update memory address on clock
    clock : in std_logic;

    read_val_1 : out word; -- address currently at in_addr_1
    read_val_2 : out word -- address currently at in_addr_2
  );
end entity;

architecture memfile_a of memfile is
    type memfile is array(16#FFFF# downto 0) of halfword; -- index 15 is zero-reg
    signal bytes : memfile;
begin
  process is
    variable in_addr_1_int : integer := to_integer(unsigned(in_addr_1));
    variable in_addr_2_int : integer := to_integer(unsigned(in_addr_2));
  begin
    read_val_1(15 downto 7) <= bytes(in_addr_1_int);
    read_val_1(7 downto 0) <= bytes(in_addr_1_int+1);

    read_val_2(15 downto 7) <= bytes(in_addr_2_int);
    read_val_2(7 downto 0) <= bytes(in_addr_2_int+1);
  end process;

  process(clock) is
    variable in_addr_int : integer := to_integer(unsigned(in_addr_1));
  begin
    if rising_edge(clock) then
      if write_enable then
        bytes(in_addr_int) <= write_val;
      end if;
    end if;
  end process;
end architecture;
