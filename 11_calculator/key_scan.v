`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 11:48:04
// Design Name: 
// Module Name: key_scan
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


 module key_scan(
      input        i_rstn     ,
      input        i_clk      ,
      input        i_pls_1k   ,
      input  [4:0] i_key_in   ,
      output [3:0] o_key_out  ,
      output       o_key_valid,
      output [4:0] o_key_value
  );
  
  reg       r_k_en;
  reg [3:0] r_cnt;
  reg [1:0] r_kcnt;
  reg [4:0] r_tcnt;
  reg [3:0] r_key_out;
  
  reg [4:0] r_key_rdata;
  reg       r_key_multi;
  reg       r_key_on;
  reg       r_key_valid;
  reg [4:0] r_key_value;
  
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_k_en <= 1'b0;
      end
      else begin
          if(i_pls_1k) begin
              r_k_en <= 1'b1;
          end
          else if(r_k_en==1'b1 && 
                  r_kcnt==2'd3 && r_cnt==4'd9) begin
              r_k_en <= 1'b0;
          end
      end
  end

  //key scan counter setup
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_cnt <= 4'd0;
          r_kcnt <= 2'd0;
      end
      else if(r_k_en) begin
          if(r_cnt== 4'd9) begin
              r_cnt <= 4'd0;
              if(r_kcnt==2'd3) begin
                  r_kcnt <= 2'd0;
              end
              else 
                  r_kcnt <= r_kcnt + 2'd1;
          end
          else begin
              r_cnt <= r_cnt + 4'd1;
          end
          
      end
  end
  //key scan output write
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_key_out <= 4'b1111;
      end
      else if(r_k_en) begin
          if(r_cnt==4'd1 && r_kcnt==2'd0)
              r_key_out <= 4'b1110;
          else if(r_cnt==4'd9 && r_kcnt==2'd0)
              r_key_out <= 4'b1111;
          else if(r_cnt==4'd1 && r_kcnt==2'd1)
              r_key_out <= 4'b1101;
          else if(r_cnt==4'd9 && r_kcnt==2'd1)
              r_key_out <= 4'b1111;
          else if(r_cnt==4'd1 && r_kcnt==2'd2)
              r_key_out <= 4'b1011;
          else if(r_cnt==4'd9 && r_kcnt==2'd2)
              r_key_out <= 4'b1111;
          else if(r_cnt==4'd1 && r_kcnt==2'd3)
              r_key_out <= 4'b0111;
          else if(r_cnt==4'd9 && r_kcnt==2'd3)
              r_key_out <= 4'b1111;
      end
  end
  
  //key scan input read
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_key_rdata <= 5'd0;
          r_key_multi <= 1'b0;
          r_key_on    <= 1'b0;
      end
      else begin
          if(r_kcnt==2'd0 && r_cnt==4'd1) begin
              r_key_on <= 1'b0;
              r_key_multi <= 1'b0;
          end
          else if(r_key_multi) begin
              r_key_on <= 1'b1;
              r_key_rdata <= 5'd31; //multi key
          end
          else if(r_cnt==4'd6 && r_key_on==1'b0) begin
              if(i_key_in==5'b11111) 
                  r_key_rdata <= 5'd0; //no key
              else if (i_key_in==5'b11110)
                  r_key_rdata <= 5'd1 + (r_kcnt*5);
              else if (i_key_in==5'b11101)
                  r_key_rdata <= 5'd2 + (r_kcnt*5);
              else if (i_key_in==5'b11011)
                  r_key_rdata <= 5'd3 + (r_kcnt*5);
              else if (i_key_in==5'b10111)
                  r_key_rdata <= 5'd4 + (r_kcnt*5);
              else if (i_key_in==5'b01111)    
                  r_key_rdata <= 5'd5 + (r_kcnt*5);
              else 
                  r_key_multi <= 1'b1;
              //no key check
              if ( ~(i_key_in[0] & i_key_in[1] & i_key_in[2] & i_key_in[3] & i_key_in[4]) )
                  r_key_on <= 1'b1;
          end
          else if(r_cnt==4'd6 && r_key_on==1'b1) begin
              if ( ~(i_key_in[0] & i_key_in[1] & i_key_in[2] & i_key_in[3] & i_key_in[4]) )
                  r_key_multi <= 1'b1;
          end
      end
  end
  
  // 1st key data save 
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_key_value <= 5'd0;
      end
      else begin
          if(r_kcnt==2'd3 && r_cnt==4'd8 && r_key_on==1'b1 && r_key_multi==1'b0)
              r_key_value <= r_key_rdata;
      end
  end
  
  //key scan output vaild timing & 20 times algorithm
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_tcnt      <= 5'd0;
          r_key_valid <= 1'b0;
      end
      else begin
          if(r_key_multi) begin
              r_tcnt <= 5'd0;
          end
          else if(r_kcnt==2'd3 && r_cnt==4'd8 && r_key_on==1'b0) begin
              r_tcnt <= 5'd0;
          end
          else if(r_kcnt==2'd3 && r_cnt==4'd8 && r_key_on==1'b1) begin
              if(r_key_value != r_key_rdata) begin
                  r_tcnt <=0;
              end
              else begin
                  if(r_tcnt == 5'd24) begin
                      r_key_valid <= 1'b1;
                      r_tcnt <= r_tcnt +1;
                  end
                  else if(r_tcnt != 5'd25) begin
                      r_tcnt <= r_tcnt +1;
                  end    
              end

          end
          else begin
              r_key_valid <= 1'b0;
          end
      end
  end
  
  assign o_key_out = r_key_out;
  assign o_key_valid = r_key_valid;
  assign o_key_value = r_key_value;

  endmodule