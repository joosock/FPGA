module pipeline_top(reset,clk,read,write,inst_ld);

	input reset;
	input clk;

	output read;
	output write;
	output inst_ld;


	wire sig_mc_clk            ;
	wire sig_mem_clk           ;
	wire sig_READ              ;
	wire sig_WRITE             ;
	wire sig_INST_LD           ;
	wire [4:0]sig_prom_addr_out;
	wire [4:0]sig_ir_reg       ;
	wire [7:0]sig_mem_data_in  ;
	wire [7:0]sig_prom_data_in ;
	wire [7:0]sig_mem_data_out ;
	wire [7:0]sig_mem_dout     ;

assign read    = sig_READ   ;
assign write   = sig_WRITE  ;
assign inst_ld = sig_INST_LD;


pipeline_mc pipeline_mc_blk(.clk           (sig_mc_clk        ),
                                 .reset          (reset             ),
                                 .prom_data_in  (sig_prom_data_in  ),
                                 .mem_data_in  (sig_mem_data_in   ),
                                 .READ        (sig_READ         ),
                                 .WIRTE       (sig_WRITE        ),
                                 .INST_LD     (sig_INST_LD      ),
                                 .IR_REG       (sig_ir_reg         ),
                                 .prom_addr_out(sig_prom_addr_out ),
                                 .mem_data_out (sig_mem_data_out )
                                 );
                            
dataram dataram_blk(.reset     (reset              ),
                    .clk       (sig_mem_clk       ),
                    .READ    (sig_READ         ),
                    .WRITE   (sig_WRITE       ),
                    .MEM_ADDR(sig_ir_reg       ),
                    .MEM_DIN (sig_mem_data_out ),
                    .MEM_DOUT(sig_mem_data_in )
                    );
                    
prom prom_blk(.reset   (reset            ),
              .clk     (sig_mem_clk      ),
              .MEM_ADDR(sig_prom_addr_out),
              .MEM_DOUT(sig_mem_dout     )
              );

inst_buf inst_buf_blk(.reset       (reset           ),
                    .clk         (sig_mc_clk      ),
                      .ld          (sig_INST_LD    ),
                      .inst_buf_in (sig_mem_dout    ),
                      .inst_buf_out(sig_prom_data_in )
                      );
                                
clk_generator clk_generator_blk(.clk    (clk		 ),
                                	       .mc_clk (sig_mc_clk  ),
                                	       .mem_clk(sig_mem_clk)
                                	       );
                                
endmodule


module pipeline_mc(clk,reset,prom_data_in,mem_data_in,READ,WIRTE,INST_LD,IR_REG,prom_addr_out,mem_data_out);

	input reset             ;
	input clk               ;
	input [7:0] prom_data_in;
	input [7:0] mem_data_in ;

	output READ,WIRTE,INST_LD ;
	output [4:0] IR_REG       ;
	output [4:0] prom_addr_out ;
	output [7:0] mem_data_out ;

	wire sig_LD_MDR       ;
	wire sig_LD_IR        	;
	wire sig_LD_PC      	;
	wire sig_LD_ACC       ;
	wire sig_LD_FLAG      ;
	wire sig_INC          ;
	wire sig_ZERO         ;
	wire sig_READ         ;
	wire sig_WIRTE        ;
	wire sig_INST_LD      ;
	wire [2:0] sig_NSTATE ;
	wire [2:0] sig_PSTATE ;
	wire [7:0] sig_MDR_OUT;
	wire [7:0] sig_ALU_OUT;
	wire [7:0] sig_ACC_OUT;
	wire [7:0] sig_IR_REG ;
	wire [4:0] sig_prom_addr_out;   

	assign READ          = sig_READ         ;
	assign WIRTE         = sig_WIRTE        ;
	assign INST_LD       = sig_INST_LD      ;
	assign IR_REG        = sig_IR_REG[4:0]  ;
	assign prom_addr_out = sig_prom_addr_out;
	assign mem_data_out  = sig_ACC_OUT      ;

ir ir_blk(.reset (reset       ),
          .clk   (clk         ),
          .ld    (sig_LD_IR   ),
          .ir_in (prom_data_in),
          .ir_out(sig_IR_REG[7:0])
          );

mdr mdr_blk(.reset  (reset      ),
            .ld     (sig_LD_MDR ),
            .clk    (clk        ),
            .mdr_in (mem_data_in),
            .mdr_out(sig_MDR_OUT)
            );

acc acc_blk(.ld     (sig_LD_ACC ),
            .reset  (reset      ),
            .clk    (clk        ),
            .acc_in (sig_ALU_OUT),
            .acc_out(sig_ACC_OUT)
            );
            
alu alu_blk(.a      (sig_ACC_OUT    ),
            .b      (sig_MDR_OUT    ),
            .op     (sig_IR_REG[7:5]),
            .alu_out(sig_ALU_OUT    )
            );
            
state state_blk(.reset    (reset     ),
                .clk      (clk       ),
                .state_in (sig_NSTATE),
                .state_out(sig_PSTATE)
                );        

flag flag_blk(.reset  (reset      ),
              .ld     (sig_LD_FLAG),
              .clk    (clk        ),
              .alu_out(sig_ACC_OUT),
              .flag   (sig_ZERO   )
              );

pc pc_blk(.ld_pc (sig_LD_PC          ),
                      .inc_pc(sig_INC            ),
                      .reset (reset              ),
                      .clk   (clk                ),
                      .pc_in (sig_IR_REG[4:0]    ),
                      .pc_out(sig_prom_addr_out  )
                      );

control control_blk(.zero   (sig_ZERO       ),
                    .op     (sig_IR_REG[7:5]),
                    .pstate (sig_PSTATE     ),
                    .ld_mdr (sig_LD_MDR     ),
                    .ld_acc (sig_LD_ACC     ),
                    .ld_fla (sig_LD_FLAG    ),
                    .inst_ld(sig_INST_LD    ),
                    .ld_ir  (sig_LD_IR      ),
                    .ld_pc  (sig_LD_PC      ),
                    .inc    (sig_INC        ),
                    .rd     (sig_READ       ),
                    .wr     (sig_WIRTE      ),
                    .nstate (sig_NSTATE     )
                    );

endmodule

module pipeline_mc(clk,reset,prom_data_in,mem_data_in,READ,WIRTE,INST_LD,IR_REG,prom_addr_out,mem_data_out);

	input reset             ;
	input clk               ;
	input [7:0] prom_data_in;
	input [7:0] mem_data_in ;

	output READ,WIRTE,INST_LD ;
	output [4:0] IR_REG       ;
	output [4:0] prom_addr_out ;
	output [7:0] mem_data_out ;

	wire sig_LD_MDR       ;
	wire sig_LD_IR        	;
	wire sig_LD_PC      	;
	wire sig_LD_ACC       ;
	wire sig_LD_FLAG      ;
	wire sig_INC          ;
	wire sig_ZERO         ;
	wire sig_READ         ;
	wire sig_WIRTE        ;
	wire sig_INST_LD      ;
	wire [2:0] sig_NSTATE ;
	wire [2:0] sig_PSTATE ;
	wire [7:0] sig_MDR_OUT;
	wire [7:0] sig_ALU_OUT;
	wire [7:0] sig_ACC_OUT;
	wire [7:0] sig_IR_REG ;
	wire [4:0] sig_prom_addr_out;   

	assign READ          = sig_READ         ;
	assign WIRTE         = sig_WIRTE        ;
	assign INST_LD       = sig_INST_LD      ;
	assign IR_REG        = sig_IR_REG[4:0]  ;
	assign prom_addr_out = sig_prom_addr_out;
	assign mem_data_out  = sig_ACC_OUT      ;

ir ir_blk(.reset (reset       ),
          .clk   (clk         ),
          .ld    (sig_LD_IR   ),
          .ir_in (prom_data_in),
          .ir_out(sig_IR_REG[7:0])
          );

mdr mdr_blk(.reset  (reset      ),
            .ld     (sig_LD_MDR ),
            .clk    (clk        ),
            .mdr_in (mem_data_in),
            .mdr_out(sig_MDR_OUT)
            );

acc acc_blk(.ld     (sig_LD_ACC ),
            .reset  (reset      ),
            .clk    (clk        ),
            .acc_in (sig_ALU_OUT),
            .acc_out(sig_ACC_OUT)
            );
            
alu alu_blk(.a      (sig_ACC_OUT    ),
            .b      (sig_MDR_OUT    ),
            .op     (sig_IR_REG[7:5]),
            .alu_out(sig_ALU_OUT    )
            );
            
state state_blk(.reset    (reset     ),
                .clk      (clk       ),
                .state_in (sig_NSTATE),
                .state_out(sig_PSTATE)
                );        

flag flag_blk(.reset  (reset      ),
              .ld     (sig_LD_FLAG),
              .clk    (clk        ),
              .alu_out(sig_ACC_OUT),
              .flag   (sig_ZERO   )
              );

pc pc_blk(.ld_pc (sig_LD_PC          ),
                      .inc_pc(sig_INC            ),
                      .reset (reset              ),
                      .clk   (clk                ),
                      .pc_in (sig_IR_REG[4:0]    ),
                      .pc_out(sig_prom_addr_out  )
                      );

control control_blk(.zero   (sig_ZERO       ),
                    .op     (sig_IR_REG[7:5]),
                    .pstate (sig_PSTATE     ),
                    .ld_mdr (sig_LD_MDR     ),
                    .ld_acc (sig_LD_ACC     ),
                    .ld_fla (sig_LD_FLAG    ),
                    .inst_ld(sig_INST_LD    ),
                    .ld_ir  (sig_LD_IR      ),
                    .ld_pc  (sig_LD_PC      ),
                    .inc    (sig_INC        ),
                    .rd     (sig_READ       ),
                    .wr     (sig_WIRTE      ),
                    .nstate (sig_NSTATE     )
                    );

endmodule

module ir(
	input reset,
	input clk,
	input ld,
	input [7:0] ir_in,
	output reg [7:0] ir_out
	);


always@(posedge reset or posedge clk)
 if(reset)
	ir_out <= 8'b0;
 else
	if(ld)
		ir_out <= ir_in;
	else
		ir_out <= ir_out;

endmodule

module mdr(
	input reset,
	input ld,
	input clk,
	input [7:0] mdr_in,
	output reg [7:0] mdr_out
	);

always@(posedge reset or posedge clk) begin
 if(reset)
	mdr_out <= 8'b0;
 else
	if(ld)
		mdr_out <= mdr_in;
end

endmodule

module acc(
	input reset,
	input clk,
	input ld,
   input [7:0] acc_in,
	output reg [7:0] acc_out
);



always@(posedge clk or posedge reset) begin
	if(reset)
		acc_out <= 8'b0000_0000;
	else
		if(ld)
			acc_out <= acc_in;
end
 
endmodule

module alu(
	input [7:0] a,
	input [7:0] b,
	input [2:0] op,
	output reg [7:0] alu_out
	);

always@(a,b,op) begin
  case(op)
   3'b000 : alu_out = a   ;	
   3'b010 : alu_out = a+b ;
   3'b011 : alu_out = a&b ;
   3'b100 : alu_out = a^b ;
   3'b101 : alu_out = b   ;
   3'b110 : alu_out = a   ;
   default: alu_out = 8'b0;
  endcase
 end

endmodule

module state(reset,clk,state_in,state_out);

input reset           ;
input clk             ;
input [2:0] state_in  ;

output [2:0] state_out;

reg [2:0] state_out   ;

always@(posedge reset or posedge clk) begin
	if(reset)
   state_out <= 3'b111;
  else
   state_out <= state_in;	 
end

endmodule

module flag(
	input reset,
	input ld,
	input clk,
	input [7:0] alu_out,
	output reg flag
	);

always@(posedge reset or posedge clk) begin
	if(reset)
		flag = 0;
	else
		case(alu_out)
		8'b0000_0000 : if(ld == 1)
								flag = 1;
		default       : if(ld == 1)
								flag = 0;     
		endcase   
end

endmodule

module pc(
	input ld_pc,
	input inc_pc,
	input reset,
	input clk,
	input [4:0] pc_in,
	output reg [4:0] pc_out
	);

always@(posedge reset or posedge clk) begin
 if(reset)
	pc_out <= 5'b0;
 else
	if(ld_pc)
		pc_out <= pc_in;
	else if(inc_pc)
		pc_out <= pc_out+1;
end

endmodule

module control(zero,op,pstate,ld_mdr,ld_acc,ld_fla,inst_ld,ld_ir,ld_pc,inc,rd,wr,nstate);

	input zero;
	input [2:0] op,pstate;

	output ld_acc,ld_mdr,ld_ir,ld_fla,ld_pc,inc,inst_ld,rd,wr;
	output [2:0] nstate;

	reg ld_acc,ld_mdr,ld_ir,ld_fla,ld_pc,inc,inst_ld,rd,wr;
	reg [2:0] nstate;

always@* begin
//Initialize Control Signals
	rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
	ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
	inst_ld = 0; nstate = 000; ld_fla  = 0;

  case(pstate)
		//reset
		3'b111 : begin
			rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
			ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
			inst_ld = 0; nstate = 000; ld_fla  = 0;
		end
   
		// 0T: 1st instruction pre fetch, PC+1  					
		3'b000 : begin
			rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
			ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
			inst_ld = 1; nstate = 001; ld_fla  = 0;
		end
   				
		// 1T: 1 inst execute time
		3'b001 : begin  
			case(op) 
				3'b000 : begin  //HALT					--next T1
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
					inst_ld = 1; nstate = 001; ld_fla  = 0;
				end
				3'b001 : begin  	//SKIP-if-ZERO				--next T2
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 0;   inc     = 0;
					inst_ld = 0; nstate = 010; ld_fla  = 1;
				end
				3'b010 : begin 	 //ADD
					rd      = 1; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 1; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0; nstate = 010; ld_fla  = 0;
				end
				3'b011 : begin  	//AND
					rd      = 1; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 1; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0; nstate = 010; ld_fla  = 0;
				end
				3'b100 : begin  	//XOR
					rd      = 1; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 1; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0; nstate = 010; ld_fla  = 0;
				end	
				3'b101 : begin  	//LOAD
					rd      = 1; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 1; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0; nstate = 010; ld_fla  = 0;
				end
				3'b110 : begin 	 //STORE				--next T2
					rd      = 0; wr     = 1;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0; nstate = 010; ld_fla  = 0;
				end
				3'b111 : begin  //JUMP					--next T2
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 1;
					ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0; nstate = 010; ld_fla  = 0;
				end
				default : begin
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0; nstate = 000; ld_fla  = 0;
				end
			endcase
		end 				//end T1 op case
   
		3'b010 : begin 		//T2
			case(op)
				3'b001 : begin  		//SKIP-if-ZERO		--next T3 or T1
					rd      = 0; wr      = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_fla  = 0;
       
						if(zero == 1) begin	//if ACC is '0' then next T3 
							ld_ir = 0; inst_ld = 0; inc = 1; 
							nstate = 011;
						end
						else begin		//else then next T1
							ld_ir = 1; inst_ld = 1; inc = 1; 
							nstate = 001;
						end
	      
				end
				3'b111 : begin 	//JUMP					--next T3
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 1;
					ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
					inst_ld = 1; nstate = 011; ld_fla  = 0;
				end
				3'b010 : begin  //ADD
					rd      = 0; wr     = 0;   ld_acc  = 1; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
					inst_ld = 1; nstate = 001; ld_fla  = 0;
				end
				3'b011 : begin  //AND
					rd      = 0; wr     = 0;   ld_acc  = 1; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
					inst_ld = 1; nstate = 001; ld_fla  = 0;
				end
				3'b100 : begin  //XOR
					rd      = 0; wr     = 0;   ld_acc  = 1; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
					inst_ld = 1; nstate = 001; ld_fla  = 0;
				end
				3'b101 : begin  //LOAD
					rd      = 0; wr     = 0;   ld_acc  = 1; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
					inst_ld = 1; nstate = 001; ld_fla  = 0;
				end
				3'b110 : begin  //STORE				--next T1
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0; 
					ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
					inst_ld = 1;  nstate = 001; ld_fla  = 0;
				end
				default: begin
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0;  nstate = 000; ld_fla  = 0;
				end
			endcase
		end
   
		3'b011 : begin //T3
			case(op)
				3'b001 : begin  //SKIP-if-ZERO	--next T4
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
					inst_ld = 1; nstate = 100; ld_fla  = 0;
				end
				3'b111 : begin  //JUMP				--next T1
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
					inst_ld = 1; nstate = 001; ld_fla  = 0;
				end
				default: begin
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
					inst_ld = 0; nstate = 000; ld_fla  = 0;
				end
			endcase
		end
		3'b100 : begin //T3
			case(op)
				3'b001 : begin  //SKIP-if-ZERO	--next T1
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr  = 0; ld_ir  = 1;   inc     = 1; 
					inst_ld = 1; nstate = 001; ld_fla  = 0;
				end
				default : begin
					rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
					ld_mdr    = 0; ld_ir    = 0;   inc      = 0; 
					inst_ld    = 0; nstate   = 000;  ld_fla   = 0;
				end
			endcase
		end
		default : begin
     	  rd      = 0; wr     = 0;   ld_acc  = 0; ld_pc  = 0;
     	  ld_mdr  = 0; ld_ir  = 0;   inc     = 0; 
    	  inst_ld = 0; nstate = 000; ld_fla  = 0;
		end            	
	endcase			//end case 	
 end 				//end always
endmodule

module dataram(reset,clk,READ,WRITE,MEM_ADDR,MEM_DIN,MEM_DOUT);

	input reset           ;
	input clk             ;
	input READ,WRITE      ;
	input [4:0] MEM_ADDR  ;
	input [7:0] MEM_DIN ;

	output [7:0] MEM_DOUT;

	reg [7:0] MEM_DOUT;
                  
	reg [7:0] tmp   ;
	reg [7:0] one   ;
	reg [7:0] last_n;
	reg [7:0] n     ;
	reg [7:0] xn1   ;
	reg [7:0] xn    ;
	reg temp        ;

always@(posedge reset or posedge clk) begin
	 if(reset) begin
		MEM_DOUT  <= 8'b0;
		temp      <= 0;
	 end
	 else begin
	 	if(temp == 0)begin
			tmp    <= 8'b0       ;
			one    <= 8'b00000001;
			last_n <= 8'b00001010;
			n      <= 8'b00000000;
			xn1    <= 8'b00000001;
			xn     <= 8'b00000001;
			temp   <= 1;
		end
		if(READ)
				case(MEM_ADDR)
        			 5'b11010 : MEM_DOUT <= tmp        ;
       			 5'b11011 : MEM_DOUT <= one        ;
      			 5'b11100 : MEM_DOUT <= last_n     ;
       			 5'b11101 : MEM_DOUT <= n          ;
       			 5'b11110 : MEM_DOUT <= xn1        ;
       			 5'b11111 : MEM_DOUT <= xn         ;
       			 default  : MEM_DOUT <= 8'b00000000;
      		endcase
		else if(WRITE)
				case(MEM_ADDR)
					5'b11010 : tmp    <= MEM_DIN; 
					5'b11011 : one    <= MEM_DIN;
					5'b11100 : last_n <= MEM_DIN;
					5'b11101 : n      <= MEM_DIN;
					5'b11110 : xn1    <= MEM_DIN;
					5'b11111 : xn     <= MEM_DIN;
				endcase
		end
 end
     
endmodule

module prom(reset,clk,MEM_ADDR,MEM_DOUT);

	input reset           ;
	input clk             ;
	input [4:0] MEM_ADDR  ;

	output [7:0] MEM_DOUT;

	reg [7:0] MEM_DOUT   ;
                  
always@(posedge reset or posedge clk) begin
	 if(reset)
			MEM_DOUT <= 8'b0;
	 else
			case(MEM_ADDR)
				5'b00000 : MEM_DOUT <= 8'b10111111;
				5'b00001 : MEM_DOUT <= 8'b01011110;
				5'b00010 : MEM_DOUT <= 8'b11011010;
				5'b00011 : MEM_DOUT <= 8'b10111111;
				5'b00100 : MEM_DOUT <= 8'b11011110;
				5'b00101 : MEM_DOUT <= 8'b10111010;
				5'b00110 : MEM_DOUT <= 8'b11011111;
				5'b00111 : MEM_DOUT <= 8'b10111101;
				5'b01000 : MEM_DOUT <= 8'b01011011;
				5'b01001 : MEM_DOUT <= 8'b11011101;
				5'b01010 : MEM_DOUT <= 8'b10011100;
				5'b01011 : MEM_DOUT <= 8'b00100000;
				5'b01100 : MEM_DOUT <= 8'b11100000;
				5'b01101 : MEM_DOUT <= 8'b00000000;
				5'b11011 : MEM_DOUT <= 8'b00000000;
				5'b11100 : MEM_DOUT <= 8'b00000000;
				5'b11101 : MEM_DOUT <= 8'b00000000;
				5'b11110 : MEM_DOUT <= 8'b00000000;
				5'b11111 : MEM_DOUT <= 8'b00000000;
				default  : MEM_DOUT <= 8'b00000000;
         endcase
 end
endmodule

module inst_buf(reset,clk,ld,inst_buf_in,inst_buf_out);

	input reset            ;
	input clk              ;
	input ld               ;
	input [7:0] inst_buf_in;

	output [7:0] inst_buf_out;

	reg [7:0] inst_buf_out;
	//reg [7:0] tmp;
	//assign inst_buf_out = tmp;

always@(posedge reset or posedge clk) begin
	if(reset)
	 //tmp <= 8'b0;
	 inst_buf_out <= 8'b0;
	else
	 if(ld) begin
	  //tmp <= inst_buf_in;
	  inst_buf_out <= inst_buf_in;
	end
end

endmodule

module clk_generator(clk,mc_clk,mem_clk);

	input clk;

	output mc_clk,mem_clk;

	reg mc_clk,mem_clk;

always@(*) begin
 mc_clk = clk;
 mem_clk = ~clk;
end

endmodule

