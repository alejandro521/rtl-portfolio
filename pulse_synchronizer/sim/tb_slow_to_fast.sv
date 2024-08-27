`timescale 1ns/1ps
module tb_slow_to_fast();

    // Clock and reset signals
    logic n_rst_a;
    logic n_rst_b;
    logic clk_a;
    logic clk_b;
    logic signal;
    logic pulse_a;
    logic pulse_b;

    // Parameters
    parameter int CLK_PERIOD_A = 100;
    parameter int CLK_PERIOD_B = 10;

    slow_to_fast uut (
        .n_rst_a(n_rst_a),
        .n_rst_b(n_rst_b),
        .clk_a(clk_a),
        .clk_b(clk_b),
        .signal(signal),
        .pulse_a(pulse_a),
        .pulse_b(pulse_b)
    );

    // Generate clock signals
    always # (CLK_PERIOD_A / 2) clk_a = ~clk_a;
    always # (CLK_PERIOD_B / 2) clk_b = ~clk_b;
    // Testbench initialization
    
    initial begin
        // Initialize signals
        clk_a = 1;
        clk_b = 1;
        n_rst_a = 0;
        n_rst_b = 0;
        signal = 0;

        // Reset the design
        # (CLK_PERIOD_A * 3);  // Hold reset for 5 clock cycles
        n_rst_a = 1;
        n_rst_b = 1;


        // Cycle through 1000 random values for 'signal'
        for (int i = 0; i < 1000; i++) begin
            # (1);
            // Generate a random value for signal (you can mask the value if needed)
            signal = $urandom % 2;  // Generate a random 1-bit value (0 or 1)
            # (3 * CLK_PERIOD_A - 1);
        end


        // End the simulation
        $finish;
    end

endmodule