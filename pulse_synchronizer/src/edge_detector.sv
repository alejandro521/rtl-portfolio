`timescale 1ns/1ps

module edge_detector (
    input rst_n,
    input clk,
    input signal,
    output wire pulse
);
    logic prev_signal;
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            prev_signal <= 0;
        end else begin
            prev_signal <= signal;
        end
    end
    assign pulse = signal & ~prev_signal;
endmodule