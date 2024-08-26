`timescale 1ns/1ps

module led_blink (
    input logic clk,
    input logic rst, // high at rest
    output logic led
);
    parameter int BLINK_PERIOD = 100_000_000;

    logic [31:0] counter = 0;
     always_ff @(posedge clk) begin
         if (!rst) begin
             counter <= 32'b0;
             led <= 1'b0;
         end else if (counter == BLINK_PERIOD - 1) begin
             counter <= 1'b0;
             led <= ~led;
         end else begin
             counter <= counter + 1;
         end
     end
    
endmodule
