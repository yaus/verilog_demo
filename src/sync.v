/*
    For real application this will be replaced by SYNCHONIZER cell
*/
module sync
#(
    parameter STAGE=3,
    parameter WIDTH=1
)
(
    input               clk,
    input               rst_n,
    input  [WIDTH-1:0]  din,
    output [WIDTH-1:0]  dout
);
integer i;
reg [WIDTH-1:0] din_ff[STAGE-1:0];

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) 
        din_ff[0] <= 0;
    else
        din_ff[0] <= din;
end

generate
for(i=1;i<STAGE;i=i+1) begin:SYNC_STAGE
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) 
            din_ff[i] <= 0;
        else
            din_ff[i] <= din_ff[i-1];
    end
end
endgenerate

assign dout = din_ff[STAGE-1];
endmodule
