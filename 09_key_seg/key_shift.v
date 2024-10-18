`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/18 13:34:42
// Design Name: 
// Module Name: key_shift
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


module key_shift(
    input         i_rstn     ,
    input         i_clk      ,
    input         i_key_valid,
    input  [ 4:0] i_key_value,
    output [31:0] o_bcd8d      
);

reg [3:0] r_bcd_1, r_bcd_2, r_bcd_3, r_bcd_4, 
          r_bcd_5, r_bcd_6, r_bcd_7, r_bcd_8;
reg       r_key_valid;

always@(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_bcd_1 <= 4'd0;
        r_bcd_2 <= 4'd0;
        r_bcd_3 <= 4'd0;
        r_bcd_4 <= 4'd0;
        r_bcd_5 <= 4'd0;
        r_bcd_6 <= 4'd0;
        r_bcd_7 <= 4'd0;
        r_bcd_8 <= 4'd0;
    end
    else if(i_key_valid) begin
        r_bcd_1 <= i_key_value-1;
        r_bcd_2 <= r_bcd_1;
        r_bcd_3 <= r_bcd_2;
        r_bcd_4 <= r_bcd_3;
        r_bcd_5 <= r_bcd_4;
        r_bcd_6 <= r_bcd_5;
        r_bcd_7 <= r_bcd_6;
        r_bcd_8 <= r_bcd_7;
    end
end

always@(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_key_valid <= 1'b0;
    end
    else begin
        r_key_valid <= i_key_valid;
    end
end

assign o_bcd8d = {r_bcd_8, r_bcd_7, r_bcd_6, r_bcd_5,
                  r_bcd_4, r_bcd_3, r_bcd_2, r_bcd_1};

endmodule