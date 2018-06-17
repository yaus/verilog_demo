`timescale 1ns/1ps
// Dual port memory
module SRAM
#(
  parameter WIDTH=8,
  parameter DEPTH=16,
  parameter ADDR_WIDTH=4,
  localparam READ_DLY=1ns
  )
(
  input [ADDR_WIDTH-1:0]  rd_addr,
  input                   rd_en,
  output [WIDTH-1:0]      rd_dout,
  
  input [ADDR_WIDTH-1:0]  wr_addr,
  input                   wr_en.
  input [WIDTH-1:0]       wr_din
);

reg [WIDTH-1:0] mem[DPETH-1:0];
reg [WIDTH-1:0] rd_out;

assign rd_out = ~rd_en ? {WIDTH{1'bx}} : mem[rd_addr];
assign rd_dout = #1ns rd_out;

always @(*) begin
  if(wr_en)
    #1ns mem[wr_addr] = wr_din;
end

endmodule
