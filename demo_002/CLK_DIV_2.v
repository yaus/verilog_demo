module CLK_DIV_2
(
    input           clk,
    input           rst_n,
    output reg      clk_o
);

always @(posedge clk or negedge rst_n) 
    if(~rst_n)
        clk_o <= 0;
    else
        clk_o <= ~clk_o;




endmodule
