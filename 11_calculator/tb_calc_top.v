`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 11:49:37
// Design Name: 
// Module Name: tb_calc_top
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


module tb_calc_top;

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
    #33_000_000; key_push = 5'd8;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd9;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd3;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd7;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd6; //(-)
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd1; //(+)
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd3;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd19;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd4; //ent
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd4; //ent
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd4; //ent
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd8; //number
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd19; //number
    #33_000_000; key_push = 5'd0;

//    #33_000_000; key_push = 5'd7; //num 1
//    #33_000_000; key_push = 5'd0;
//    #33_000_000; key_push = 5'd3; //num 0
//    #33_000_000; key_push = 5'd0;    
//    #33_000_000; key_push = 5'd3; //num 0
//    #33_000_000; key_push = 5'd0;
//    #33_000_000; key_push = 5'd11;//(-)
//    #33_000_000; key_push = 5'd0; 
//    #33_000_000; key_push = 5'd7; //num 1
//    #33_000_000; key_push = 5'd0;
//    #33_000_000; key_push = 5'd7; //num 1
//    #33_000_000; key_push = 5'd0;
//    #33_000_000; key_push = 5'd7; //num 1
//    #33_000_000; key_push = 5'd0;
//    #33_000_000; key_push = 5'd4; //ent
    //#50_000; $finish;
end

`ifdef KEY_TEST
initial begin
    #0; key_push=5'd0;
    repeat(19) begin
        #33_000_000; key_push = key_push +1;
        #33_000_000; key_push = 0;
    end
    
    #50_000; $finish;
end
`endif

//test code

//instance block
key_pad U_KEY_MATRIX (
.rst            (rstn),
.clk            (clk),
.key_v          (key_push),
.key_column_in  (key_out),
.key_row_out    (key_in)
);

calc_top U_CALC_TOP(
    .i_rstn      (rstn),
    .i_clk       (clk),
    .i_key_in    (key_in),
    .o_key_out   (key_out),
    .o_seg_d     (),
    .o_seg_com   ()
);
    

endmodule