`include "uvm_pkg_all_v2020_3_2_nodpi.svh"
`include "fifo_seq_item.sv"
`include "fifo_sequencer.sv"
`include "fifo_config_obj.sv"

package FIFO_driver_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
import FIFO_sequencer_pkg::*;
import FIFO_config_obj_pkg::*;
class FIFO_driver extends uvm_driver #(FIFO_seq_item);

`uvm_component_utils(FIFO_driver)
virtual FIFO_if FIFO_driver_vif;
FIFO_seq_item sim_seq_item;

function new(string name = "FIFO_driver", uvm_component parent = null);
super.new(name,parent);
endfunction     

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

virtual task run_phase (uvm_phase phase);
super.run_phase(phase);
forever begin
    sim_seq_item = FIFO_seq_item::type_id::create("sim_seq_item");

    //Receive item from sequencer
    seq_item_port.get_next_item(sim_seq_item);

    //Driver signal to interface
    FIFO_driver_vif.rst_n <= sim_seq_item.rst_n;
    FIFO_driver_vif.data_in <=sim_seq_item.data_in;
    FIFO_driver_vif.wr_en <= sim_seq_item.wr_en;
    FIFO_driver_vif.rd_en <= sim_seq_item.rd_en;
 
    //Wait 1 cycle to drive signal to DUT
    @(posedge FIFO_driver_vif.clk);
    
    seq_item_port.item_done();
end
endtask
endclass
endpackage