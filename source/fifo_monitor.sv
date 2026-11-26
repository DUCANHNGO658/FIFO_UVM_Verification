`ifndef FIFO_MONITOR_SV
`define FIFO_MONITOR_SV

`include "uvm_macros.svh"
`include "fifo_seq_item.sv"
`include "fifo_if.sv"

package FIFO_monitor_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
class FIFO_monitor extends uvm_monitor;
    `uvm_component_utils(FIFO_monitor)
    virtual FIFO_if FIFO_monitor_vif;
    uvm_analysis_port #(FIFO_seq_item) mon_ap;

    function new(string name = "FIFO_monitor", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap",this);
    endfunction

    FIFO_seq_item sim_seq_item;

task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin
    @(negedge FIFO_monitor_vif.clk);
    if(!FIFO_monitor_vif.rst_n || FIFO_monitor_vif.wr_en||FIFO_monitor_vif.rd_en) begin
    sim_seq_item = FIFO_seq_item::type_id::create("sim_seq_item");
    sim_seq_item.rst_n = FIFO_monitor_vif.rst_n;
    sim_seq_item.wr_en = FIFO_monitor_vif.wr_en;
    sim_seq_item.rd_en = FIFO_monitor_vif.rd_en;
    sim_seq_item.data_in = FIFO_monitor_vif.data_in;
    sim_seq_item.data_out=FIFO_monitor_vif.data_out;
    sim_seq_item.wr_ack = FIFO_monitor_vif.wr_ack;
    sim_seq_item.full = FIFO_monitor_vif.full;
    sim_seq_item.almostfull = FIFO_monitor_vif.almostfull;
    sim_seq_item.empty = FIFO_monitor_vif.empty;
    sim_seq_item.almostempty=FIFO_monitor_vif.almostempty;
    sim_seq_item.overflow = FIFO_monitor_vif.overflow;
    sim_seq_item.underflow=FIFO_monitor_vif.underflow;
    mon_ap.write(sim_seq_item);
    `uvm_info("run_phase",sim_seq_item.convert2string_stimulus(),UVM_HIGH)
    end
end
endtask
endclass
endpackage
`endif