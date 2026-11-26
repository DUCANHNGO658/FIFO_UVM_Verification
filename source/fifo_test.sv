`ifndef FIFO_TEST_SV
`define FIFO_TEST_SV
`include "uvm_macros.svh"
`include "fifo_env.sv"
`include "fifo_config_obj.sv"
`include "fifo_sequence.sv"

package FIFO_test_pkg;
import uvm_pkg::*;
import FIFO_env_pkg::*;
import FIFO_config_obj_pkg::*;
import FIFO_sequence_pkg::*;

class FIFO_test extends uvm_test;
    `uvm_component_utils(FIFO_test)

FIFO_config_obj test_config_obj;
FIFO_env test_env;
FIFO_reset_sequence test_reset;
FIFO_write_only_sequence test_write_only;
FIFO_read_only_sequence test_read_only;
FIFO_read_write_sequence test_read_write;

function new(string name = "FIFO_test",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    test_config_obj = FIFO_config_obj::type_id::create("test_config_obj");
    test_env = FIFO_env::type_id::create("test_env",this);
    test_reset = FIFO_reset_sequence::type_id::create("test_reset");
    test_write_only = FIFO_write_only_sequence::type_id::create("test_write_only");
    test_read_only = FIFO_read_only_sequence::type_id::create("test_read_only");
    test_read_write = FIFO_read_write_sequence::type_id::create("test_read_write");

    if(!uvm_config_db#(virtual FIFO_if)::get(this,"","FIFO_IF",test_config_obj.FIFO_object_vif))
    `uvm_fatal("Build phase"," test unable to get virtual interface from the uvm_config_db");

    uvm_config_db #(FIFO_config_obj)::set(this,"*","config_agent",test_config_obj);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    //Reset
    `uvm_info("Run_phase: ","Reset asserted",UVM_LOW)
    test_reset.start(test_env.env_agent.agent_seq);
    `uvm_info("Run phase: ","Reset deasserted", UVM_LOW)

    //Write only
    `uvm_info("Run_phase: ","Write only asserted",UVM_LOW)
    test_write_only.start(test_env.env_agent.agent_seq);
     `uvm_info("Run_phase: ", "Write only deasserted", UVM_LOW)

     
    //Read only
    `uvm_info("Run_phase: ", "Read only asserted", UVM_LOW);
    test_read_only.start(test_env.env_agent.agent_seq);
    `uvm_info("Run_phase: ", "Read only deasserted", UVM_LOW);
    
    //Read & Write
    `uvm_info("Run_phase: ", "Read & Write asserted", UVM_LOW);
    test_read_write.start(test_env.env_agent.agent_seq);
    `uvm_info("Run_phase: ", "Read & Write deasserted", UVM_LOW);
    phase.drop_objection(this);
endtask
endclass
endpackage
`endif


