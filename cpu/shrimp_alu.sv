import shrimp_alu_defs::*;

module shrimp_alu (
    input wire [7:0] operand_a,
    input wire [7:0] operand_b,
    input alu_opcode_e op_code,

    output wire [7:0] result,
    output wire carry,  // for unsigned arithmetic
    output wire overflow  // for signed arithmetic
);
  case (op_code)
    XOR: begin  // xor A^B
      assign result = operand_a ^ operand_b;
    end

    AND: begin  // and A&B
      assign result = operand_a & operand_b;
    end

    OR: begin  // or A|B
      assign result = operand_a | operand_b;
    end

    ADDU: begin  // add unsigned A+B
      assign result = operand_a + operand_b;
      assign carry  = operand_a[7] & operand_b[7];
    end

    ADDS: begin  // add signed A+B
      assign result   = operand_a + operand_b;
      assign overflow = operand_a[7] == operand_b[7] && operand_a[7] == result[7];
    end

    NEG: begin  // negate by 2's comp -A
      assign result = -operand_a;
    end

    CMP: begin  // compare A>B (in LSB 001 A>B, 010 A<B, 100 A=B)
      assign result[0]   = operand_a > operand_b;
      assign result[1]   = operand_a < operand_b;
      assign result[2]   = operand_a == operand_b;
      assign result[3:7] = 0;
    end

    SLL: begin  // bitshift left logical A<<B
      assign result = operand_a <<< operand_b;
    end

    SRL: begin  // bitshift right logical A>>B
      assign result = operand_a >>> operand_b;
    end

    SRA: begin  // bitshift right arithmatic A>>>B
      assign result = operand_a >> operand_b;
    end
  endcase

endmodule : shrimp_alu
