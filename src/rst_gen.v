`timescale 1ps/1ps
module rst_gen
#(  parameter RELEASE_PS=10000,
    parameter ASSERT_PS=1000    )
(   output reg rst_n            );
initial begin
    rst_n = 1;
    #(ASSERT_PS)
    rst_n = 0;
    #(RELEASE_PS-ASSERT_PS)
     rst_n = 1;
end
endmodule
