`ifndef FIFO_SCOREBOARD_SV
`define FIFO_SCOREBOARD_SV
 
`include "uvm_macros.svh"
`include "fifo_seq_item.sv"

package FIFO_scoreboard_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;

parameter FIFO_DEPTH = 8;
parameter FIFO_WIDTH = 16;

class FIFO_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FIFO_scoreboard)
    uvm_analysis_export #(FIFO_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
    FIFO_seq_item seq_item_sb;

    //Queue store the data write in FIFO
    bit [FIFO_WIDTH-1:0] expected_data_q[$]; //Self constructed queue, can strech
    //Queue store value read,write, wait for DUT export into data_out
    bit [FIFO_WIDTH-1:0] read_latency_q[$];

int error_count = 0;
int correct_count = 0;

function new(string name ="FIFO_scoreboard",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
sb_export = new("sb_export",this);
sb_fifo = new("sb_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    bit [FIFO_WIDTH-1:0] expected_val;
    bit can_rd, can_wr;
    super.run_phase(phase);

    forever begin
        sb_fifo.get(seq_item_sb);
        if(!seq_item_sb.rst_n)begin
            expected_data_q.delete();
            read_latency_q.delete();
        end else begin
            can_rd = (seq_item_sb.rd_en && (expected_data_q.size()>0));
            can_wr = (seq_item_sb.wr_en && (expected_data_q.size()<FIFO_DEPTH));

        if(read_latency_q.size()>0) begin
            expected_val = read_latency_q.pop_front();
            if(seq_item_sb.data_out!== expected_val) begin
                `uvm_error("check data", $sformatf("Error: data_out mismatch! Expected: %0h, Got: %0h",expected_val,seq_item_sb.data_out))
                error_count++;
            end else begin
                `uvm_info("Check data", $sformatf("Correct: data_out matches at time %0t!",$time),UVM_HIGH)
                correct_count++;
            end
    end


    //Legal read signal push to the latency queue, wait for the next cycle
    if(can_rd) begin
        read_latency_q.push_back(expected_data_q.pop_front());
    end
    //Legal write signal, push to fifo queue
    if(can_wr) begin
        expected_data_q. push_back(seq_item_sb.data_in);
    end
end
    end
endtask
function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase",$sformatf("Total successful transactions: %0d",correct_count),UVM_MEDIUM)
    `uvm_info("report_phase",$sformatf("Total failed transaction: %0d", error_count),UVM_MEDIUM)
endfunction
endclass
endpackage
`endif
