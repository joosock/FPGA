module synch_fifo(
   Reset, Clk, Rd, Wr, Full, Empty, Din, Dout,
   Addr, WData, RData, nCS, nOE, nWE
);

parameter ADDR_SIZE = 6;
parameter DATA_SIZE = 16;

//system
input Reset;
input Clk;
//interface
input Rd;
input Wr;
input  [DATA_SIZE-1:0] Din;
output [DATA_SIZE-1:0] Dout;
//sram
output [ADDR_SIZE-1:0] Addr;
output [DATA_SIZE-1:0] WData;
input  [DATA_SIZE-1:0] RData;
output nCS;
output nOE;
output nWE;
//log
output Full;
output Empty;

// write address counter
reg [ADDR_SIZE:0] write_addr;
always @(posedge Clk) begin
   if (Reset) begin
      write_addr <= 0;
   end else begin
      if (Wr) write_addr <= write_addr+1;
   end
end

// read address counter
reg [ADDR_SIZE:0] read_addr;
always @(posedge Clk) begin
   if (Reset) begin
      read_addr <= 0;
   end else begin
      if (Rd) read_addr <= read_addr+1;
   end
end

reg Full;
reg Empty;
always @(write_addr or read_addr) begin
   if (~|(write_addr[ADDR_SIZE-1:0]^read_addr[ADDR_SIZE-1:0])) begin
      if (~|(write_addr[ADDR_SIZE]^read_addr[ADDR_SIZE])) begin
         Empty <= 1'b1;
         Full <= 1'b0;
      end else begin
         Empty <= 1'b0;
         Full <= 1'b1;
      end
   end else begin
      Empty <= 1'b0;
      Full <= 1'b0;
   end
end

wire wFull;
wire wEmpty;
assign wFull = write_addr[ADDR_SIZE-1:0]==read_addr[ADDR_SIZE-1:0] ? 
	       write_addr[ADDR_SIZE]==read_addr[ADDR_SIZE] ? 0 : 1 : 0;

assign wEmpty= write_addr[ADDR_SIZE-1:0]==read_addr[ADDR_SIZE-1:0] ? 
	       write_addr[ADDR_SIZE]==read_addr[ADDR_SIZE] ? 1 : 0 : 0;

assign nCS = ~(Wr | Rd);
assign nOE = ~(Rd);
assign nWE = ~(Wr);
assign Addr = Wr ? write_addr[ADDR_SIZE-1:0] : read_addr[ADDR_SIZE-1:0];

assign WData = Wr ? Din : 16'bz;
assign Dout = Rd ? RData : 16'bz;

endmodule

