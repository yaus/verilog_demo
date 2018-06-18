module testbench;
localparam DATA_WIDTH = 16;
localparam FIFO_DEPTH = 16;
localparam FIFO_ADDR_WIDTH = clog2(FIFO_DEPTH);

clk_gen #(.PERIOD_PS(2000)) u_clk_500M ( .clk(clk) );
rst_gen #(.RELEASE_PS(100000)) u_rst_gen (.rst_n(rst_n));

reg                     din_wr_en;
reg [DATA_WIDTH-1:0]    din;
wire                    dout_rd_en;
wire[DATA_WIDTH-1:0]    dout;

FIFO
#(
    .FIFO_BUS_WIDTH     (DATA_WIDTH),
    .FIFO_DEPTH         (FIFO_DEPTH),
    .FIFO_ADDR_WIDTH    (FIFO_ADDR_WIDTH)
)
U_FIFO
(
    .clk                (clk),
    .rst_n              (rst_n),
    .din_wr_en          (din_wr_en),
    .din                (din),
    .empty              (empty),
    .full               (full),
    .dout_rd_en         (dout_rd_en),
    .dout               (dout)
);

integer i;
integer j;

initial begin
    rd_en = 0;
    din_wr_en = 0;
    end_ptr = 0;
    for(i=0;i<700;i=i+1) begin
        push_data(i*51599+7);
        repeat((20+i)%17+1)
        push_nop;
    end
    for(i=0;i<700;i=i+1) begin
        verify_data(i*51599+7);
        if(i > 60) begin
            repeat($random %70)
                @(posedge clk);
        end
    end
    #10ns
    $finish();
end

reg rd_en;
reg [DATA_WIDTH:0] q[65535:0];
reg [15:0] ptr;
reg [15:0] end_ptr;
wire [DATA_WIDTH:0] last_queue = q[ptr];

always @(posedge clk or rst_n) begin
    if(~rst_n) begin
        din_wr_en <= 0;
        din       <= 0;
        ptr       <= 0;
    end
    else if(ptr != end_ptr)begin
        if(~full) begin
            din_wr_en <= last_queue[DATA_WIDTH];
            din       <= last_queue; 
            ptr       <= ptr + 1;
        end
    end
end


assign dout_rd_en = rd_en ? ~empty : 0;

task push_data;
    input [DATA_WIDTH-1:0] data;
    begin
        q[end_ptr] = {1'b1,data};
        end_ptr = end_ptr+1;
    end
endtask

task push_nop;
    begin
        q[end_ptr] = {(DATA_WIDTH+1){1'b0}};
        end_ptr = end_ptr+1;
    end
endtask

task verify_data;
    input [DATA_WIDTH-1:0] data;
    begin
        rd_en = 1;
        @(posedge clk);
        while(~dout_rd_en)
            @(posedge clk);
        if(data == dout)
            $display("[%h] OK!", data);
        else
            $display("[%h] fail(%h)", data, dout_rd_en);
        rd_en = 0;
    end
endtask


             
`include "../src/dumpwave.v"              
`include "../src/clog2.v" 
endmodule
