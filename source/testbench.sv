`include "uvm_macros.svh"
`include "fifo_if.sv"
`include "fifo_seq_item.sv"
`include "fifo_sequencer.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_config_obj.sv"
`include "fifo_scoreboard.sv"
`include "fifo_subscriber.sv"
`include "fifo_agent.sv"
`include "fifo_env.sv"
`include "fifo_sequence.sv"
`include "fifo_test.sv"
`include "fifo_sva.sv"

import uvm_pkg::*;
import FIFO_test_pkg::*;

module FIFO_top;

  bit clk;
  always #5 clk = ~clk;

  FIFO_if FIFOif (clk);

  FIFO dut (FIFOif);

  bind FIFO FIFO_sva assert_inst (FIFOif);

  initial begin
    clk = 0;
    uvm_config_db #(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF", FIFOif);
    
    run_test("FIFO_test");
  end

endmodule