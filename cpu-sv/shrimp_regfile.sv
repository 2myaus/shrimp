module shrimp_regfile (
    input wire [3:0] reg_r_a_addr,  // address for register read A
    input wire [3:0] reg_r_b_addr,  // address for register read B
    input wire [3:0] reg_w_addr,    // address for register writing

    input wire [15:0] reg_w_val,  // value to write to reg_w_addr
    input wire reg_w_enable,  // write to reg_w_addr on positive clk edge
    input wire clock,

    output wire [15:0] reg_r_a_val,  // value read from register A
    output wire [15:0] reg_r_b_val   // value read from register B
);

  /*
  0x0: argument/return 0
  0x1: argument/return 1
  0x2: argument/return 2
  0x3: argument/return 3
  0x4: argument 4 (no return)
  0x5: argument 5 (no return)

  0x6: saved reg 0 (saved by callee)
  0x7: saved reg 1
  0x8: saved reg 2
  0x9: saved reg 3
  0xA: saved reg 4
  0xB: saved reg 5

  0xC: temp reg (saved by caller)

  0xD: stack pointer
  0xE: return address

  0xF: hardwired zero
  */

  reg [15:0] registers[15];  // last register (address 0xF) is zero reg

  assign reg_r_a_val = (reg_r_a_addr == 4'hF) ? 0 : registers[reg_r_a_addr];
  assign reg_r_b_val = (reg_r_b_addr == 4'hF) ? 0 : registers[reg_r_b_addr];

  always_ff @(posedge clock) begin
    if (reg_w_enable && reg_w_addr != 4'hF) begin
      registers[reg_w_addr] <= reg_w_val;
    end
  end

endmodule : shrimp_regfile
