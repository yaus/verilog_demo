`timescale 1ps/1ps
module clk_gen
#(  parameter PERIOD_PS=100 )
(   output reg clk          );

initial begin
    clk = 0;
    forever begin
        #(PERIOD_PS/2) clk = 0;
        #(PERIOD_PS-PERIOD_PS/2) clk = 1;
    end    
end

endmodule
