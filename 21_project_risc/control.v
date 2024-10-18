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
