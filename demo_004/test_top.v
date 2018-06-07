`timescale 1ns/1ps

module test_top;

wire clk;
wire rst_n;

reg         enable;
reg [7:0]   tx_data;
wire        tx;
wire        tx_active;

clk_gen #(.PERIOD_PS(1000)) clk_1ns (.clk(clk));
rst_gen #(.RELEASE_PS(30000),.ASSERT_PS(10)) rst_gen (.rst_n(rst_n));

uart_tx dut_tx
(
    .rst_n      (rst_n),
    .clk        (clk),
    .enable     (enable),
    .data       (tx_data[7:0]),
    .clk_ratio  (8'h64),
    .tx_active  (tx_active),
    .tx         (tx)
);

`include "../src/dumpwave.v"
initial begin
    drive_tx(8'h01);
    drive_tx(8'h55);
    drive_tx(8'h99);
    drive_tx(8'hED);
    #1000ns
    $finish;
end

task drive_tx;
input [7:0] data;
begin
    tx_data = data;
    enable = 1;
    @(posedge tx_active);
    enable = 0;
    wait(tx_active == 0);
end
endtask


endmodule
