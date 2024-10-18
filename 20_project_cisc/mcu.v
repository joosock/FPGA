module mcu(
	input reset,
	input clk,
	input [7:0] mem_data_in,
	output READ,
	output WRITE,
	output LD_IR_OUT,
	output LD_ACC_OUT,
	output DOUT_EN_OUT,
	output LD_MDR_OUT,
	output LD_PC_OUT,
	output INC_OUT,
	output SEL_OUT,
	output FLAG_OUT,
	output [7:0] IR_OUT_OUT,
	output [2:0] OP_OUT,
	output [7:0] ALU_OUT_OUT,
	output [4:0] MEM_ADDR,
	output [7:0] MEM_DATA_OUT  );

/*
wire clk                  ;          
wire reset                ;*/

wire [2:0] sig_state_out   ;

wire sig_ld_mdr           ;
wire sig_ld_acc           ;
wire sig_ld_ir            ;
wire sig_dout_en          ;
wire sig_ld_pc            ;
wire sig_inc              ;
wire sig_sel              ;
wire sig_rd               ;
wire sig_wr               ;
wire [2:0] sig_nstate      ;
                          
wire [7:0] sig_alu_out     ;
wire sig_flag             ;

wire [4:0] sig_pc_out      ;
wire [4:0] sig_mem_addr    ;
          
wire [7:0] sig_acc_out     ;           
wire [7:0] sig_ir_in       ;    
wire [7:0] sig_mdr_out     ;
wire [7:0] sig_mem_data_out;


//Instruction Bus : IR reg
wire [7:0] sig_ir_reg;

assign READ        = sig_rd          ;
assign WRITE       = sig_wr          ;
assign LD_MDR_OUT  = sig_ld_mdr      ;
assign LD_IR_OUT   = sig_ld_ir       ;
assign LD_ACC_OUT  = sig_ld_acc      ;
assign DOUT_EN_OUT = sig_dout_en     ;
assign LD_PC_OUT   = sig_ld_pc       ;
assign INC_OUT     = sig_inc         ;
assign SEL_OUT     = sig_sel         ;
assign FLAG_OUT    = sig_flag        ;
assign ALU_OUT_OUT = sig_alu_out     ;
assign IR_OUT_OUT  = sig_ir_reg      ;
assign OP_OUT      = sig_ir_reg[7:5] ;
assign MEM_ADDR    = sig_mem_addr    ;
assign MEM_DATA_OUT= sig_mem_data_out;

//state 
state state_reg(.clk       (clk          ), 
                .reset     (reset        ), 
                .state_out (sig_state_out), 
                .state_in  (sig_nstate   )
);

//CON_LOG 
control control_blk(
                .zero      (sig_flag        ),
                .op        (sig_ir_reg[7:5] ),
                .pstate    (sig_state_out   ),
                .ld_mdr    (sig_ld_mdr      ),
                .ld_acc    (sig_ld_acc      ),
                .ld_ir     (sig_ld_ir       ),
                .dout_en   (sig_dout_en     ),
                .ld_pc     (sig_ld_pc       ),
                .inc       (sig_inc         ),
                .sel       (sig_sel         ),
                .rd        (sig_rd          ),
                .wr        (sig_wr          ),
                .nstate    (sig_nstate      )
);

//flag 
flag flag_blk(.reset       (reset      ), 
              .ld          (sig_ld_acc ),
              .clk         (clk        ),
              .alu_out     (sig_alu_out),
              .flag        (sig_flag   )
);

//program counter
pc pc_blk(.ld_pc   (sig_ld_pc      ),
                      .inc_pc  (sig_inc        ),
                      .reset   (reset          ),
                      .clk     (clk            ),
                      .pc_in   (sig_ir_reg[4:0]),
                      .pc_out  (sig_pc_out     )
);

//addr_mux 
addr_mux addr_mux_blk(.a      (sig_ir_reg[4:0]),
                        .b      (sig_pc_out     ),
                        .sel    (sig_sel        ),
                        .mux_out(sig_mem_addr   )
);

//ir
ir ir_blk(.reset (reset          ),
          .clk   (clk            ),
          .ld    (sig_ld_ir      ),
          .ir_in (sig_ir_in      ),
          .ir_out(sig_ir_reg[7:0])
);

//mdr 
mdr mdr_blk(.reset    (reset      ),
            .ld       (sig_ld_mdr ),
            .clk      (clk        ),
            .mdr_in   (sig_ir_in  ),
            .mdr_out  (sig_mdr_out)
);

//acc
acc acc_blk1(.ld    (sig_ld_acc ),
            .reset  (reset      ),
            .clk    (clk        ),
            .acc_in (sig_alu_out),
            .acc_out(sig_acc_out)
);

//alu
alu alu_blk(.a      (sig_acc_out    ),
            .b      (sig_mdr_out    ),
            .op     (sig_ir_reg[7:5]),
            .alu_out(sig_alu_out    )
);

//bi_buf
bi_buf bi_buf_blk(.en     (sig_dout_en ),
                  .buf_in (sig_acc_out ),
                  .buf_out(sig_ir_in   ),
                  .d_in   (mem_data_in ),
                  .d_out  (sig_mem_data_out)
);


endmodule