`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 11:44:34
// Design Name: 
// Module Name: calc_disp
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


module calc_disp (
      input         i_rstn      ,
      input         i_clk       ,
      input         i_key_valid ,
      input  [ 4:0] i_bcd_data  ,
      output [31:0] o_bcd8d     ,
      output [ 3:0] o_led_op    ,
      output        o_err    
  );
  reg r_mode_a;
  reg r_mode_b;
  reg r_mode_op;
  reg r_mode_c;

  reg r_kv_d;
  reg r_kv_d2;
  reg [31:0] r_a;
  reg [31:0] r_b;

  reg [53:0] r_c;
  reg [ 1:0] r_op;

  reg        r_err;

  wire [31:0] w_c;

  wire [ 3:0] w_c_1;
  wire [ 3:0] w_c_2;
  wire [ 3:0] w_c_3;
  wire [ 3:0] w_c_4;
  wire [ 3:0] w_c_5;
  wire [ 3:0] w_c_6;
  wire [ 3:0] w_c_7;
  wire [ 3:0] w_c_8;

  wire [26:0] w_c1;
  wire [26:0] w_c2;
  wire [26:0] w_c3;
  wire [26:0] w_c4;
  wire [26:0] w_c5;
  wire [26:0] w_c6;
  wire [26:0] w_c7;
  wire [26:0] w_c8;
  wire [26:0] w_c9;

  wire [26:0] w_a_s;
  wire [26:0] w_b_s;

  wire [31:0] w_dis;
  
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_mode_a <= 1'b0;
          r_mode_b <= 1'b0;
          r_mode_op <= 1'b0;
          r_mode_c <= 1'b0;
      end
      else if(i_key_valid) begin
          //(ESC) priority is best
          if(i_bcd_data==5'h14) begin 
              r_mode_a <= 1'b0;
              r_mode_b <= 1'b0;
              r_mode_op <= 1'b0;
              r_mode_c <= 1'b0;
          end
          //Operator
          else if(r_mode_a) begin 
              if(i_bcd_data>=5'h10 && i_bcd_data<=5'h13) begin
                  r_mode_a <= 1'b0;
                  r_mode_op <= 1'b1;
              end 
              //F1, F2, F3, F4, Ent
              else if(i_bcd_data>=5'h14 && i_bcd_data<=5'h1f)
                  r_mode_a <= 1'b0;
          end
          else if(r_mode_b) begin
              if(i_bcd_data==5'h15) begin //(Ent)
                  r_mode_b <= 1'b0;
                  r_mode_c <= 1'b1;
              end
              //F1, F2, F3, F4, operator(+ - x /)
              else if(i_bcd_data>=5'h10 && i_bcd_data<=5'h1f)
                  r_mode_b <= 1'b0;
          end
          else if(r_mode_op) begin
              //Number
              if(i_bcd_data>=5'h00 && i_bcd_data<=5'h09) begin
                  r_mode_op <= 1'b0;
                  r_mode_b <= 1'b1;
              end
          end
          else if(r_mode_c) begin 
              //ent + ent
              if(i_bcd_data==5'h15)
                  r_mode_c <= 1'b0;
              //Number
              else if(i_bcd_data>=5'h00 && i_bcd_data<=5'h09) begin
                  r_mode_c <= 1'b0;
                  r_mode_a <= 1'b1;
              end
          end
          //Number
          else if(i_bcd_data>=5'h00 && i_bcd_data<=5'h09) begin
                  r_mode_c <= 1'b0;
                  r_mode_a <= 1'b1;
          end
      end
  end
  
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_kv_d  <= 1'b0;
          r_kv_d2 <= 1'b0;
      end
      else begin
          r_kv_d  <= i_key_valid;
          r_kv_d2 <= r_kv_d ;
      end
  end

  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_a <= 32'd0;
          r_b <= 32'd0;

          r_c <= 54'd0;
          r_op <= 2'd0;
      end
      else if(r_kv_d) begin
          if(i_bcd_data==5'h14) begin //ESC
              r_a <= 32'd0;
              r_b <= 32'd0;

              r_c <= 54'd0;
              r_op <= 2'd0;
          end
          else if(r_mode_a) begin
              if(i_bcd_data>=5'h00 && i_bcd_data<=5'h09) begin
                  r_c <= 0;
                  r_a   <= {r_a[27:0],i_bcd_data[3:0]};
              end
          end
          else if(r_mode_b) begin
              if(i_bcd_data>=5'h00 && i_bcd_data<=5'h09) begin
                  r_b   <= {r_b[27:0],i_bcd_data[3:0]};
              end      
          end      
          else if(r_mode_op) begin
              if(i_bcd_data[4:2]==3'b100)
                  r_op <= i_bcd_data[1:0];
          end
          else if(r_mode_c) begin
              case (r_op)
                  0 : r_c <= w_a_s / w_b_s;
                  1 : r_c <= w_a_s * w_b_s;
                  2 : r_c <= w_a_s - w_b_s;
                  3 : r_c <= w_a_s + w_b_s;
                  default : r_c <= 0;
              endcase
              r_a <= 32'd0;
              r_b <= 32'd0;
          end
          else if(i_bcd_data>=5'h10) begin
              r_a <= 32'd0;
              r_b <= 32'd0;

              r_c <= 54'd0;
              r_op <= 2'd0;
          end
      end
  end

  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_err <= 1'b0;
      end
      else if(r_kv_d2 & r_mode_c) begin
          if(r_c > 99999999) begin
              r_err <= 1'b1;
          end  
          if(r_op==2'd2 && w_a_s < w_b_s) begin
              r_err <= 1'b1;
          end  
      end
      else if(r_kv_d) begin
          if(i_bcd_data==5'h14) //(ESC) priority is best
              r_err <= 1'b0;
          if(r_mode_a) //mode a
              r_err <= 1'b0;
      end
  end

  assign w_a_s = (r_a[31:28] * 10000000) +
                 (r_a[27:24] * 1000000 ) +
                 (r_a[23:20] * 100000  ) +
                 (r_a[19:16] * 10000   ) +
                 (r_a[15:12] * 1000    ) +
                 (r_a[11: 8] * 100     ) +
                 (r_a[ 7: 4] * 10      ) +
                 (r_a[ 3: 0] * 1       );
  assign w_b_s = (r_b[31:28] * 10000000) +
                 (r_b[27:24] * 1000000 ) +
                 (r_b[23:20] * 100000  ) +
                 (r_b[19:16] * 10000   ) +
                 (r_b[15:12] * 1000    ) +
                 (r_b[11: 8] * 100     ) +
                 (r_b[ 7: 4] * 10      ) +
                 (r_b[ 3: 0] * 1       );

  assign w_c9 = r_c/100000000 ; 
  assign w_c8 = r_c/10000000  ; 
  assign w_c7 = r_c/1000000   ; 
  assign w_c6 = r_c/100000    ; 
  assign w_c5 = r_c/10000     ; 
  assign w_c4 = r_c/1000      ; 
  assign w_c3 = r_c/100       ; 
  assign w_c2 = r_c/10        ; 
  assign w_c1 = r_c/1         ; 

  assign w_c_8 = w_c8 - (w_c9*10) ;
  assign w_c_7 = w_c7 - (w_c8*10) ;
  assign w_c_6 = w_c6 - (w_c7*10) ;
  assign w_c_5 = w_c5 - (w_c6*10) ;
  assign w_c_4 = w_c4 - (w_c5*10) ;
  assign w_c_3 = w_c3 - (w_c4*10) ;
  assign w_c_2 = w_c2 - (w_c3*10) ;
  assign w_c_1 = w_c1 - (w_c2*10) ;

  assign w_c = {w_c_8, w_c_7, w_c_6, w_c_5,
                w_c_4, w_c_3, w_c_2, w_c_1};

  assign w_dis = r_mode_a   ? r_a :
                 r_mode_op  ? r_a :
                 r_mode_b   ? r_b :
                 r_mode_c   ? w_c : 0;

  assign o_bcd8d = w_dis;

  assign o_led_op = 
  r_op==2'd0 && r_mode_op==1'b1 ? 4'b1110 : //(/)
  r_op==2'd1 && r_mode_op==1'b1 ? 4'b1101 : //(*)
  r_op==2'd2 && r_mode_op==1'b1 ? 4'b1011 : //(-)
  r_op==2'd3 && r_mode_op==1'b1 ? 4'b0111 : //(+)
                                  4'b1111 ;
  assign o_err = r_err;

  endmodule