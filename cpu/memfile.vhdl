library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! memory / RAM
--! Stores a halfword (byte) at each address. in_addr_1 outputs to read_val_1
--! and determines which address is written to, while in_addr_2 outputs to
--! read_val_2 only.
entity memfile is
  generic(
    debug_logs : boolean := false;
  
    channels : integer := 1; -- number of access channels for r/w
    address_width : integer := word'length; -- bit width of addresses (determines address space)
    word_width : integer := halfword'length; -- size of each value in bits
    data : std_logic_vector := ((2**word'length)*halfword'length-1 downto 0 => '0')
  );
  port(
    in_addrs : in std_logic_vector(channels*address_width-1 downto 0); -- addresses
    write_vals : in std_logic_vector(channels*word_width-1 downto 0); -- value to write to matching in_addr
    write_enable : in std_logic_vector(channels-1 downto 0); -- whether to update memory address on clock
    clock : in std_logic;

    read_vals : out std_logic_vector(channels*word_width-1 downto 0) -- value at matching in_addr
  );
end entity;

architecture memfile_a of memfile is
    signal mfile : std_logic_vector((2**address_width)*word_width-1 downto 0) := data;

    pure function channel_to_addr_int(channel : integer; in_addrs_a : std_logic_vector(channels*address_width-1 downto 0)) return integer is
    begin
      return to_integer(unsigned(in_addrs_a((channel+1)*address_width-1 downto channel*address_width)));
    end function;
begin
  generate_mem_out: for channel in 0 to channels-1 generate
      -- process(mfile, in_addrs) is begin
      read_vals((channel+1)*word_width-1 downto channel*word_width) <= -- read
        mfile((channel_to_addr_int(channel, in_addrs)+1)*word_width-1 downto channel_to_addr_int(channel, in_addrs)*word_width);
    -- end process;
  end generate generate_mem_out;

  process(clock, in_addrs, write_vals, read_vals, write_enable) is -- write process
  begin
    for channel in 0 to channels-1 loop
      if debug_logs and rising_edge(clock) then
        report
          "memfile clk rise edge, channel " & integer'image(channel) &
          ", addr " & integer'image(channel_to_addr_int(channel, in_addrs)) &
          ", value " & to_hstring(read_vals((channel+1)*word_width-1 downto channel*word_width)) &
          ", writing " & std_logic'image(write_enable(channel)) &
          ", write val " & to_hstring(write_vals((channel+1)*word_width-1 downto channel*word_width));
      end if;
      if rising_edge(clock) and write_enable(channel) = '1' then
        mfile((channel_to_addr_int(channel, in_addrs)+1)*word_width-1 downto channel_to_addr_int(channel, in_addrs)*word_width) <=
          write_vals((channel+1)*word_width-1 downto channel*word_width);
        if debug_logs then
          report
            "memory written: " &
            to_hstring(write_vals((channel+1)*word_width-1 downto channel*word_width)) &
            " to addr " & integer'image(channel_to_addr_int(channel, in_addrs));
        end if;
      end if;
    end loop;
  end process;
end architecture;
