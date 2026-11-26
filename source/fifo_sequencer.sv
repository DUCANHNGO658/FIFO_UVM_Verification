`ifndef FIFO_SEQUENCER_SV
`define FIFO_SEQUENCER_SV

`include "fifo_seq_item.sv"
`include "uvm_macros.svh"

package FIFO_sequencer_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;

class FIFO_sequencer extends uvm_sequencer#(FIFO_seq_item);
`uvm_component_utils(FIFO_sequencer)
    function new(string name="FIFO_sequencer",uvm_component parent = null);
        super.new(name);
    endfunction
endclass
endpackage
`endif