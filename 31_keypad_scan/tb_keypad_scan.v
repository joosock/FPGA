module tb_keypad_scan(
    );
        
reg   clk, rstn;
reg   [3:0]   key_row;

wire    [2:0]   key_col;
wire    [11:0]  key_data;

keypad_scan U0 (
                .clk(clk),
                .rstn(rstn),
                .key_row(key_row),
                .key_col(key_col),
                .key_data(key_data));
initial begin
    clk =   0;      rstn = 1;
    #5  rstn = 0; 
    #25 rstn = 1 ;
end

always #10 clk = ~ clk ;

initial begin
    #30;
    repeat (3) begin
            key_row = 4'b1111;
        #20 key_row = 4'b0111;
        #20;
    end
    repeat (3) begin
            key_row = 4'b1111;
        #20 key_row = 4'b1011;
        #20;
    end
    repeat (3) begin
            key_row = 4'b1111;
        #20 key_row = 4'b1101;
        #20;
    end
    repeat (3) begin
            key_row = 4'b1111;
        #20 key_row = 4'b1110;
        #20;
    end
end
endmodule
