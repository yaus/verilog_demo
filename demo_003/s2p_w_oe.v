module s2p_w_oe
(
    input           clk,
    input           rst_n,
    input           oe_n,
    input           st_clk,
    input           sin,
    output          sout,
    output  [7:0]   dout
);

wire [7:0] qin;
reg  [7:0] qout;
reg  [7:0] qout_ff;

always @(posedge clk or negedge rst_n) 
    if(~rst_n)
        qout <= 8'h00;
    else
        qout <= qin;

assign qin = {qout[6:0],sin};

always @(posedge clk)
    qout_ff <= qout;

assign dout = oe_n ? 8'hz : qout_ff;

endmodule 
