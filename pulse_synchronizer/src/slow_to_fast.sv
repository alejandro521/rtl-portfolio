`timescale 1ns/1ps

module slow_to_fast (
    input logic n_rst_a,
    input logic n_rst_b,
    input logic clk_a,
    input logic clk_b,
    input logic signal,
    output wire pulse_a,
    output wire pulse_b
);
    logic prev_signal_a;
    always_ff @(posedge clk_a) begin
        if (!n_rst_a) begin
            prev_signal_a <= 0;
        end else begin
            prev_signal_a <= signal;
        end
    end
    assign pulse_a = signal & !prev_signal_a;

    logic dff;
    logic signal_b;
    logic prev_signal_b;
    always_ff @(posedge clk_b) begin
        if (!n_rst_b) begin
            dff <= 0;
            signal_b <= 0;
            prev_signal_b <= 0;
        end else begin
            dff <= pulse_a;
            signal_b <= dff;
            prev_signal_b <= signal_b;
        end
    end
    assign pulse_b = signal_b & !prev_signal_b;


endmodule