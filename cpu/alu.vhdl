library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_types.all;

--! CPU arithmatic logic unit. does basic combinational arithmetic
entity alu is
  port(
    do_signed : in std_logic;
    opcode : in alu_opcode;
    operand_a : in word;
    operand_b : in word;
    result : out word
    -- overflow : out std_logic;
    -- carry : out std_logic
  );
end entity;

architecture alu_a of alu is
begin
  process is
    variable opa_int : integer;
    variable opb_int : integer;
    variable opb_uint : integer; -- always unsigned
    variable opa_msb : std_logic;
    variable opb_msb : std_logic;
  begin
    opb_uint := to_integer(unsigned(operand_b));
    if do_signed='1' then
      opa_int := to_integer(signed(operand_a));
      opb_int := to_integer(signed(operand_b));
    else
      opa_int := to_integer(unsigned(operand_a));
      opb_int := to_integer(unsigned(operand_b));
    end if;

    opa_msb := operand_a(operand_a'length-1);
    opb_msb := operand_b(operand_b'length-1);

    case opcode is

      when ALUOP_ADD =>
        if do_signed='1' then
          result <= std_logic_vector(to_signed(opa_int + opb_int, result'length));
          -- overflow <= (opa_msb xnor opb_msb) and (result(result'length-1) xor opa_msb);
          -- carry <= '0';
        else 
          result <= std_logic_vector(to_unsigned(opa_int + opb_int, result'length));
          -- overflow <= '0';
          -- carry <= opa_msb and opb_msb;
        end if;

      when ALUOP_SUB =>
        if do_signed='1' then
          result <= std_logic_vector(to_signed(opa_int - opb_int, result'length));
          -- overflow <= (opa_msb xor opb_msb) and (result(result'length-1) xor opa_msb);
          -- carry <= '0';
        else 
          result <= std_logic_vector(to_unsigned(opa_int - opb_int, result'length));
          if opb_int > opa_int then
            -- overflow <= '1';
          else
            -- overflow <= '0';
          end if;
          -- carry <= '0';
        end if;

      when ALUOP_AND =>
        result <= operand_a and operand_b;
        -- overflow <= '0';
        -- carry <= '0';

      when ALUOP_CMP =>
        if operand_a > operand_b then
          result <= ( 0 => '1', others => '0'); -- return 1
        elsif operand_a < operand_b then
          result <= (others => '1'); -- return -1
        else
          result <= (others => '0'); -- return 0
        end if;
        -- overflow <= '0';
        -- carry <= '0';

      when ALUOP_NEG =>
        if do_signed='1' then
          result <= std_logic_vector(to_signed(-opa_int, result'length));
        else
          result <= not operand_a;
        end if;
        -- overflow <= '0';
        -- carry <= '0';

      when ALUOP_OR =>
        result <= operand_a or operand_b;
        -- overflow <= '0';
        -- carry <= '0';

      when ALUOP_BS =>
        if do_signed='1' then
          result <= std_logic_vector(shift_right(signed(operand_a), opb_uint));
        else
          result <= std_logic_vector(shift_left(unsigned(operand_a), opb_uint));
        end if;
        -- overflow <= '0';
        -- carry <= '0';

      when ALUOP_XOR =>
        result <= operand_a xor operand_b;
        -- overflow <= '0';
        -- carry <= '0';

      when others =>
    end case;
  end process;
end architecture;
