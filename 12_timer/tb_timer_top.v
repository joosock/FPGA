`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 15:24:36
// Design Name: 
// Module Name: tb_timer_top
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


module tb_timer_top;

reg clk;
reg rstn;
reg start_sw;
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
    #0; key_push=5'd0; start_sw=1;
    repeat(1) begin
        key_push = 12;  #33_000_000; 
        key_push = 0;   #33_000_000; 
        key_push = 12;  #33_000_000; 
        key_push = 0;   #33_000_000; 
        key_push = 13;  #33_000_000; 
        key_push = 0;   #33_000_000; 
        key_push = 13;  #33_000_000; 
        key_push = 0;   #33_000_000; 
        key_push = 14;  #33_000_000; 
        key_push = 0;   #33_000_000; 
        key_push = 7;   #33_000_000; 
        key_push = 0;   #33_000_000; 
        key_push = 8;   #33_000_000; 
        key_push = 0;   #33_000_000; 
        key_push = 9;   #33_000_000; 
    end
    #1_000_000; start_sw=0;
    #1_000_000; start_sw=1;
    #50_000; $finish;
end

//instance block
key_pad U_KEY_MATRIX (
    .rst            (rstn),
    .clk            (clk),
    .key_v          (key_push),
    .key_column_in  (key_out),
    .key_row_out    (key_in)
);

timer_top U_TIMER_TOP(
    .i_rstn      (rstn),
    .i_clk       (clk),
    .i_start_sw  (start_sw),
    .i_key_in    (key_in),
    .o_key_out   (key_out),
    .o_buzzer    (),
    .o_led       (),
    .o_seg_d     (),
    .o_seg_com   ()
);
    

endmodule