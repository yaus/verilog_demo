# Assignment 002
To demonstrate ability of writing a useful code. This assignment require to design a synchronous FIFO.
The assign provided a memory model. To compile the FIFO design, few signal require to be implemented.

## FIFO signals & Parameter
| Parameter | Description |
| -         | -           |
| WID       | data bus width | 
| DEPTH     | FIFO depth  |
| DEP_WID   | ceiling(log2(FIFO depth0)) |

| Bus/Signals | Width | Description |
| ----------- | ------| ----------- |
| full        | 1     | indicate no space to push the new data |
| empty       | 1     | indicate no data in the memory |
| din         | WID**     | data input port |
| din_push    | 1     | data input valid | 
| dout        | WID**     | data output port |
| dout_pop    | 1| data output acquired | 

** as input parameter 

## FIFO design
FIFO can be implement as a circular memory with read & write pointer control.

## Memory model
This is a dual port memory model.
```sv
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
```

## Testbench
Testbench generate the FIFO input automatically and it will verify the data output.
Also, it will test empty and full signal.