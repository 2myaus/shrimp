module shrimp_regfile (
    input wire [3:0] reg_r_a_addr,  // address for register read A
    input wire [3:0] reg_r_b_addr,  // address for register read B
    input wire [3:0] reg_w_addr,    // address for register writing

    input wire [7:0] reg_w_val,  // value to write to reg_w_addr
    input wire reg_w_enable,  // write to reg_w_addr on positive clk edge
    input wire clock,

    output wire [7:0] reg_r_a_val,  // value read from register A
    output wire [7:0] reg_r_b_val   // value read from register B
);

  reg [7:0] registers[16];

  assign reg_r_a_val = registers[reg_r_a_addr];
  assign reg_r_b_val = registers[reg_r_b_addr];

  always_ff @(posedge clock) begin
    if (reg_w_enable) begin
      registers[reg_w_addr] <= reg_w_val;
    end
  end

endmodule : shrimp_regfile
