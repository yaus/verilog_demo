// Set simulation timestep
`timescale 1ns/1ns

// Declare testbench module
module test_top;

// Declare clock signal 
reg clk;
reg rst_n;

// Generate 200MHz clock
initial begin
    // initial clock signal to logic 0
    clk = 0;
    // loop forever for flipping clock
    forever begin
        // Wait 5ns
	    #5ns;
        // Flip the clock signal
        clk = ~clk;
	end
end

// Generate reset signal
initial begin
    // initial reset signal to logic 1
    rst_n = 0;
    #17ns
    rst_n = 1;
end

// Dump waveform
initial begin
    $dumpvars(0);
    #10000ns
    $finish;
end

// Declare testbench signal
wire clk_o;

// Declare Device Under Test (DUT)
CLK_DIV_2 DUT
(
    .clk    (clk),
    .rst_n  (rst_n),
    .clk_o  (clk_o)
);
endmodule

