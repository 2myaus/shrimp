library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! memory / RAM
--! Stores a halfword (byte) at each address. in_addr_1 outputs to read_val_1
--! and determines which address is written to, while in_addr_2 outputs to
--! read_val_2 only.
entity memfile is
  generic (
    channels : integer; -- number of access channels for r/w
    address_width : integer; -- bit width of addresses (determines address space)
    word_width : integer; -- size of each value in bits
    data : std_logic_vector := (others => '0')
  );
  port(
    in_addrs : in std_logic_vector(channels*address_width-1 downto 0); -- addresses
    write_vals : in std_logic_vector(channels*word_width-1 downto 0); -- value to write to matching in_addr
    write_enable : in std_logic_vector(channels); -- whether to update memory address on clock
    clock : in std_logic;

    read_vals : out std_logic_vector(channels*word_width-1 downto 0) -- value at matching in_addr
  );
end entity;

architecture memfile_a of memfile is
    signal memfile : std_logic_vector((2**address_width) * word_width downto 0) := data;
begin
  generate_mem_io: for channel in 0 to channels generate
    process is -- read process
      variable addr_int : integer := to_integer(unsigned(in_addrs((channel+1)*address_width-1 downto channel*address_width)));
    begin
      read_vals((channel+1)*address_width-1 downto channel*address_width) <= memfile((addr_int+1)*word_width-1 downto addr_int*word_width);
    end process;

    process(clock) is -- write process
      variable addr_int : integer := to_integer(unsigned(in_addrs((channel+1)*address_width-1 downto channel*address_width)));
    begin
      if rising_edge(clock) and write_enable(channel) = '1' then
        memfile((addr_int+1)*word_width-1 downto addr_int*word_width) <= write_vals((channel+1)*address_width-1 downto channel*address_width);
      end if;
    end process;
  end generate generate_mem_io;
end architecture;
