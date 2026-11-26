`ifndef FIFO_SVA_SV
`define FIFO_SVA_SV
`include "fifo_if.sv"

module FIFO_sva(
    FIFO_if.DUT FIFOif
);

property write_ptr;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (FIFOif.wr_en && dut.count != FIFOif.FIFO_DEPTH)|=>($past(dut.wr_ptr)+1'b1 == dut.wr_ptr);
endproperty

property read_ptr;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (FIFOif.rd_en && dut.count!= 0) |=>($past(dut.rd_ptr)+1'b1 == dut.rd_ptr);
endproperty

property write_count;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (!FIFOif.rd_en && FIFOif.wr_en && dut.count!=FIFOif.FIFO_DEPTH) |=>($past(dut.count)+1 == dut.count);
endproperty

property read_count;
    @(posedge FIFOif.clk) disable iff(!FIFOif.rst_n)
    (FIFOif.rd_en && !FIFOif.wr_en && dut.count!=0)|=> ($past(dut.count)-1'b1==dut.count);
endproperty

property read_write_count;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
(FIFOif.rd_en && FIFOif.wr_en && dut.count != 0 && dut.count != FIFOif.FIFO_DEPTH) |=> ($past(dut.count) == dut.count);
endproperty

property overflow_p;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n) (dut.count == FIFOif.FIFO_DEPTH && FIFOif.wr_en) |=> (FIFOif.overflow);
  endproperty

  property wr_ack_p;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n) (dut.count != FIFOif.FIFO_DEPTH && FIFOif.wr_en) |=> (FIFOif.wr_ack);
  endproperty

wr_ptr_assert: assert property (write_ptr)
else $error("Assertion failed: wr_ptr did not increament properly!");

rd_ptr_assert: assert property (read_ptr)
    else $error("Assertion failed: rd_ptr did not increment properly!");

  wr_count_assert: assert property (write_count)
    else $error("Assertion failed: count did not increment on write!");

  rd_count_assert: assert property (read_count)
    else $error("Assertion failed: count did not decrement on read!");

  rd_wr_count_assert: assert property (read_write_count)
    else $error("Assertion failed: count should remain constant on simultaneous R/W!");

     overflow_assert: assert property (overflow_p)
    else $error("Assertion failed: overflow did not assert properly!");

  wr_ack_assert: assert property (wr_ack_p)
    else $error("Assertion failed: wr_ack did not assert properly!");

    wr_ptr_cover: cover property (write_ptr);
    rd_ptr_cover: cover property (read_ptr);
    wr_count_cover: cover property (write_count);
    rd_count_cover: cover property (read_count);
    rd_wr_count_cover: cover property (read_write_count);
  overflow_cover: cover property (overflow_p);
  wr_ack_cover:   cover property (wr_ack_p);
always_comb begin
    if(!FIFOif.rst_n) begin
        rst_count_assert: assert final (dut.count ==0);
        rst_wr_ptr_assert: assert final (dut.wr_ptr==0);
        rst_rd_ptr_assert: assert final (dut.rd_ptr==0);
    end
    if(dut.count == FIFOif.FIFO_DEPTH) begin
        full_assert: assert final(FIFOif.full);
    end

    if(dut.count==0) begin
        empty_assert: assert final(FIFOif.empty);
    end

    if(dut.count ==0 && FIFOif.rd_en) begin
        underflow_assert: assert final (FIFOif.underflow);
    end


    if(dut.count == FIFOif.FIFO_DEPTH-1) begin
        almostfull_assert: assert final(FIFOif.almostfull);
    end

    if(dut.count== 1) begin
        almostempty_assert: assert final(FIFOif.almostempty);
    end

end
endmodule

`endif