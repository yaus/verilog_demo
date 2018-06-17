module testbench;
localparam DATA_WIDTH = 16;
localparam FIFO_DEPTH = 16;
localparam FIFO_ADDR_WIDTH = clog2(FIFO_D);

clk_gen #(.PERIOD_PS(2000)) u_clk_500M ( .clk(clk) );
rst_gen #(.RELEASE_PS(100000)) u_rst_gen (.rst_n(rst_n));

reg                     din_wr_en;
reg [DATA_WIDTH-1:0]    din;
reg                     dout_rd_en;

U_FIFO
#(
    .FIFO_BUS_WIDTH     (DATA_WIDTH),
    .FIFO_DEPTH         (FIFO_DEPTH),
    .FIFO_ADDR_WIDTH    (FIFO_ADDR_WIDTH)
)
(
    .clk                (clk),
    .rst_n              (rst_n),
    .din_wr_en          (din_wr_en),
    .din                (din),
    .fifo_empty         (empty),
    .fifo_full          (full),
    .dout_rd_en         (dout_rd_en),
    .dout               (dout)
);

integer i;
integer j;

initial begin
    #1ns;
    wait(rst_n == 1);
    fork
        begin
            for(i=0;i<FIFO_DEPTH;i=i+1)
            begin
                push_data(i*71+7);
                repeat(20-i)
                    @(posedge clk);
            end                        
        end
        begin
            repeat(30)
                @(posedge clk);
            for(j=0;j<FIFO_DEPTH;j=j+1)
            begin
                push_data(j*71+7);
                repeat(20-i)
                    @(posedge clk);
            end  
        end
    join
end


task push_data;
    input [DATA_WIDTH-1:0] data;
    begin
        wait(full == 0);
        din_wr_en <= 1;
        din       <= data;
        @(posedge clk);
        din_wr_en <= 0;
        din       <= data; 
    end
endtask

task verify_data;
    input [DATA_WIDTH-1:0] data;
    begin
        wait(empty == 0);
        dout_rd_en <= 0;
        @(posedge clk);
        if(data == dout)
            $display("[0x%h] OK!",data);
        else
            $display("[0x%h] fail (0x%h)",data,dout);
    end
endtask


             
`include "../src/dumpwave.v"              
`include "../src/clog2.v" 
endmodule