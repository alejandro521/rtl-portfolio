`timescale 1ns/1ps
module fast_to_slow (
    input logic rst_n_a,
    input logic rst_n_b,
    input logic clk_a,
    input logic clk_b,
    input logic signal,
    output wire pulse_a,
    output wire pulse_b
    );
    
    // Detects edge from signal in clock a's domain
    edge_detector ed (
        .rst_n(rst_n_a),
        .clk(clk_a),
        .signal(signal),
        .pulse(pulse_a)
    );
    
    logic [31:0] pulse_counter; // used by A to track how many pulses have passed.

    logic valid;
    logic [31:0] pulse_count_data; // counter sent to B
    wire ready_b, ack_b;

    count_pulser circuit_b (
        .rst_n(rst_n_b),
        .clk(clk_b),
        .valid(valid),
        .count(pulse_count_data),
        .ready(ready_b),
        .ack(ack_b),
        .pulse(pulse_b)
    );

    // ready_b and ack_b come from a slower clock domain, we need to pass them through a dff_ed
    wire ready, ack;
    dff_edge_detector ready_ed (
        .rst_n(rst_n_a),
        .clk(clk_a),
        .signal(ready_b),
        .pulse(ready)
    );
    dff_edge_detector ack_ed (
        .rst_n(rst_n_a),
        .clk(clk_a),
        .signal(ack_b),
        .pulse(ack)
    );

    always_ff @(posedge clk_a) begin
        if (!rst_n_a) begin
            pulse_counter <= 0;
            valid <= 0;
            pulse_count_data <= 0;
        end else if (ready) begin
            pulse_count_data <= pulse_counter + (pulse_a ? 32'd1 : 32'd0);
            valid <= 1;
            pulse_counter <= 0;
        end else begin
            if (ack) valid <= 0; // valid stays high until acknowledge from B
            pulse_counter <= pulse_counter + (pulse_a ? 32'd1 : 32'd0);
        end
    end


endmodule