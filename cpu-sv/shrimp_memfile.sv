module shrimp_memfile (
    input wire [7:0] mem_addr,  // byte-address for reading and for writing

    input wire [15:0] write_val,  // value to write to 2-byte word at mem_addr
    input wire write_enable,  // write to mem_addr on positive clk edge
    input wire clock,

    output wire [15:0] read_val  // 2-byte word stored at mem_addr
);

  reg [7:0] registers[65536];

  assign read_val = registers[mem_addr];

  always_ff @(posedge clock) begin
    if (reg_w_enable) begin
      registers[mem_addr] <= write_val;
    end
  end

endmodule : shrimp_memfile
