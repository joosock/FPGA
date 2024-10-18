`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 15:19:27
// Design Name: 
// Module Name: buzz_cnt
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


 module buzzer_cnt (
      input        i_rstn      ,
      input        i_clk       ,
      input        i_pls_1k    ,
      input        i_go        ,
      output       o_buzzer    
  );
  
  reg       r_start;
  reg       r_stop;
  reg [7:0] r_cnt;
  reg       r_buzz;
  
  //buzzer start reg
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_start <= 1'b0;
      end
      else begin
          if(i_go)
          r_start <= 1'b1;
          else if(r_stop)
              r_start <= 1'b0;
      end
  end

  //buzzer 3-time counter
  //stop reg
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_cnt <= 8'd0;    
          r_stop <= 1'b0;
      end
      else if(r_start & i_pls_1k) begin
          if(r_cnt==8'd255) begin
              r_cnt <= 0;
              r_stop <= 0;
          end
          else if(r_cnt==8'd254) begin
              r_stop <= 1'b1;
              r_cnt <= r_cnt +1;
          end
          else begin
              r_cnt <= r_cnt +1;
          end    
      end
  end
  
  //buzzer time setup, 50ms 단위로 3회 발생
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_buzz <= 1'b0;    
      end
      else begin
          if(r_cnt==8'd1)        r_buzz <= 1'b1;
          else if(r_cnt==8'd50)  r_buzz <= 1'b0;
          else if(r_cnt==8'd100) r_buzz <= 1'b1;
          else if(r_cnt==8'd150) r_buzz <= 1'b0;
          else if(r_cnt==8'd200) r_buzz <= 1'b1;
          else if(r_cnt==8'd250) r_buzz <= 1'b0;
      end
  end
  
  assign o_buzzer = r_buzz;
  
  endmodule