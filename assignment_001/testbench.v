module assignement_001;

reg  [2:0] din;
wire [2:0] dout;

// Place You DUT here
gray dut
(
    .din(din),
    .dout(dout)
);


// Don't touch
integer i;
reg result;
initial begin
    din = 0;
    result = 1;
    for(i=0;i<100000;i=i+1) begin
        random_drive();
        check_gray_code();
        #1;
    end
    if(result)
        $display("Tested OK!");
    else
        $display("Tested Fail!"); 
end

task random_drive;
begin
    din = $urandom%8;
    #1;
end
endtask

task check_gray_code;
reg [2:0]   exp_dout;
begin
    case(din)
        0:  exp_dout = 'b000;
        1:  exp_dout = 'b001;
        2:  exp_dout = 'b011;
        3:  exp_dout = 'b010;
        4:  exp_dout = 'b110;
        5:  exp_dout = 'b111;
        6:  exp_dout = 'b101;
        7:  exp_dout = 'b100;
    endcase
    if(exp_dout != dout)
        $display("%0t: ERROR : exp_dout = %b,  real_dout = %b",$time, exp_dout, dout);
    result = result & (exp_dout == dout);
end
endtask
endmodule
