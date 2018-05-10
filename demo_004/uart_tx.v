module uart_tx
(
    input           rst_n,
    input           clk,

    input           enable,
    input   [7:0]   data,
    input   [7:0]   clk_ratio,
    
    output reg      tx_active,
    output reg      tx
);
localparam  IDLE_STATE=0;
localparam  STARTBIT_STATE=1;
localparam  DATABITS_STATE=2;
localparam  STOPBIT_STATE=3;

// one-hot FSM
reg [3:0]   state;
reg [2:0]   bit_cnt;

reg [3:0]   next_state;
reg         next_tx_active;
reg         next_tx;
reg [2:0]   next_bit_cnt;

reg [7:0]   clk_cnt;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state       <= 4'b1 << IDLE_STATE;
        tx          <= 1'b1;
        tx_active   <= 1'b0;
        bit_cnt     <= 3'b0;
    end else begin
        state       <= next_state;
        tx          <= next_tx;
        tx_active   <= next_tx_active;
        bit_cnt     <= next_bit_cnt;
    end
end

always @(*) begin
    next_state      = state;
    next_tx         = tx;
    next_tx_active  = tx_active;
    next_bit_cnt    = bit_cnt;

    if(clk_cnt == clk_ratio) begin
        next_state = 0;
        case(1'b1)
            state[IDLE_STATE]:
                if(enable) begin
                    next_state[STARTBIT_STATE] = 1;
                    next_tx = 0;
                    next_tx_active = 1;
                end 
                else
                    next_state[IDLE_STATE] = 1;
            state[STARTBIT_STATE]:
                begin
                    next_state[DATABITS_STATE] = 1;
                    next_bit_cnt               = 0;
                    next_tx                    = data[0];
                end
            state[DATABITS_STATE]:
                if(bit_cnt == 7) begin
                    next_state[STOPBIT_STATE] = 1;
                    next_bit_cnt              = 0;
                    next_tx                   = 1;
                end else begin
                    next_state[DATABITS_STATE] = 1;
                    next_bit_cnt               = bit_cnt + 1;
                    next_tx                    = data[next_bit_cnt];
                end
            state[STOPBIT_STATE]:
                begin
                    next_state[IDLE_STATE] = 1;
                    next_tx_active         = 0;
                    next_tx                = 1;
                end
        endcase
    end
end

// scaled clock generation
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        clk_cnt <= 8'h00;
    else if(clk_cnt == clk_ratio)
        clk_cnt <= 8'h00;
    else
        clk_cnt <= clk_cnt + 1;
end

endmodule
