//`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/20 13:30:27
// Design Name: 
// Module Name: test
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

module tb_counter32b;

reg clk;
reg rstn;
reg       key_mode;
reg       key_clear;
reg [3:0] rotary;

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
    key_mode  = 1;
    key_clear = 1;
    rotary   = 0;
    repeat(16) begin
        #2000_000; key_mode =0; 
        #1000_000; key_mode =1;
        #10_000_000;
        #2000_000; key_mode =0; 
        #1000_000; key_mode =1;
        repeat(2) begin
            #10_000_000; key_clear =0;
            #10_000_000; key_clear =1;
        end
        #10_000_000;
	rotary = rotary+1;
    end	
    
end

//counter block instance
counter32b U_CNT32B (
    .i_rstn       (rstn     ),
    .i_clk        (clk      ),
    .i_key2_clear (key_clear),
    .i_key1_mode  (key_mode ),
    .i_rotary     (~rotary   )
);


endmodule

