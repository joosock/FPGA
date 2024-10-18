module keypad_fnd(
    input clk, 
    input rstn,
    input [4:0] key_row,
    output [3:0] key_col,
    output [7:0] fnd_scan,
    output [7:0] fnd_data
    );
    
wire [19:0] key_data;

keypad_scan U0(
                .clk(clk),
                .rstn(rstn),
                .key_row(key_row),
                .key_col(key_col),
                .key_data(key_data));
                
`include "fnd_disp.v"
        
assign fnd_data = fnd_disp(key_data);
assign fnd_scan = 8'b0000_0001;

endmodule

