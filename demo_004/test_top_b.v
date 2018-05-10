`timescale 1ns/1ps
module test_top_b;
wire clk_80M;
wire clk_60M;
wire rst_n;
clk_gen #(.PERIOD_PS(12500)) u_clk_80M ( .clk(clk_80M) );
clk_gen #(.PERIOD_PS(15666)) u_clk_60M ( .clk(clk_60M) );
rst_gen #(.RELEASE_PS(100000)) u_rst_gen (.rst_n(rst_n));

reg         enable;
reg [7:0]   tx_data;
reg         rx_enable;
wire [7:0]  rx_data;
wire        rx_valid;
wire        rx_error;
wire        tx;
wire        tx_active;

uart_tx u_uart_tx
(
    .rst_n      (rst_n ),
    .clk        (clk_80M),
    .enable     (enable),
    .data       (tx_data[7:0]),
    .clk_ratio  (8'h10),
    .tx_active  (tx_active),
    .tx         (tx)
);

uart_rx u_uart_rx
(
    .rst_n      (rst_n),
    .clk        (clk_60M),
    .rx         (tx),
    .enable     (rx_enable),
    .clk_ratio  (8'd12),
    .data       (rx_data),
    .rx_valid   (rx_valid),
    .rx_error   (rx_error)
);

`include "../src/dumpwave.v"
initial begin
    rx_enable = 0;
    @(posedge rst_n);
    #1us;
    rx_enable = 1;
    drive_tx(8'h01);
    drive_tx(8'h55);
    drive_tx(8'h99);
    drive_tx(8'hED);
    #20us
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
