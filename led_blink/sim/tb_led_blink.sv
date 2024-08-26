`timescale 1ns/1ps
module tb_led_blink();

    // Clock and reset signals
    logic clk;
    logic rst;
    logic led;

    // Parameters
    parameter int CLK_PERIOD = 10; // 100 MHz clock (10 ns period)
    parameter int BLINK_PERIOD = 100_000_000; // 100,000,000 cycles for blinking

    // Instantiate the LED blinker module
    led_blink uut (
        .clk(clk),
        .rst(rst),
        .led(led)
    );

    // Generate clock signal
    always # (CLK_PERIOD / 2) clk = ~clk;

    // Testbench initialization
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;

        // Reset the design
        # (CLK_PERIOD * 5);  // Hold reset for 5 clock cycles
        rst = 1;

        // Wait for some time to observe LED behavior
        # (BLINK_PERIOD * 4 * CLK_PERIOD);  // Simulate enough cycles for 3 LED toggles

        // End the simulation
        $finish;
    end

    // Assertion to check that the LED toggles every BLINK_PERIOD cycles
    logic [31:0] cycle_count;
    logic prev_led;

    initial begin
        cycle_count = 0;
        prev_led = 0;

        // Monitor the LED and check that it toggles at the correct time
        forever @(posedge clk) begin
            if (rst) begin
                // Check if LED toggles after 100,000,000 cycles
                if (prev_led !== led) begin
                    assert (cycle_count == BLINK_PERIOD)
                    else begin
                        $display("Error at time %0t:", $time);
                        $display("LED did not toggle after the correct number of cycles.");
                        $display("Expected cycle count: %0d, Actual cycle count: %0d", BLINK_PERIOD, cycle_count);
                        $display("Previous LED value: %0b, Current LED value: %0b", prev_led, led);
                        $fatal(1, "Fatal error: LED did not toggle correctly.");
                    end
                    // Reset the cycle count and record the new LED state
                    cycle_count <= 1;
                    prev_led <= led;
                end else begin
                    cycle_count <= cycle_count + 1;
                end
            end
        end
    end
endmodule
