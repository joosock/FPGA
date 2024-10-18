module tb_fifo;
  reg         wr, rd;
  reg  [15:0] din;
  wire [15:0] dout;
  reg clk;
  reg rstn;
  reg [15:0] lat_wdata;
  reg [15:0] lat_rdata;
  reg        lat_wr   ;
  reg        lat_rd   ;
  reg  [15:0] t_data  ;

  initial begin
      #0; clk=0;
      forever begin
          #50 clk = ~clk;
      end
  end
  always@(posedge clk, negedge rstn) begin
      if(!rstn) begin
         lat_wdata <= 0;
         lat_rdata <= 0;
         lat_wr    <= 0;
         lat_rd    <= 0;
      end
      else begin
         lat_wdata <= din;
         lat_rdata <= dout;
         lat_wr    <= wr;
         lat_rd    <= rd;
      end
  end
  
  initial begin
      #0;  rstn=0; din=0; wr=0; rd=0; 
      #410; rstn=1;
      t_data=0;
      #1000; wr_data(16'haa55);
      #1000; wr_data(16'hff00);
      #1000; rd_data;
      #1000; rd_data;
      repeat(32) begin
          #1000; wr_data(t_data);
	  t_data=t_data+1;
      end
      #1000; rd_data;
      #1000; rd_data;
      #1000; rd_data;
      t_data=0;
      repeat(40) begin
          #1000; wr_data(t_data);
	  t_data=t_data+1;
      end
      repeat(80) begin
          #1000; rd_data;
      end
      //wr:32+40, rd:3+80
  end
fifo_sram U_FIFO(
    .resetn(rstn),
    .clk   (clk),
    .rd    (lat_rd),
    .wr    (lat_wr),
    .din   (lat_wdata),
    .dout  (dout) 
);

task wr_data;
input [15:0] data;

begin
    #10; wr=0; din=0;
    @(posedge clk) begin
        wr = 1;
        din = data;
    end
    @(posedge clk) begin
        wr = 0;
        din = 0;
    end
        $display("write data[%x]",data);
    #10; wr=0;
end
endtask
      
task rd_data;

begin
    #10; rd=0;
    @(posedge clk) begin
        rd = 1;
    end
    @(negedge clk) begin
        $display("read data[%x]",dout);
    end
    @(posedge clk) begin
        rd = 0;
    end
    #10;
end
endtask
  endmodule


