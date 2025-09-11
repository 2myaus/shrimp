module shrimp_regfile_testbench ();

  logic [3:0] reg_r_a_addr;  // address for register read A
  logic [3:0] reg_r_b_addr;  // address for register read B
  logic [3:0] reg_w_addr;  // address for register writing

  logic [15:0] reg_w_val;  // value to write to reg_w_addr
  logic reg_w_enable;  // write to reg_w_addr on positive clk edge
  logic clock;

  logic [15:0] reg_r_a_val;  // value read from register A
  logic [15:0] reg_r_b_val;  // value read from register B

  shrimp_regfile regfile (
      .reg_r_a_addr(reg_r_a_addr),
      .reg_r_b_addr(reg_r_b_addr),
      .reg_w_addr(reg_w_addr),
      .reg_w_val(reg_w_val),
      .reg_w_enable(reg_w_enable),
      .reg_r_a_val(reg_r_a_val),
      .reg_r_b_val(reg_r_b_val),
      .clock(clock)
  );

  initial begin
    clock = 0;
    reg_w_enable = 0;
    reg_r_a_addr = 4'b0000;
    reg_r_b_addr = 4'b0000;
    reg_w_val = 16'b0;
    reg_w_addr = 4'b0;

    #10;

    $display(reg_r_a_val);
    $display(reg_r_b_val);

    #10;

    reg_w_addr = 4'b0000;
    reg_w_val = 16'd120;
    reg_r_b_addr = 4'b0001;
    reg_w_enable = 1;

    #5;

    clock = 1;

    #5;

    clock = 0;

    #5;

    $display(reg_r_a_val);
    $display(reg_r_b_val);
  end

endmodule : shrimp_regfile_testbench
