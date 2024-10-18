`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 15:16:40
// Design Name: 
// Module Name: key_assign
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


module key_assign(
    input        i_rstn     ,
    input        i_clk      ,
    input        i_key_valid,
    input  [4:0] i_key_value,
    output [4:0] o_bcd_data ,
    output       o_key_valid
);

reg [4:0] r_bcd_data;
reg       r_key_valid;

always@(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_bcd_data <= 4'hf; 
    end
    else if(i_key_valid) begin  //key** --> bcd data 
             if(i_key_value==5'd12) r_bcd_data <= 5'h1;
        else if(i_key_value==5'd13) r_bcd_data <= 5'h2;
        else if(i_key_value==5'd14) r_bcd_data <= 5'h3;
        else if(i_key_value==5'd7)  r_bcd_data <= 5'h4;
        else if(i_key_value==5'd8)  r_bcd_data <= 5'h5;
        else if(i_key_value==5'd9)  r_bcd_data <= 5'h6;
        else                        r_bcd_data <= 5'hf;
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


assign o_bcd_data = r_bcd_data;
assign o_key_valid = r_key_valid;

endmodule