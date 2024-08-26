# Project-specific variables
PROJECT_NAME ?= my_project

# Directories (relative to the current project folder)
VIVADO_PROJECT_DIR := vivado_project
SRC_DIR := src
SIM_DIR := sim
SYN_DIR := syn
SCRIPTS_DIR := scripts
REPORTS_DIR := reports
FPGA_DIR := fpga

# Default target: Set up directories
all: setup_project

# Setup directories and create initial .sv file
setup_project: $(VIVADO_PROJECT_DIR) $(SRC_DIR)/$(PROJECT_NAME).sv
	@echo "Project directories created and initial SV file set up."

# Create necessary directories and move constraint file
$(VIVADO_PROJECT_DIR):
	mkdir -p $(SRC_DIR) $(SIM_DIR) $(FPGA_DIR) $(SCRIPTS_DIR) $(REPORTS_DIR) $(VIVADO_PROJECT_DIR)

# Create initial .sv file
$(SRC_DIR)/$(PROJECT_NAME).sv:
	@echo "module $(PROJECT_NAME) ();" > $(SRC_DIR)/$(PROJECT_NAME).sv
	@echo "endmodule" >> $(SRC_DIR)/$(PROJECT_NAME).sv

# Clean target (removes reports, logs, and build artifacts only)
clean:
	@echo "Cleaning build artifacts for $(PROJECT_NAME)..."
	rm -rf $(REPORTS_DIR)/* $(FPGA_DIR)/*.bit $(VIVADO_PROJECT_DIR)/*.log $(VIVADO_PROJECT_DIR)/*.jou
	@echo "Cleanup complete."

.PHONY: all setup_project clean
