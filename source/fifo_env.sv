`ifndef FIFO_ENV_SV
`define FIFO_ENV_SV

`include "uvm_macros.svh"
`include "fifo_subscriber.sv"
`include "fifo_scoreboard.sv"
`include "fifo_agent.sv"

package FIFO_env_pkg;
import uvm_pkg::*;
import FIFO_agent_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_subscriber_pkg::*;

class FIFO_env extends uvm_env;
    `uvm_component_utils(FIFO_env)
FIFO_agent env_agent;
FIFO_scoreboard env_scoreboard;
FIFO_subscriber env_subscriber;

    function new(string name = "FIFO_env",uvm_component parent = null);
        super.new(name,parent);
    endfunction

  virtual  function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_agent = FIFO_agent::type_id::create("env_agent",this);
        env_scoreboard = FIFO_scoreboard::type_id::create("env_scoreboard",this);
        env_subscriber = FIFO_subscriber::type_id::create("env_subscriber",this);
    endfunction

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    env_agent.agent_ap.connect(env_scoreboard.sb_export);
    env_agent.agent_ap.connect(env_subscriber.analysis_export);
endfunction
endclass
endpackage
`endif