`timescale 1ns/1ps
// Dual port memory
module SRAM
#(
  parameter WIDTH=8,
  parameter DEPTH=16,
  parameter ADDR_WIDTH=4
  )
(
  input [ADDR_WIDTH-1:0]  rd_addr,
  input                   rd_en,
  output [WIDTH-1:0]      rd_dout,
  
  input [ADDR_WIDTH-1:0]  wr_addr,
  input                   wr_en,
  input [WIDTH-1:0]       wr_din
);

reg [WIDTH-1:0] mem[DEPTH-1:0];
wire [WIDTH-1:0] rd_out;

assign rd_out = ~rd_en ? {WIDTH{1'bx}} : mem[rd_addr];
assign #1 rd_dout = rd_out;

always @(*) begin
  if(wr_en)
    #1 mem[wr_addr] = wr_din;
end

endmodule
