library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! instruction address counter.
--! Increments stored address by 2 for each clock pulse, or jumps to jump_addr if jump=1 during the clock pulse
entity instruction_counter is
  port(
    jump_addr: in word; -- address to jump to
    jump : in std_logic; -- whether to jump to jump_addr on clock signal
    clock : in std_logic;

    instruction_addr : out word -- memory address of the instruction
  );
end entity;

architecture instruction_counter_a of instruction_counter is
    signal current_addr : word := (others => '0');
begin
  instruction_addr <= current_addr;
  process(clock) is begin
    if rising_edge(clock) then
      if jump then
        current_addr <= jump_addr;
      else
        current_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(current_addr)) + 2, current_addr'length));
      end if;
    end if;
  end process;
end architecture;
