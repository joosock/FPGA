`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/18 13:24:45
// Design Name: 
// Module Name: tb_key_seq
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


module tb_key_seg;

reg clk;
reg rstn;
reg [4:0] key_push;

wire [3:0] key_out;
wire [4:0] key_in;

initial begin
    #0;  rstn=0;
    #10; rstn=1;
end
initial begin
    #0; clk=0;
    forever begin
        #50 clk = ~clk;
    end
end


initial begin
    #0; key_push=5'd0;
    #33_000_000; 
    #33_000_000; key_push = 21;
    #33_000_000; key_push = 0;
    #33_000_000; key_push = 1;
    repeat(19) begin
        key_push = key_push +1;
        #33_000_000; 
    end
    #33_000_000; key_push = 21;
    
    #50_000; $finish;
end

//test code

//instance block
key_pad U_KEY_MATRIX (
.rst            (rstn),
.clk            (clk),
.key_v          (key_push),
.key_column_in  (key_out),
.key_row_out    (key_in)
);

key_seg_top U_KEY_SEG (
    .i_rstn      (rstn),
    .i_clk       (clk),
    .i_key_in    (key_in),
    .o_key_out   (key_out),
    .o_seg_d     (),
    .o_seg_com   ()
);
    

endmodule