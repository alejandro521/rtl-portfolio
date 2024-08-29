`timescale 1ns/1ps

// Double flip-flop ED to detect the edge of a signal coming from a slower clock domain
module dff_edge_detector (
    input rst_n,
    input clk,
    input signal,
    output wire pulse
);
    logic ff, stable_signal, prev_signal;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            ff <= 0;
            stable_signal <= 0;
            prev_signal <= 0;
        end else begin
            ff <= signal;
            stable_signal <= ff;
            prev_signal <= stable_signal;
        end
    end
    assign pulse = stable_signal & ~prev_signal;

endmodule
