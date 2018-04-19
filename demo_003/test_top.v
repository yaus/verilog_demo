`timescale 1ns/1ns
module test_top;

reg [7:0] p_cnt;
reg [7:0] d_cnt;

reg       clk;
reg       rst_n;

pwm_gen U_PWM_GEN
(
    .clk        (clk),
    .rst_n      (rst_n),
    .period     (p_cnt),
    .duty_cycle (d_cnt),
    .pwm_out    (p_out)
);

initial begin
    clk   = 0;
    rst_n = 0;
    fork
        forever begin
            #5ns clk = ~clk;
        end
        begin
            #21 rst_n = 1;
        end
        begin
            $dumpvars(0);
            $dumpfile("demo_03.vcd");
            #10000ns
            $finish;
        end
    join
end

initial begin
    p_cnt = 'd200;
    d_cnt = 'd15;
end




endmodule
