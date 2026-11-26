### 2026-09-19: Project Kickoff & Transaction Setup

- **Project Kickoff**
- **Implemented `fifo_seq_item.sv`:**
  - Declared transaction data fields (stimulus and response signals).
  - Defined input stimulus (`data_in`, `rst_n`, `wr_en`, `rd_en`) and monitored output signals (`data_out`, status flags).
  - Established distribution constraints for randomized inputs (`rst_n`, `wr_en`, `rd_en`).
  - Encapsulated the class inside `FIFO_seq_item_pkg`.
- **Implemented `fifo_config_obj.sv`:**
  - Encapsulated the virtual interface handle (`virtual FIFO_if`) inside a `uvm_object` for `uvm_config_db` propagation.

**Next Steps (Upcoming 2 Days):**

- Implement `FIFO_sequencer` and `FIFO_driver` to complete the stimulus driving pipeline.

### 2026-09-22: Define and implement the fifo sequencer

- **Implemented 'fifo_sequencer.sv':**
  - Extends `uvm_sequencer #(FIFO_seq_item).
  - Registered with uvm_component_utils.
  - Wrapped inside "FIFO_sequencer_pkg"

### 2026-09-28: Define and implement the fifo_monitor

- Implemented 'fifo_monitor.sv"
  - Extends 'uvm_monitor' and registered with factory
  - Instantiated 'uvm_analysis_port #(FIFO_seq_item)' in build_phase
  - Sampled DUT inputs/outputs at negedge FIFO_monitor_vif.clk in run_phase
  - Broadcasted captured transaction via 'mon_ap.write()'

### 2026-05-10: Defined and implemented the fifo_driver,fifo_agent and fixed code

- **Implemented `fifo_driver.sv`**:

  - Inherited from `uvm_driver #(FIFO_seq_item)` and registered with factory.
  - Implemented handshake mechanism in `run_phase`.
  - Driven interface signals (`rst_n`, `data_in`, `wr_en`, `rd_en`).
- **Implemented 'fifo_agent.sv':**

  - Extended `uvm_agent` and registered with factory.
  - Declared component handles (`agent_drv`, `agent_mon`, `agent_seq`, `agent_config_obj`, `agent_ap`).
  - Connected `driver.seq_item_port` to `sequencer.seq_item_export` in `connect_phase`.
  - Connected `monitor.mon_ap` to agent's `agent_ap`.
  - Assigned virtual interfaces from `agent_config_obj` to driver and monitor.
- **Fixed typos in 'fifo_sequencer.sv'**

  - Fixed the typos in code



  ### 2026-11-27: Complete UVM Testbench, Functional Coverage, SVA & Vivado Simulation


  - **Implemented `fifo_scoreboard.sv`:**

    - Extended `uvm_scoreboard` and instantiated `sb_export` and `uvm_tlm_analysis_fifo` (`sb_fifo`).
    - Built software golden model using `expected_data_q` and `read_latency_q` to handle 1-cycle read latency.
    - Checked `data_out` mismatches and handled simultaneous read/write edge cases at full/empty boundaries.
    - Added pass/fail transaction counters reported in `report_phase`.
  - **Implemented `fifo_subscriber.sv`:**

    - Extended `uvm_subscriber #(FIFO_seq_item)` and created covergroup `cf_FIFO`.
    - Added coverpoints for control signals and status flags (`wr_en`, `rd_en`, `wr_ack`, `full`, `empty`, `almostfull`, `almostempty`, `overflow`, `underflow`).
    - Added cross coverage (`cx_wr_ack`, `cx_overflow`, `cx_underflow`, `cx_full`, `cx_empty`, `cx_almostfull`, `cx_almostempty`) with `ignore_bins` for unreachable states at `negedge clk`.
  - **Implemented `fifo_env.sv`:**

    - Extended `uvm_env` and instantiated `env_agent`, `env_scoreboard`, and `env_subscriber`.
    - Connected `env_agent.agent_ap` to `env_scoreboard.sb_export` and `env_subscriber.analysis_export` in `connect_phase`.
  - **Implemented `fifo_sequence.sv` & `fifo_test.sv`:**

    - Added `FIFO_reset_sequence`, `FIFO_write_only_sequence`, `FIFO_read_only_sequence`, and `FIFO_read_write_sequence`.
    - Implemented `FIFO_test` to get `virtual FIFO_if` from `uvm_config_db`, pass `FIFO_config_obj` down to the agent, and run all 4 sequences sequentially.
  - **Implemented `fifo_sva.sv` & `testbench.sv`:**

    - Added concurrent assertions (`write_ptr`, `read_ptr`, `write_count`, `read_count`, `read_write_count`, `overflow_p`, `wr_ack_p`) and immediate assertions for status flags and reset state.
    - Created `FIFO_top` module in `testbench.sv`, connected DUT and `FIFO_if`, bound `FIFO_sva` to `FIFO`, and started `run_test("FIFO_test")`.
  - **RTL Updates, Repo Cleanup & Verification Results:**

    - Updated `fifo.sv` to register `wr_ack`/`overflow` flags and simplified `count` logic using `case`.
    - Moved `fifo.sv` and `fifo_if.sv` into `Rtl/`, added `.gitignore`, and fixed syntax/connection issues in `fifo_driver.sv`, `fifo_monitor.sv`, `fifo_sequencer.sv`, and `fifo_agent.sv`.
    - Verified with Vivado Simulator (`xvlog`, `xelab`, `xsim`):
      - Total successful transactions: 251
      - Total failed transactions: 0
      - `UVM_ERROR`: 0, `UVM_FATAL`: 0
      - Functional coverage: 100.00%
