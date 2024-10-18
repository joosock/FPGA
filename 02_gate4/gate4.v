module gate4(
    input i_a,
    input i_b,
    input i_c,
    input i_d,
    output o_y1,
    output o_y2
    );
wire w_or, w_and, w_nor, w_nand, w_xor;

assign w_or     =   i_a | i_b;
assign w_and    =   i_c & i_d;
assign w_nor    =   ~(i_a | i_b);
assign w_nand   =   ~(i_c & i_d);
assign w_xor    =   w_nor ^ w_nand;

assign o_y1     =   w_or | w_and;
assign o_y2     =   ~w_xor;

endmodule
