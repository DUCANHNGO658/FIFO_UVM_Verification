`include "uvm_pkg_all_v2020_3_2_nodpi.svh"
`include "fifo_if.sv"
package FIFO_config_obj_pkg;
import uvm_pkg::*;


class FIFO_config_obj extends uvm_object;
`uvm_object_utils(FIFO_config_obj)

virtual FIFO_if FIFO_config_vif;
function new(string name ="FIFO_config_obj");
super.new(name);
endfunction
endclass
endpackage