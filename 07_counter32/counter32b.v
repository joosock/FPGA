module counter32b(
    input       i_rstn,
    input       i_clk,
    input       i_key2_clear,
    input       i_key1_mode,
    input   [3:0]   i_rotary,
    output  [3:0]   o_tled,
    output  [3:0]   o_kled,
    output  [7:0]   o_led
);

reg     r_key_d1; 
reg     r_key_d2; 
reg [31:0]  r_cnt; //32bit counting register)
reg [15:0]  r_cnt_out; // 16개 LED 만 있어서 
reg         r_cnt_mode; //counter mode 

//rising edge detect & mode inversion(r_cnt_mode를 만듬)
always @ (posedge i_clk, negedge i_rstn)    begin
    if(!i_rstn) begin
        r_key_d1 <= 1'b0;
        r_key_d2 <= 1'b0;
        r_cnt_mode <= 1'b0;
    end
    else begin
        r_key_d1 <= ~i_key1_mode;
        r_key_d2 <= r_key_d1;
            if(r_key_d1 & (~r_key_d2)) begin
                r_cnt_mode <= ~r_cnt_mode;
            end
     end
end

//32bit counter
always @ (posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_cnt <= 32'b0;
    end
    else begin
        if(!i_key2_clear) begin
            r_cnt <= 0;
        end
        else if (r_cnt_mode) begin
            r_cnt <= r_cnt + 1;
        end
    end
end

// output selection
wire [3:0] w_rotary = ~i_rotary;
always @ (posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_cnt_out <= 16'b0;
    end
    else begin
        case(w_rotary)
            4'hf    :   r_cnt_out <= r_cnt[31:16];
            4'he    :   r_cnt_out <= r_cnt[30:15];
            4'hd    :   r_cnt_out <= r_cnt[29:14];
            4'hc    :   r_cnt_out <= r_cnt[28:13];
            4'hb    :   r_cnt_out <= r_cnt[27:12];
            4'ha    :   r_cnt_out <= r_cnt[26:11];
            4'h9    :   r_cnt_out <= r_cnt[25:10];
            4'h8    :   r_cnt_out <= r_cnt[24: 9];
            4'h7    :   r_cnt_out <= r_cnt[23: 8];
            4'h6    :   r_cnt_out <= r_cnt[22: 7];
            4'h5    :   r_cnt_out <= r_cnt[21: 6];
            4'h4    :   r_cnt_out <= r_cnt[20: 5];
            4'h3    :   r_cnt_out <= r_cnt[19: 4];
            4'h2    :   r_cnt_out <= r_cnt[18: 3];
            4'h1    :   r_cnt_out <= r_cnt[17: 2];
            default :   r_cnt_out <= r_cnt[16: 1]; 
        endcase
    end
end

//FPGA output port assign, LED 는 Low Active 임 
assign o_tled = ~r_cnt_out[15:12];
assign o_kled = ~r_cnt_out[11: 8];
assign o_led  = ~r_cnt_out[7 : 0];

endmodule 

            
            
            
            
            
            
            
            
            
            
