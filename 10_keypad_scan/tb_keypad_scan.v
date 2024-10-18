`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/01 14:04:26
// Design Name: 
// Module Name: tb_keypad_scan
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_keypad_scan();

reg clk, rst;
reg [3:0] key_row;
wire [2:0] key_col;
wire [11:0] key_data;

keypad_scan U0 (.clk(clk), .rst(rst), .key_row(key_row), .key_col(key_col), .key_data(key_data));

initial begin
    clk=0; rst=0;
    #5 rst=1; #10 rst=0;
end

always #10 clk=~clk;

initial begin
    #30;
    repeat(3) begin
            key_row=4'b0000;
        #20 key_row=4'b0001;
        #20;
    end
    repeat(3) begin
            key_row=4'b0000;
        #20 key_row=4'b0010;
        #20;
    end
    repeat(3) begin
            key_row=4'b0000;
        #20 key_row=4'b0100;
        #20;
    end
    repeat(3) begin
            key_row=4'b0000;
        #20 key_row=4'b1000;
        #20;
    end
end
endmodule
