`ifndef FIFO_SEQUENCE_SV
`define FIFO_SEQUENCE_SV

`include "uvm_macros.svh"
`include "fifo_seq_item.sv"

package FIFO_sequence_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;

class FIFO_reset_sequence extends uvm_sequence#(FIFO_seq_item);
    `uvm_object_utils(FIFO_reset_sequence)
    FIFO_seq_item seq_item;
    //Rst_n sequence constructor
    function new(string name ="reset_sequence");
        super.new(name);
    endfunction

    virtual task pre_body();
        uvm_phase start_phase = get_starting_phase();
        if(start_phase!=null)begin
            start_phase.raise_objection(this);
            `uvm_info("FIFO_SEQ","pre body: Objection raise",UVM_LOW)
        end
    endtask

    virtual task body();
        seq_item = FIFO_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n = 0;
        seq_item.wr_en = 0;
        seq_item.rd_en = 0;
        seq_item.wr_ack = 0;
        finish_item(seq_item);
    endtask

    virtual task post_body();
        uvm_phase start_phase = get_starting_phase;
        if(start_phase!=null)begin
            start_phase.drop_objection(this);
            `uvm_info("FIFO_SEQ","post body: Objection dropped",UVM_LOW)
        end
    endtask
endclass

    class FIFO_write_only_sequence extends uvm_sequence#(FIFO_seq_item);
        `uvm_object_utils(FIFO_write_only_sequence)
FIFO_seq_item seq_item;
int rd_dist = 0;
int wr_dist = 100;
        function new(string name = "FIFO_write_only_sequence");
            super.new(name);
        endfunction
        
        virtual task pre_body();
            uvm_phase start_phase = get_starting_phase();
            if(start_phase !=null)begin
                start_phase.raise_objection(this);
                `uvm_info("FIFO_SEQ","pre body: Objection raised",UVM_LOW)
            end
        endtask

        virtual task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            repeat(100) begin
                seq_item.RD_EN_ON_DIST = rd_dist;
                seq_item.WR_EN_ON_DIST = wr_dist;
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask

        virtual task post_body();
            uvm_phase start_phase = get_starting_phase();
            if(start_phase!=null) begin
                start_phase.drop_objection(this);
                `uvm_info("FIFO_SEQ","post body: Objection dropped",UVM_LOW)
            end
        endtask
    endclass

class FIFO_read_only_sequence extends uvm_sequence #(FIFO_seq_item);
    `uvm_object_utils(FIFO_read_only_sequence)
    FIFO_seq_item seq_item;
int rd_dist = 100;
int wr_dist = 0;

function new(string name ="FIFO_read_only_sequence");
    super.new(name);
endfunction

        virtual task pre_body();
            uvm_phase start_phase = get_starting_phase();
            if(start_phase !=null)begin
                start_phase.raise_objection(this);
                `uvm_info("FIFO_SEQ","pre body: Objection raised",UVM_LOW)
            end
        endtask

        virtual task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            repeat(100) begin
                seq_item.RD_EN_ON_DIST= rd_dist;
                seq_item.WR_EN_ON_DIST=wr_dist;
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask

        virtual task post_body();
            uvm_phase start_phase = get_starting_phase();
            if(start_phase!=null) begin
                start_phase.drop_objection(this);
                `uvm_info("FIFO_SEQ","post body: Objection dropped",UVM_LOW)
            end
        endtask
endclass

class FIFO_read_write_sequence extends uvm_sequence #(FIFO_seq_item);
    `uvm_object_utils(FIFO_read_write_sequence)
    FIFO_seq_item seq_item;
    
    function new(string name = "FIFO_read_write_sequence");
        super.new(name);
    endfunction

        virtual task pre_body();
            uvm_phase start_phase = get_starting_phase();
            if(start_phase !=null)begin
                start_phase.raise_objection(this);
                `uvm_info("FIFO_SEQ","pre body: Objection raised",UVM_LOW)
            end
        endtask

        virtual task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");

            repeat(999) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask

        virtual task post_body();
            uvm_phase start_phase = get_starting_phase();
            if(start_phase!=null) begin
                start_phase.drop_objection(this);
                `uvm_info("FIFO_SEQ","post body: Objection dropped",UVM_LOW)
            end
        endtask
endclass
endpackage
`endif