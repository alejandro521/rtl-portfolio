`timescale 1ns/1ps
module tb_fast_to_slow();
    logic rst_n_a;
    logic rst_n_b;
    logic clk_a;
    logic clk_b;
    logic signal;
    logic pulse_a;
    logic pulse_b;

    parameter int CLK_PERIOD_A = 10;
    parameter int CLK_PERIOD_B = 128;

    fast_to_slow uut (
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

        # (CLK_PERIOD_B * 3);
        rst_n_a = 1;
        rst_n_b = 1;


        // Cycle through 500 random values for 'signal'
        for (int i = 0; i < 500; i++) begin
            # (1);
            signal = $urandom % 2;  // Generate a random 1-bit value
            # (3 * CLK_PERIOD_A - 1);
        end

        # (200 * CLK_PERIOD_B);
        
        $display("pulse_count_a = %h", pulse_count_a);
        $display("pulse_count_b = %h", pulse_count_b);

        // Assertion to check equality
        assert(pulse_count_a == pulse_count_b) 
        else $fatal(1, "Pulse counts do not match!");
        
        // Cycle through another 200 random values for 'signal'
        for (int i = 0; i < 200; i++) begin
            # (1);
            signal = $urandom % 2;  // Generate a random 1-bit value
            # (CLK_PERIOD_A - 1); // These pulses are faster
        end

        # (200 * CLK_PERIOD_B);
        $display("pulse_count_a = %h", pulse_count_a);
        $display("pulse_count_b = %h", pulse_count_b);
        
        // Cycle through another 100 random values for 'signal'
        for (int i = 0; i < 100; i++) begin
            # (1);
            signal = $urandom % 2;  // Generate a random 1-bit value
            # (20* CLK_PERIOD_A - 1); // These pulses are faster
        end

        # (200 * CLK_PERIOD_B);
        $display("pulse_count_a = %h", pulse_count_a);
        $display("pulse_count_b = %h", pulse_count_b);

        // Assertion to check equality
        assert(pulse_count_a == pulse_count_b) 
        else $fatal(1, "Pulse counts do not match!");

    
        $finish;
    end
    

    logic prev_a;
    logic prev_b;
    
    initial begin
        forever @(posedge clk_a) begin
            if (!rst_n_a) begin
                pulse_count_a <= 0;
                prev_a = 0;
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
                prev_b = 0;
            end else if (pulse_b && !prev_b) begin
                pulse_count_b <= pulse_count_b + 1;
            end
            prev_b <= pulse_b;
        end
    end

endmodule