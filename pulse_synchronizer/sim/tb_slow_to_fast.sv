`timescale 1ns/1ps
module tb_slow_to_fast();
    logic rst_n_a;
    logic rst_n_b;
    logic clk_a;
    logic clk_b;
    logic signal;
    logic pulse_a;
    logic pulse_b;

    parameter int CLK_PERIOD_A = 100;
    parameter int CLK_PERIOD_B = 10;

    slow_to_fast uut (
        .rst_n_a(rst_n_a),
        .rst_n_b(rst_n_b),
        .clk_a(clk_a),
        .clk_b(clk_b),
        .signal(signal),
        .pulse_a(pulse_a),
        .pulse_b(pulse_b)
    );

    always # (CLK_PERIOD_A / 2) clk_a = ~clk_a;
    always # (CLK_PERIOD_B / 2) clk_b = ~clk_b;
    logic [9:0] pulse_count_a;
    logic [9:0] pulse_count_b;
    
    initial begin
        clk_a = 1;
        clk_b = 1;
        rst_n_a = 0;
        rst_n_b = 0;
        signal = 0;

        # (CLK_PERIOD_A * 3);
        rst_n_a = 1;
        rst_n_b = 1;

        // Cycle through 1000 random values for 'signal'
        for (int i = 0; i < 1000; i++) begin
            # (1);
            // Generate a random value for signal (you can mask the value if needed)
            signal = $urandom % 2;  // Generate a random 1-bit value (0 or 1)
            # (3 * CLK_PERIOD_A - 1);
        end

        # (CLK_PERIOD_A * 100);

        $display("Pulse A count: %0d", pulse_count_a);
        $display("Pulse B count: %0d", pulse_count_b);
        assert (pulse_count_a == pulse_count_b)
        else begin
            $fatal(1, "Fatal error: Pulse counts do not match!");
        end
        $finish;
    end
    

    logic prev_a;
    logic prev_b;
    
    initial begin
        forever @(posedge clk_a) begin
            if (!rst_n_a) begin
                pulse_count_a <= 0;
            end else if (pulse_a && !prev_a) begin
                pulse_count_a <= pulse_count_a + 1;
            end
            prev_a <= pulse_a;
        end
    end

    initial begin
        forever @(posedge clk_b) begin
            if (!rst_n_b) begin
                pulse_count_b <= 0;
            end else if (pulse_b && !prev_b) begin
                pulse_count_b <= pulse_count_b + 1;
            end
            prev_b <= pulse_b;
        end
    end

endmodule