module led(
    input i_a,
    input i_b,
    output o_and,
    output o_nand,
    output o_or,
    output o_nor,
    output o_xor,
    output o_inv
    );
    
assign  o_and   =   i_a & i_b;
assign  o_nand  =   ~(i_a & i_b);
assign  o_or    =   i_a | i_b;
assign  o_nor   =   ~(i_a | i_b);
assign  o_xor   =   i_a ^ i_b;
assign  o_inv   =   ~i_a;

endmodule