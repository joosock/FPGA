`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/08 10:19:35
// Design Name: 
// Module Name: tb_led
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


module tb_led(

    );
    
reg r_a;
reg r_b;

initial begin
#10;    r_a = 0; r_b = 0;
#100;   r_a = 0; r_b = 1;
#100;   r_a = 1; r_b = 0;
#100;   r_a = 1; r_b = 1;
end

led U_TEST(
    .i_a    (r_a    ),
    .i_b    (r_b    ),
    .o_and  (w_and  ),
    .o_nand (w_nand ),
    .o_or   (w_or   ),
    .o_nor  (w_nor  ),
    .o_xor  (w_xor  ),
    .o_inv  (w_inv  ));
    
endmodule
