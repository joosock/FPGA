`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/18 11:17:25
// Design Name: 
// Module Name: seg7disp
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


module seg7disp (
      input        i_rstn   ,
      input        i_clk    ,
      input        i_key0   ,  //해당 세그컨트에 dot 표시 
      input  [7:0] i_dip    ,
      input  [3:0] i_rotary ,
      output [7:0] o_seg_d  ,
      output [7:0] o_seg_com
  );
  
  wire       w_key_dot;  //dot on/off 
  wire [3:0] w_rotary ;
  wire [6:0] w_segd   ;

  reg  [7:0] r_seg_d;
  reg  [7:0] r_seg_com;

  //assign input to wire
  assign w_key_dot = ~i_key0;
  assign w_rotary  = ~i_rotary;

  //hex to seg converting
  assign w_segd = (w_rotary==4'h0) ? 7'h3f : //segment 글자 "0"
                  (w_rotary==4'h1) ? 7'h06 : //segment 글자 "1"
                  (w_rotary==4'h2) ? 7'h5b :
                  (w_rotary==4'h3) ? 7'h4f :
                  (w_rotary==4'h4) ? 7'h66 :
                  (w_rotary==4'h5) ? 7'h6d :
                  (w_rotary==4'h6) ? 7'h7d :
                  (w_rotary==4'h7) ? 7'h27 :
                  (w_rotary==4'h8) ? 7'h7f :
                  (w_rotary==4'h9) ? 7'h6f :
                  (w_rotary==4'ha) ? 7'h5f :
                  (w_rotary==4'hb) ? 7'h7c :
                  (w_rotary==4'hc) ? 7'h58 :
                  (w_rotary==4'hd) ? 7'h5e :
                  (w_rotary==4'he) ? 7'h7b ://segment 글자 "e"
                                     7'h71 ;//segment 글자 "F"

  //rising edge detect & mode inversion
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_seg_d   <= 8'h0;
          r_seg_com <= 8'h0;
      end
      else begin
          r_seg_d   <= {w_key_dot, w_segd};
          r_seg_com <= i_dip;
      end
  end
  //assign output
  assign o_seg_d = r_seg_d;
  assign o_seg_com = r_seg_com;

  
  
endmodule

