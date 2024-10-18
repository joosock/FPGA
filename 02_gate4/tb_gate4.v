
module tb_gate4(

    );
    
reg r_a, r_b, r_c, r_d;
wire w_y1;
wire w_y2;

gate4 U_GATE4(
.i_a(r_a),
.i_b(r_b),
.i_c(r_c),
.i_d(r_d),
.o_y1(w_y1),
.o_y2(w_y2)
);

initial begin
    #10;    r_a=0;  r_b=0;  r_c=0;  r_d=0;
    #1000;  r_a=0;  r_b=0;  r_c=0;  r_d=1;
    #1000;  r_a=0;  r_b=0;  r_c=1;  r_d=0;
    #1000;  r_a=0;  r_b=0;  r_c=1;  r_d=1;
    #1000;  r_a=0;  r_b=1;  r_c=0;  r_d=0;
    #1000;  r_a=0;  r_b=1;  r_c=0;  r_d=1;  
    #1000;  r_a=0;  r_b=1;  r_c=1;  r_d=0;
    #1000;  r_a=0;  r_b=1;  r_c=1;  r_d=1; 
    #1000;  r_a=1;  r_b=0;  r_c=0;  r_d=0; 
    #1000;  r_a=1;  r_b=0;  r_c=0;  r_d=1;
    #1000;  r_a=1;  r_b=0;  r_c=1;  r_d=0;
    #1000;  r_a=1;  r_b=0;  r_c=1;  r_d=1;
    #1000;  r_a=1;  r_b=1;  r_c=0;  r_d=0;
    #1000;  r_a=1;  r_b=1;  r_c=0;  r_d=1;  
    #1000;  r_a=1;  r_b=1;  r_c=1;  r_d=0;
    #1000;  r_a=1;  r_b=1;  r_c=1;  r_d=1;  
end
    
endmodule
