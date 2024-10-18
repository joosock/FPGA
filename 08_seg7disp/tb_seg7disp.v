`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/18 11:18:21
// Design Name: 
// Module Name: tb_seg7disp
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


module tb_seg7disp;

reg clk;
reg rstn;

reg       key_0;
reg [3:0] rotary;
reg [7:0] dip;

wire [7:0] seg_d, seg_com;

initial begin
    #0;  rstn=0;
    #10000; rstn=1;
end
initial begin
    #0; clk=0;
    forever begin
        #50 clk = ~clk;
    end
end

initial begin
    #0;
    key_0  = 1;
    rotary = 0;
    dip=1;
    repeat(16) begin
        dip=1;
        #100_000;
        repeat(7) begin
            dip = dip << 1 ;
            #100_000;
        end
        rotary = rotary+1;
    end
    key_0  = 0;
    repeat(16) begin
        dip=1;
        #100_000;
        repeat(7) begin
            dip = dip << 1 ;
            #100_000;
        end
        rotary = rotary+1;
    end
    
end

//7seg disp block instance
  seg7disp U_SEG7DISP (
      .i_rstn   (rstn  ),
      .i_clk    (clk   ),
      .i_key0   (key_0 ),
      .i_dip    (dip   ),
      .i_rotary (rotary),
      .o_seg_d  (seg_d  ),
      .o_seg_com(seg_com)
  );

endmodule