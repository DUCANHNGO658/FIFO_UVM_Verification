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

### 20206-09-28: Define and implement the fifo_monitor
- Implemented 'FIFO_monitor.sv"
  - Extends 'uvm_monitor' and registered with factory
  - Instantiated 'uvm_analysis_port #(FIFO_seq_item in build_phase)
  - Sampled DUT inputs/outputs at negedge monitor_vif.clk in run_phase
  - Broadcasted captured transaction via 'mon_ap.write()'
### 2026-05-10: Defined and implemented the fifo_driver,fifo_agent and fixed code
- **Implemented `fifo_driver.sv`**:
  - Inherited from `uvm_driver #(FIFO_seq_item)` and registered with factory.
  - Implemented handshake mechanism in `run_phase`.
  - Driven interface signals (`rst_n`, `data_in`, `wr_en`, `rd_en`).

- **Implemented 'FIFO_agent.sv':**
  - Extended `uvm_agent` and registered with factory.
  - Declared component handles (`agent_drv`, `agent_mon`, `agent_seq`, `fifo_config_agent`, `agent_ap`).
  - Connected `driver.seq_item_port` to `sequencer.seq_item_export` in `connect_phase`.
  - Connected `monitor.mon_ap` to agent's `agent_ap`.
  - Assigned virtual interfaces from `fifo_config_agent` to driver and monitor.
- **Fixed typos in 'fifo_sequencer.sv'**
  - Fixed the typos in code