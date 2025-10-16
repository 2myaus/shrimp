library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! instruction address counter.
--! Increments stored address by 2 for each clock pulse, or by offset if jump=1 during the clock pulse
entity instruction_counter is
  port(
    offset : in word; -- signed offset by which to change position
    increment: in std_logic; -- whether to increment position or otherwise jump to jump_addr on clock signal
    clock : in std_logic;

    instruction_addr : out word; -- memory address of the instruction
    instruction_addr_2 : out word -- instruction address + 1
  );
end entity;

architecture instruction_counter_a of instruction_counter is
    signal current_addr : word := (others => '0');
    signal current_addr_2 : word;
begin
  instruction_addr <= current_addr;
  instruction_addr_2 <= current_addr_2;
  process is
    variable current_addr_int : integer := to_integer(unsigned(current_addr));
  begin
    current_addr_2 <= std_logic_vector(to_unsigned(current_addr_int + 2, current_addr_2'length));
  end process;
  process(clock) is
    variable current_addr_int : integer := to_integer(unsigned(current_addr));
    variable offset_int : integer := to_integer(signed(offset));
  begin
    if rising_edge(clock) then
      if increment then
        current_addr <= std_logic_vector(to_unsigned(current_addr_int + 2, current_addr'length));
      else
        current_addr <= std_logic_vector(to_unsigned(current_addr_int + offset_int, current_addr'length));
      end if;
    end if;
  end process;
end architecture;
