module tb_arith4_core;

reg [7:0] r_d0, r_d1;
reg [1:0] r_sel;
wire [7:0] w_y;

arith4_core U_ARITH4_CORE(
    .i_d_a(r_d0),
    .i_d_b(r_d1),
    .i_sel(r_sel),
    .o_out(w_y)
);

initial begin
    #0;     r_sel=0;    r_d0=2;     r_d1=1;
    #1000;  r_sel=1;
    #1000;  r_sel=2;
    #1000;  r_sel=3;
    #1000;     r_sel=0;    r_d0=15;     r_d1=15;
    #1000;  r_sel=1;
    #1000;  r_sel=2;
    #1000;  r_sel=3;
    #1000;     r_sel=0;    r_d0=100;     r_d1=97;
    #1000;  r_sel=1;
    #1000;  r_sel=2;
    #1000;  r_sel=3; 
    #5000;  $finish;
end
    
endmodule
