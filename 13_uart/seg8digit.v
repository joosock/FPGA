`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:22:27
// Design Name: 
// Module Name: seg8digit
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


module seg8digit(
      input        i_rstn   ,
      input        i_clk    ,
      input        i_pls_1k ,
      input [31:0] i_bcd8d  ,
      output [7:0] o_seg_d  ,
      output [7:0] o_seg_com   
  );
  
  reg [2:0] cnt_com;
  reg [7:0] r_seg_com;
  reg [7:0] r_seg_d;
  
  wire [3:0] w_bcd_sel;
  wire [6:0] w_segb;
  wire [7:0] w_seg_com;
  wire       w_dot=0;
  
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          cnt_com <= 3'd0;
      end
      else if(i_pls_1k) begin
          if(cnt_com==3'd7) begin
              cnt_com <= 3'd0;
          end
          else begin
              cnt_com <= cnt_com +1;
          end
      end
  end

  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_seg_com <= 8'h0;
          r_seg_d   <= 8'h0;
      end
      else if(i_pls_1k) begin
          r_seg_com <= w_seg_com;
          r_seg_d   <= {w_dot, w_segb};
      end
  end
  
  assign w_bcd_sel =
      (cnt_com == 0) ? i_bcd8d[31:28] : // Digit 7
      (cnt_com == 1) ? i_bcd8d[27:24] : // Digit 6
      (cnt_com == 2) ? i_bcd8d[23:20] : // Digit 5  
      (cnt_com == 3) ? i_bcd8d[19:16] : // Digit 4  
      (cnt_com == 4) ? i_bcd8d[15:12] : // Digit 3  
      (cnt_com == 5) ? i_bcd8d[11:08] : // Digit 2  
      (cnt_com == 6) ? i_bcd8d[07:04] : // Digit 1  
                       i_bcd8d[03:00] ; // Digit 0            
  assign w_segb =     
      (w_bcd_sel == 4'h0) ? (7'h3f) :
      (w_bcd_sel == 4'h1) ? (7'h06) :
      (w_bcd_sel == 4'h2) ? (7'h5b) :
      (w_bcd_sel == 4'h3) ? (7'h4f) :
      (w_bcd_sel == 4'h4) ? (7'h66) :
      (w_bcd_sel == 4'h5) ? (7'h6d) :
      (w_bcd_sel == 4'h6) ? (7'h7d) :
      (w_bcd_sel == 4'h7) ? (7'h27) :
      (w_bcd_sel == 4'h8) ? (7'h7f) :
      (w_bcd_sel == 4'h9) ? (7'h6f) :
      (w_bcd_sel == 4'ha) ? (7'h77) :
      (w_bcd_sel == 4'hb) ? (7'h7c) :
      (w_bcd_sel == 4'hc) ? (7'h39) :
      (w_bcd_sel == 4'hd) ? (7'h5E) :
      (w_bcd_sel == 4'he) ? (7'h79) :
      (w_bcd_sel == 4'hf) ? (7'h71) :
                            (7'h00);
  assign w_seg_com =
      cnt_com==3'd0 ? 8'b1000_0000 : //digit7
      cnt_com==3'd1 ? 8'b0100_0000 : //digit6
      cnt_com==3'd2 ? 8'b0010_0000 : //digit5
      cnt_com==3'd3 ? 8'b0001_0000 : //digit4
      cnt_com==3'd4 ? 8'b0000_1000 : //digit3
      cnt_com==3'd5 ? 8'b0000_0100 : //digit2
      cnt_com==3'd6 ? 8'b0000_0010 : //digit1
                      8'b0000_0001 ; //digit0
                                 
  assign o_seg_com = r_seg_com;
  assign o_seg_d = r_seg_d;
  
  endmodule