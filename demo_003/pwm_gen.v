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

reg [7:0] period_latch;
reg [7:0] duty_cycle_latch;


always @(*) begin
    next_cnt = cnt + 1;
    if(next_cnt >= period_latch)
        next_cnt = 0;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        period_latch     <= 50;
        duty_cycle_latch <= 25;
    end
    else if(next_cnt == 0) begin
        period_latch     <= period;
        duty_cycle_latch <= duty_cycle;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pwm_out <= 0;
        cnt     <= 0;
    end
    else begin
        pwm_out <= next_cnt < duty_cycle_latch;
        cnt     <= next_cnt;
    end
end

endmodule 
