`include "uvm_pkg_all_v2020_3_2_nodpi.svh"


package FIFO_seq_item_pkg;
import uvm_pkg::*;
parameter FIFO_WIDTH = 16;

class FIFO_seq_item extends uvm_sequence_item;
`uvm_object_utils(FIFO_seq_item)

//declare the input and output
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit  wr_en,rd_en,rst_n;

bit [FIFO_WIDTH-1:0] data_out;
bit full, almostfull, empty, almostempty, overflow, underflow, wr_ack;

//Distribution weigths
int RD_EN_ON_DIST;
int WR_EN_ON_DIST;

//Write the contructor
function new(string name ="fifo_seq_item", int RD_EN_ON_DIST=40, int WR_EN_ON_DIST=60);
super.new(name);
this.RD_EN_ON_DIST=RD_EN_ON_DIST;
this.WR_EN_ON_DIST=WR_EN_ON_DIST;
endfunction

    
//Di
function string convert2string();
      string s;
      s = super.convert2string();
      return $sformatf("%s data_in = 0b%0b, rst_n = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b",
        s, data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    endfunction

    function string convert2string_stimulus();
      return $sformatf("data_in = 0b%0b, rst_n = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b",
        data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    endfunction

//Set constraints
constraint reset_s{
rst_n dist{
    0:/ 10, 1:/ 90
};
}

constraint rd_en_t{
    rd_en dist{
1:/ RD_EN_ON_DIST, 0:/ (100-RD_EN_ON_DIST)
    };
}

constraint wr_en_t{
wr_en dist{
    1:/ WR_EN_ON_DIST, 0:/ (100-WR_EN_ON_DIST)
};
}
endclass
endpackage