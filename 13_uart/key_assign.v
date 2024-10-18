`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:10:07
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


module key_assign (
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
        r_bcd_data <= 5'h1f;
    end
    else if(i_key_valid) begin
             if(i_key_value==5'd1)  r_bcd_data <= 5'd00; //0
        else if(i_key_value==5'd2)  r_bcd_data <= 5'd01; //1
        else if(i_key_value==5'd3)  r_bcd_data <= 5'd02; //2
        else if(i_key_value==5'd4)  r_bcd_data <= 5'd03; //3
        else if(i_key_value==5'd5)  r_bcd_data <= 5'd04; //4
        else if(i_key_value==5'd6)  r_bcd_data <= 5'd05; //5
        else if(i_key_value==5'd7)  r_bcd_data <= 5'd06; //6
        else if(i_key_value==5'd8)  r_bcd_data <= 5'd07; //7
        else if(i_key_value==5'd9)  r_bcd_data <= 5'd08; //8
        else if(i_key_value==5'd10) r_bcd_data <= 5'd09; //9
        else if(i_key_value==5'd11) r_bcd_data <= 5'd10; //a
        else if(i_key_value==5'd12) r_bcd_data <= 5'd11; //b
        else if(i_key_value==5'd13) r_bcd_data <= 5'd12; //c
        else if(i_key_value==5'd14) r_bcd_data <= 5'd13; //d
        else if(i_key_value==5'd15) r_bcd_data <= 5'd14; //e
        else if(i_key_value==5'd16) r_bcd_data <= 5'd15; //f
        else if(i_key_value==5'd17) r_bcd_data <= 5'd16; //f
        else if(i_key_value==5'd18) r_bcd_data <= 5'd17; //f
        else if(i_key_value==5'd19) r_bcd_data <= 5'd18; //f
        else if(i_key_value==5'd20) r_bcd_data <= 5'd19; //f
        else                        r_bcd_data <= 5'h1f;
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