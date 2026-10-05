`include "uvm_pkg_all_v2020_3_2_nodpi.svh"
import uvm_pkg::*;

package FIFO_sequencer_pkg;
import FIFO_seq_item_pkg::*;

class FIFO_sequencer extends uvm_sequencer #(FIFO_seq_item);
`uvm_component_utils(FIFO_sequencer)

function new (string name = "FIFO_sequencer", uvm_component parent);
super.new(name,parent);
endfunction

endclass
endpackage