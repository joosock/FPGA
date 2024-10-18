module fifo_sram(
    resetn,
    clk  ,
    rd   ,
    wr   ,
    din  ,
    dout
);

input resetn;
input clk   ;
input rd    ;
input wr    ;
input  [DATA_SIZE-1:0] din;
output [DATA_SIZE-1:0] dout;

parameter ADDR_SIZE = 6;
parameter DATA_SIZE = 16;

wire [ADDR_SIZE-1:0] w_addr;
wire [DATA_SIZE-1:0] w_wdata;
wire [DATA_SIZE-1:0] w_rdata;
wire                 w_ncs;
wire                 w_noe;
wire                 w_nwe;

synch_fifo U_SYNCH_FIFO (
   .Reset (~resetn), 
   .Clk   (clk), 
   .Rd    (rd ), 
   .Wr    (wr ), 
   .Full  (full  ), 
   .Empty (empty ), 
   .Din   (din ), 
   .Dout  (dout),
   .Addr  (w_addr), 
   .WData (w_wdata), 
   .RData (w_rdata), 
   .nCS   (w_ncs),  
   .nOE   (w_noe), 
   .nWE   (w_nwe) 
);
blk_mem_ss1 U_SRAM(
   .clka (clk   ),
   .ena  (~w_ncs),    
   .wea  (~w_nwe),  
   .addra(w_addr),  
   .dina (w_wdata), 
   .douta(w_rdata)  
);


endmodule

