module CLK_DIV_2
(
    // IO declaration
    // input -- declare an input pin
    // clk   -- pin name
    input           clk,
    input           rst_n,
    // output -- declare an output pin
    // reg    -- declare pin with "reg" type signal
    output reg      clk_o
);

// always -- always active block
// @($$$)  -- active with preceding "$$$" signals
// posedge -- rise edge trigger
// negedge -- falling edge trigger
always @(posedge clk or negedge rst_n) 
    if(~rst_n)
        // <= -- non-blocking assignment
        clk_o <= 0;
    else
        clk_o <= ~clk_o;
    
endmodule
