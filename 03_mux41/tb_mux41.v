module tb_mux41();

reg [3:0] r_d0, r_d1, r_d2, r_d3;
reg [1:0] r_sel;
wire [3:0] w_y ;

mux41 U_MUX41(
    .i_d_0(r_d0),
    .i_d_1(r_d1),
    .i_d_2(r_d2),     
    .i_d_3(r_d3),
    .i_sel(r_sel),
    .o_y  (w_y)
);

initial begin
    #0;      r_sel=0;    r_d0=0; r_d1=1; r_d2=2; r_d3=3;
    #1000;   r_sel=1;
    #1000;   r_sel=2;     
    #1000;   r_sel=3;
    #1000;   r_sel=0;    r_d0=4; r_d1=5; r_d2=6; r_d3=7;
    #1000;   r_sel=1;
    #1000;   r_sel=2;     
    #1000;   r_sel=3;
    #1000;   r_sel=0;    r_d0=8; r_d1=9; r_d2=10; r_d3=11;
    #1000;   r_sel=1;
    #1000;   r_sel=2;     
    #1000;   r_sel=3; 
    #5000;   $finish;
end
   
endmodule
