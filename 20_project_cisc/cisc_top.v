module cisc_top(
	input reset, 
	input clk, 
	output [7:0] mc_out, 
	output [7:0] mem_out, 
	output m_clk, 
	output read, 
	output write, 
	output [4:0] mem_addr
	);
                                   
wire sig_read              ;
wire sig_write             ;
wire [4:0]sig_mem_addr     ;
wire sig_mc_en             ;
wire [7:0]sig_mem_data_out ;
wire [7:0]sig_mem_data2    ;
wire [7:0]sig_mem_data1    ;
wire [7:0]sig_mem_data_in  ;
wire sig_M_clk             ;
wire sig_P_clk             ;

assign mc_out  = sig_mem_data_in  ;
assign mem_out = sig_mem_data_out ;
assign mem_addr= sig_mem_addr;
assign m_clk   = sig_M_clk   ;
assign read    = sig_read    ;
assign write   = sig_write   ;

memory  MEM_BLK(
    .reset    (reset        ),
    .clk      (sig_M_clk    ),
    .READ     (sig_read     ),
    .WRITE    (sig_write    ),
    .MEM_ADDR (sig_mem_addr ),
    .MEM_DATA1(sig_mem_data1),
    .MEM_DATA2(sig_mem_data2)
);

bi_direction_core BUS_BLK(
    .mc_en     (sig_mc_en        ),
    .read      (sig_read         ),
    .mc_in     (sig_mem_data_out ),
    .mem_data2 (sig_mem_data2    ),
    .mem_data1 (sig_mem_data1    ),
    .mc_out    (sig_mem_data_in  )
);

clk_generator   CLK_BLK(
    .clk       (clk  ),
    .M_clk     (sig_M_clk),
    .P_clk     (sig_P_clk)
);

mcu  COR_BLK(
    .reset       (reset           ),
    .clk         (sig_P_clk       ),
    .mem_data_in (sig_mem_data_in ),
    .READ        (sig_read        ),
    .WRITE       (sig_write       ),
    .MEM_ADDR    (sig_mem_addr    ),
    .MEM_DATA_OUT(sig_mem_data_out),
    .LD_IR_OUT   ( ),
    .LD_ACC_OUT  ( ),
    .DOUT_EN_OUT (sig_mc_en       ),
    .LD_MDR_OUT  ( ),
    .LD_PC_OUT   ( ),
    .INC_OUT     ( ),
    .SEL_OUT     ( ),
    .FLAG_OUT    ( ),
    .IR_OUT_OUT  ( ),
    .OP_OUT      ( ),
    .ALU_OUT_OUT ( )
); 


endmodule