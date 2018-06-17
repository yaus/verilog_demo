module uart_rx
(
    input               rst_n,
    input               clk,
    input               rx,
    
    input               enable,
    input       [7:0]   clk_ratio,
    output reg  [7:0]   data,
    output reg          rx_valid,
    output reg          rx_error
);

localparam IDLE_STATE=0;
localparam STARTBIT_STATE=1;
localparam DATABITS_STATE=2;
localparam STOPBIT_STATE=3;
localparam END_STATE=4;

reg [4:0]   state;
reg [4:0]   next_state;

reg         clk_start;
reg         next_clk_start;

reg [2:0]   next_data_cnt;
reg [2:0]   data_cnt;

reg [7:0]   next_data;
reg [7:0]   rx_data;
reg [7:0]   next_rx_data;
reg         next_rx_valid;
reg         next_rx_error;

reg [7:0]   clk_cnt;
wire        rx_ff;

sync
#(  .WIDTH(1)   )
u_synchronizer
(
    .clk(clk),
    .rst_n(rst_n),
    .din(rx),
    .dout(rx_ff)
);
wire sample_tick = clk_ratio[7:1] == clk_cnt[6:0];
wire cnt_overflow = clk_cnt == clk_ratio;

always @(*) begin
    next_state      = 0;
    next_clk_start  = clk_start;
    next_rx_data    = rx_data;
    next_rx_valid   = 0;
    next_rx_error   = rx_error;
    next_data       = data;
    next_data_cnt   = data_cnt;
    case(1'b1) 
        state[IDLE_STATE]:
            if(rx_ff == 0 && enable) begin
                next_state[STARTBIT_STATE] = 1;
                next_clk_start = 1;
            end else begin
                next_state[IDLE_STATE] = 1;
            end
        state[STARTBIT_STATE]:
            if(cnt_overflow)
                next_state[DATABITS_STATE] = 1;
            else
                next_state[STARTBIT_STATE] = 1;
        state[DATABITS_STATE]:
            if(sample_tick) begin
                next_data_cnt = data_cnt + 1;
                next_rx_data[data_cnt] = rx_ff;
                if(data_cnt == 7)
                    next_state[STOPBIT_STATE] = 1;
                else
                    next_state[DATABITS_STATE] = 1;
            end else
                next_state[DATABITS_STATE] = 1;
        state[STOPBIT_STATE]:
            if(sample_tick) begin
                next_rx_error = ~rx_ff;
                next_state[END_STATE] = 1;
            end else begin
                next_state[STOPBIT_STATE] = 1;
            end
        state[END_STATE]: 
            begin
                next_rx_valid          = 1;
                next_data_cnt          = 0;
                next_data              = rx_data;
                next_state[IDLE_STATE] = 1;
                next_clk_start         = 0;
            end
    endcase
end



always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        clk_cnt <= 0;
    end
    else if(clk_cnt == clk_ratio) begin
        clk_cnt <= 0;
    end
    else if(clk_start) begin
        clk_cnt <= clk_cnt + 1;
    end
    else begin
        clk_cnt <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state       <= 1 << IDLE_STATE;
        rx_data     <= 8'h00;
        rx_valid    <= 0;
        rx_error    <= 0;
        data        <= 8'h00;
        data_cnt    <= 3'h0;
        clk_start   <= 0;
    end
    else begin
        state       <= next_state;
        rx_data     <= next_rx_data;
        rx_valid    <= next_rx_valid;
        rx_error    <= next_rx_error;
        data        <= next_data;
        data_cnt    <= next_data_cnt;
        clk_start   <= next_clk_start;
    end
end

endmodule
