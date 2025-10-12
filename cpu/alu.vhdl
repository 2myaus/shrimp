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
    result : out word;
    overflow : out std_logic;
    carry : out std_logic
  );
end entity;

architecture alu_a of alu is
begin
  process 
    variable opa_int : integer;
    variable opb_int : integer;
    variable opa_msb : std_logic;
    variable opb_msb : std_logic;
  begin
    if do_signed then
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
        if do_signed then
          result <= std_logic_vector(to_signed(opa_int + opb_int, result'length));
          overflow <= (opa_msb xnor opb_msb) and (result(result'length-1) xor opa_msb);
          carry <= '0';
        else 
          result <= std_logic_vector(to_unsigned(opa_int + opb_int, result'length));
          overflow <= '0';
          carry <= opa_msb and opb_msb;
        end if;

      when ALUOP_AND =>
        result <= operand_a and operand_b;

      when ALUOP_CMP =>
        if operand_a > operand_b then
          result <= 16x"0001"; -- return 1
        elsif operand_a < operand_b then
          result <= 16x"FFFF"; -- return -1
        else
          result <= 16x"0000"; -- return 0
        end if;

      when ALUOP_NEG =>
        if do_signed then
          result <= std_logic_vector(to_signed(-opa_int, result'length));
        else
          result <= not operand_a;
        end if;

      when ALUOP_OR =>
        result <= operand_a or operand_b;

      when ALUOP_SR =>
        if do_signed then
          result <= std_logic_vector(shift_right(signed(operand_a), opb_int));
        else
          result <= std_logic_vector(shift_right(unsigned(operand_a), opb_int));
        end if;

      when ALUOP_XOR =>
        result <= operand_a xor operand_b;

    end case;
  end process;
end architecture;
