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
