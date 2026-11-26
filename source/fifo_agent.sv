`ifndef FIFO_AGENT_SV
`define FIFO_AGENT_SV

`include "uvm_macros.svh"
`include "fifo_seq_item.sv"
`include "fifo_sequencer.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_config_obj.sv"

package FIFO_agent_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
import FIFO_monitor_pkg::*;
import FIFO_driver_pkg::*;
import FIFO_sequencer_pkg::*;
import FIFO_config_obj_pkg::*;

class FIFO_agent extends uvm_agent;
    `uvm_component_utils(FIFO_agent)
    function new(string name = "FIFO_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    FIFO_driver agent_drv;
    FIFO_monitor agent_mon;
    FIFO_sequencer agent_seq;
    FIFO_config_obj agent_config_obj;
    uvm_analysis_port#(FIFO_seq_item) agent_ap;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(FIFO_config_obj)::get(this,"","config_agent",agent_config_obj))
        `uvm_fatal("build_phase","Unable to get configuration object")

        //Build sequencer and driver only when FIFO_agent is active
        if(get_is_active()==UVM_ACTIVE) begin
            agent_seq = FIFO_sequencer::type_id::create("agent_seq",this);
            agent_drv = FIFO_driver::type_id::create("agent_drv",this);
        end
//Always build monitor and coverage no mater what
        agent_mon = FIFO_monitor::type_id::create("agent_mon",this);
        agent_ap = new("agent_ap",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active()==UVM_ACTIVE) begin
            //assign virtual interface for the driver
            agent_drv.FIFO_driver_vif = agent_config_obj.FIFO_object_vif;
            //Connect between driver and sequencer
            agent_drv.seq_item_port.connect(agent_seq.seq_item_export);
        end
//Assign virtual interface for monitor
        agent_mon.FIFO_monitor_vif = agent_config_obj.FIFO_object_vif;
//Assign analysis port of mon to agent
        agent_mon.mon_ap.connect(agent_ap);
    endfunction
endclass
endpackage
`endif
