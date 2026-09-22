### 2026-09-19: Project Kickoff & Transaction Setup

- **Project Kickoff**
- **Implemented `FIFO_seq_item.sv`:**
  - Declared transaction data fields (stimulus and response signals).
  - Defined input stimulus (`data_in`, `rst_n`, `wr_en`, `rd_en`) and monitored output signals (`data_out`, status flags).
  - Established distribution constraints for randomized inputs (`rst_n`, `wr_en`, `rd_en`).
  - Encapsulated the class inside `FIFO_seq_item_pkg`.
- **Implemented `FIFO_config_obj.sv`:**
  - Encapsulated the virtual interface handle (`virtual FIFO_if`) inside a `uvm_object` for `uvm_config_db` propagation.

**Next Steps (Upcoming 2 Days):**
- Implement `FIFO_sequencer` and `FIFO_driver` to complete the stimulus driving pipeline.

### 2026-09-22: Define and implement the fifo sequencer

- **Implemented 'FIFO_sequencer.sv':**
  - Extends `uvm_sequencer #(FIFO_seq_item).
  - Registered with uvm_component_utils.
  - Wrapped inside "FIFO_sequencer_pkg"

