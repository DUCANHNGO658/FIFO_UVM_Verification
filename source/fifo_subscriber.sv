`ifndef FIFO_SUBSCRIBER_SV
`define FIFO_SUBSCRIBER_SV
`include "uvm_macros.svh"
`include "fifo_monitor.sv"
`include "fifo_seq_item.sv"

package FIFO_subscriber_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
import FIFO_monitor_pkg::*;

class FIFO_subscriber extends uvm_subscriber #(FIFO_seq_item);
    `uvm_component_utils(FIFO_subscriber)
    
    FIFO_seq_item seq_item_cov;

    covergroup cf_FIFO;
        cp_wr_en: coverpoint seq_item_cov.wr_en;
        cp_rd_en: coverpoint seq_item_cov.rd_en;
        cp_wr_ack: coverpoint seq_item_cov.wr_ack;
        cp_full: coverpoint seq_item_cov.full;
        cp_empty: coverpoint seq_item_cov.empty;
        cp_almostfull: coverpoint seq_item_cov.almostfull;
        cp_almostempty: coverpoint seq_item_cov.almostempty;
        cp_overflow: coverpoint  seq_item_cov.overflow;
        cp_underflow: coverpoint  seq_item_cov.underflow;

//Cross coverage
//Write ack
        cx_wr_ack: cross cp_wr_en, cp_rd_en, cp_wr_ack{
            ignore_bins ack_com_0 = binsof(cp_wr_en) intersect{0} 
            && binsof(cp_rd_en) intersect{0} 
            && binsof(cp_wr_ack) intersect{1};
            ignore_bins ack_com_1 = binsof(cp_wr_en) intersect{0} 
            && binsof(cp_rd_en) intersect{1} 
            && binsof(cp_wr_ack) intersect{1};
            ignore_bins ack_com_2 = binsof(cp_wr_en) intersect {1} 
            && binsof(cp_rd_en) intersect{1} 
            && binsof(cp_wr_ack) intersect{0};
        }

//Overflow
        cx_overflow: cross cp_wr_en, cp_rd_en, cp_overflow{
            ignore_bins overflow_com_0 = binsof(cp_wr_en) intersect{0} 
            &&binsof(cp_rd_en) intersect{0} 
            && binsof(cp_overflow) intersect{1};
            ignore_bins overflow_com_1 = binsof(cp_wr_en) intersect {0}
            && binsof(cp_rd_en) intersect {1}
            && binsof(cp_overflow) intersect {1};
            ignore_bins overflow_com_2 = binsof (cp_wr_en) intersect{1}
            && binsof (cp_rd_en) intersect {1}
            && binsof (cp_overflow) intersect {1};
        }
//Underflow
        cx_underflow: cross cp_wr_en, cp_rd_en, cp_underflow{
            ignore_bins underflow_com_0 = binsof(cp_wr_en) intersect{0} 
            && binsof (cp_rd_en) intersect {0}
            && binsof (cp_underflow) intersect {1};
            ignore_bins underflow_com_1 = binsof(cp_wr_en) intersect {1}
            && binsof(cp_rd_en) intersect {0}
            && binsof(cp_underflow) intersect {1};
        }
//Full
        cx_full: cross cp_wr_en, cp_rd_en, cp_full{
            ignore_bins full_com_1 = binsof(cp_wr_en) intersect{0} 
            && binsof(cp_rd_en) intersect {0}
            && binsof(cp_full) intersect{1};
            ignore_bins full_com_2 = binsof(cp_wr_en) intersect{1}
            && binsof(cp_rd_en) intersect {1}
            && binsof(cp_full) intersect{1};
        }
   cx_empty: cross cp_wr_en, cp_rd_en, cp_empty{
            ignore_bins empty_0 = binsof(cp_wr_en) intersect {0} 
            && binsof(cp_rd_en) intersect {0} 
            && binsof(cp_empty) intersect {0};
            ignore_bins empty_1 = binsof(cp_wr_en) intersect{1}
            && binsof(cp_rd_en) intersect {0}
            && binsof (cp_empty) intersect {1};
        }
        cx_almostfull: cross cp_wr_en, cp_rd_en, cp_almostfull{
            ignore_bins almostfull_0 = binsof(cp_wr_en) intersect {0}
            && binsof(cp_rd_en) intersect{0}
            && binsof(cp_almostfull) intersect{1};
        }
        cx_almostempty: cross cp_wr_en, cp_rd_en, cp_almostempty{
            ignore_bins almostempty_0 = binsof(cp_wr_en) intersect{0} 
            && binsof(cp_rd_en) intersect{0}
            && binsof(cp_almostempty) intersect{1};
        }

    endgroup
    
    function new(string name ="FIFO_coverage",uvm_component parent = null);
        super.new(name,parent);
        cf_FIFO = new();
    endfunction

    //Callback write for uvm_subscriber
    //Auto receive from mon_ap send from monitor
    virtual function void write(FIFO_seq_item t);
        seq_item_cov = t;
        cf_FIFO.sample();
    endfunction

    //Report phase
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total functional coverage= %0.2f%%",cf_FIFO.get_coverage()),UVM_LOW);
    endfunction
endclass
endpackage
`endif