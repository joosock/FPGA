module ex_top(clk,clear,A,B,C,S);

input clk;
input clear;
input [3:0] A;
input [3:0] B;
input [7:0] C;

output [7:0] S;

wire [3:0] r1;
wire [3:0] r2;
wire [7:0] s1;
wire [7:0] s2;
wire [7:0] s3;
wire [7:0] s4;
wire [7:0] s5;
wire [7:0] s6;

assign S = s6;

ex_4bitreg ex_4bR_1(.clk(clk)    ,
                    .clear(clear) ,
                    .d(A)        ,
                    .q(r1)
                    );
                    
ex_4bitreg ex_4bR_2(.clk(clk)    ,
                    .clear(clear) ,
                    .d(B)        ,
                    .q(r2)
                    );   
                    
ex_8bitreg ex_8bR_1(.clk(clk)    ,
                    .clear(clear) ,
                    .d(C)        ,
                    .q(s1)
                    );                                                         
                    
ex_multiplier ex_multi(.a(r1),
                       .b(r2),
                       .m(s2)
                       );
                    
ex_8bitreg ex_8bR_2(.clk(clk)    ,
                    .clear(clear) ,
                    .d(s2)       ,
                    .q(s3)
                    );                               
                    
ex_8bitreg ex_8bR_3(.clk(clk)    ,
                    .clear(clear) ,
                    .d(s1)       ,
                    .q(s4)        
                    );            
                    
ex_adder ex_add(.a(s3),
                .b(s4),
                .sum(s5)
                );
                
ex_8bitreg ex_8bR_4(.clk(clk)    ,
                    .clear(clear) ,
                    .d(s5)       ,
                    .q(s6)        
                    );                            

endmodule

module ex_4bitreg(clk,clear,d,q);

input clk    ;
input clear  ;
input [3:0] d;

output reg [3:0] q;

always@(posedge clear or posedge clk) begin
	if(clear)
	 q <= 4'b0;
	else
	 q <= d;
end

endmodule

module ex_8bitreg(clk,clear,d,q);

input clk    ;
input clear  ;
input [7:0] d;

output reg [7:0] q;

always@(posedge clear or posedge clk) begin
	if(clear)
	 q <= 8'b0;
	else
	 q <= d;
end

endmodule

module ex_adder(a,b,sum);

input [7:0] a;
input [7:0] b;

output [7:0] sum;

assign sum = a+b;

endmodule

module ex_multiplier(a,b,m);

input [3:0] a;
input [3:0] b;

output [7:0] m;

assign m = a*b; 

endmodule