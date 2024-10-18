`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 15:20:53
// Design Name: 
// Module Name: led_blink
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


 module led_blink (
      input        i_rstn  ,
      input        i_clk   ,
      input        i_pls_1k,
      input        i_go    ,
      output [7:0] o_led_on
  );
  
  reg       r_start;
  reg [7:0] r_cnt;
  reg [7:0] r_led;
  
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_start <= 1'b0;
      end
      else begin
          if(i_go)
          r_start <= 1'b1;
      end
  end
  
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_cnt <= 8'd0;    
      end
      else if(r_start & i_pls_1k) begin
          if(r_cnt==8'd255) begin
          r_cnt <= 0;
      end
      else begin
          r_cnt <= r_cnt +1;
      end    
      end
  end
  
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_led <= 8'b0000_0000;
      end
      else begin
          if(r_cnt==8'd5) 
              r_led <= 8'b0000_0001;
          else if(r_cnt==8'd35)
              r_led <= 8'b0000_0010;
          else if(r_cnt==8'd65)
              r_led <= 8'b0000_0100;
          else if(r_cnt==8'd95)
              r_led <= 8'b0000_1000;
          else if(r_cnt==8'd125)
              r_led <= 8'b0001_0000;
          else if(r_cnt==8'd155)
              r_led <= 8'b0010_0000;
          else if(r_cnt==8'd185)
              r_led <= 8'b0100_0000;
          else if(r_cnt==8'd215)
              r_led <= 8'b1000_0000;
          else if(r_cnt==8'd245)
              r_led <= 8'b0000_0000;
      end
  end
  
  assign o_led_on = ~r_led;
  
  endmodule