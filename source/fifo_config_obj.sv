`ifndef FIFO_CONFIG_SV
`define FIFO_CONFIG_SV
`include "uvm_macros.svh"

package FIFO_config_obj_pkg;
import uvm_pkg::*;

class FIFO_config_obj extends uvm_object;
    `uvm_object_utils(FIFO_config_obj)
virtual FIFO_if FIFO_object_vif;
function new(string name ="FIFO_config_obj");
    super.new(name);
endfunction
endclass
endpackage


`endif