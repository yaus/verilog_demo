`timescale 1ns/1ns
module test_top;

reg [7:0] p_cnt;
reg [7:0] d_cnt;

reg       clk;
reg       rst_n;

reg       st_clk;
reg       sin;
wire      sout;
wire [15:0] dout;

s2p_w_oe U_S2P_0
(
    .clk        (clk),
    .rst_n      (rst_n),
    .oe_n       (1'b0),
    .st_clk     (st_clk),
    .sin        (sin),
    .sout       (sout),
    .dout       (dout[7:0])
);

s2p_w_oe U_S2P_1
(
    .clk        (clk),
    .rst_n      (rst_n),
    .oe_n       (1'b0),
    .st_clk     (st_clk),
    .sin        (sout),
    .dout       (dout[15:8])
);

pwm_gen U_PWM_GEN
(
    .clk        (clk),
    .rst_n      (rst_n),
    .period     (dout[7:0]),
    .duty_cycle (dout[15:8]),
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
    sin = 0;
    st_clk = 0;
    wait(rst_n == 0);
    drive_pwm(30,32);
end

task drive_pwm;
    input [7:0] duty_cycle;
    input [7:0] period;
    integer i;
    begin
        for(i=0;i<8;i=i+1)
            s2p_drive(duty_cycle[7-i]); 
        for(i=0;i<8;i=i+1)
            s2p_drive(period[7-i]);
        @(posedge clk)
        st_clk = 1;
        @(negedge clk)
        st_clk = 0;
    end
endtask

task s2p_drive;
    input val;
    begin
        sin = val;
        @(posedge clk);
    end
endtask

endmodule
