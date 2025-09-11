module shrimp_instruction_counter_testbench ();

  logic [15:0] jump_addr;  // address to jump to on jump
  logic jump;  // jump to jump_addr on clock edge
  logic clock;  // address += 2 on edge unless jump=1 or reset=1
  logic reset;  // address = 0 on clock edge

  logic [15:0] instruction_address;  // address of the instruction to run

  shrimp_instruction_counter counter (
      .jump_addr(jump_addr),
      .jump(jump),
      .clock(clock),
      .reset(reset),
      .instruction_address(instruction_address)
  );

  initial begin
    reset = 0;
    #5;
    reset = 1;
    #5;
    reset = 0;
    #5;
    $display("addr is %d", instruction_address);
    #5;
    clock = 1;
    #5;
    clock = 0;
    $display("addr after 1 clock is %d", instruction_address);
    jump = 1;
    jump_addr = 16'd120;
    #5;
    clock = 1;
    #5;
    clock = 0;
    $display("addr after jump is %d", instruction_address);

  end

  always_ff @(posedge clock) begin
    instruction_address <= reset ? 0 : (jump ? jump_addr : instruction_address + 2);
  end

endmodule : shrimp_instruction_counter_testbench
