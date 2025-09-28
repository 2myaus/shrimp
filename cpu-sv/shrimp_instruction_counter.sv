module shrimp_instruction_counter (
    input wire [15:0] jump_addr,  // address to jump to on jump
    input wire jump,  // jump to jump_addr on clock edge
    input wire clock,  // address += 2 on edge unless jump=1 or reset=1
    input wire reset,  // address = 0 on clock edge

    output reg [15:0] instruction_address  // address of the instruction to run
);

  always_ff @(posedge clock) begin
    instruction_address <= reset ? 0 : (jump ? jump_addr : instruction_address + 2);
  end

endmodule : shrimp_instruction_counter
