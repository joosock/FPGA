module arith4_core(
    input [7:0] i_d_a, i_d_b,
    input [1:0] i_sel,
    output [7:0] o_out
    );
    
wire [7:0] w_add;
wire [7:0] w_sub;
wire [7:0] w_mul;
wire [7:0] w_div;

arith4 U_ARITH4(
    .i_a    (i_d_a),
    .i_b    (i_d_b),
    .o_add  (w_add),
    .o_sub  (w_sub),
    .o_mul  (w_mul),
    .o_div  (w_div)
);

mux41 U_MUX41(
    .i_d_0  (w_add),
    .i_d_1  (w_sub),
    .i_d_2  (w_mul),
    .i_d_3  (w_div),
    .i_sel  (i_sel),
    .o_y    (o_out)
);    
    
endmodule
