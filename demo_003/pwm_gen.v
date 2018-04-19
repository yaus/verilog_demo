module pwm_gen
(
    input       clk,
    input       rst_n,
    input [7:0] period,
    input [7:0] duty_cycle,
    output reg  pwm_out
);

reg [7:0] next_cnt;
reg [7:0] cnt;

always @(*) begin
    next_cnt = cnt + 1;
    if(next_cnt >= period)
        next_cnt = 0;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pwm_out <= 0;
        cnt     <= 0;
    end
    else begin
        pwm_out <= next_cnt < duty_cycle;
        cnt     <= next_cnt;
    end
end

endmodule 
