module tb_keypad_fnd(
    );
        
reg   clk, rstn;
reg   [4:0]   key_row;

wire    [3:0]   key_col;
wire    [19:0]  key_data;

keypad_fnd U0 (
                .clk(clk),
                .rstn(rstn),
                .key_row(key_row),
                .key_col(key_col),
                .fnd_scan(fnd_scan),
                .fnd_data(fnd_data));
                
initial begin
    clk =   0;      rstn = 1;
    #5  rstn = 0; 
    #25 rstn = 1 ;
end

always #10 clk = ~ clk ;

initial begin
    #30;
    repeat (3) begin
            key_row = 5'b11111;
        #20 key_row = 5'b01111;
        #20;
    end
    repeat (3) begin
            key_row = 5'b11111;
        #20 key_row = 5'b10111;
        #20;
    end
    repeat (3) begin
            key_row = 5'b11111;
        #20 key_row = 5'b11011;
        #20;
    end
    repeat (3) begin
            key_row = 5'b11111;
        #20 key_row = 5'b11101;
        #20;
    end
    repeat (3) begin
            key_row = 5'b11111;
        #20 key_row = 5'b11110;
        #20;
    end
end
endmodule
