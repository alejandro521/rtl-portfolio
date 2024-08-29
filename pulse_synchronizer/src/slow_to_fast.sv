`timescale 1ns/1ps

module slow_to_fast (
    input logic rst_n_a,
    input logic rst_n_b,
    input logic clk_a,
    input logic clk_b,
    input logic signal,
    output wire pulse_a,
    output wire pulse_b
);
    edge_detector ed (
        .rst_n(rst_n_a),
        .clk(clk_a),
        .signal(signal),
        .pulse(pulse_a)
    );

    dff_edge_detector dff_ed (
        .rst_n(rst_n_b),
        .clk(clk_b),
        .signal(pulse_a),
        .pulse(pulse_b)
    );


endmodule