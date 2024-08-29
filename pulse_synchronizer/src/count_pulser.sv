`timescale 1ns/1ps

// Outputs a ready signal, waits for a counter to be valid, then sends acknowledgment and pulses that many times
module count_pulser (
    input rst_n,    
    input clk,
    input valid,
    input [31:0] count,
    output logic ready,
    output logic ack,
    output wire pulse
);
    typedef enum logic [1:0] {
        READY = 2'b0,
        HIGH = 2'b1,
        LOW = 2'b10
    } state;
    
    state STATE;
    logic [31:0] pulse_count;
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            pulse_count <= 0;
            ready <= 1;
            ack <= 0;
            STATE <= READY;
        end else if (STATE == READY) begin
            if (valid) begin
                pulse_count <= count;
                ready <= 0;
                ack <= 1;
                STATE <= HIGH;
            end
        end else if (STATE == HIGH) begin
            if (pulse_count <= 1) begin
                ready <= 1;
                STATE <= READY;
            end else begin
                STATE <= LOW;
            end
            pulse_count <= pulse_count - 1;
            ack <= 0;
        end else if (STATE == LOW) begin
            STATE <= HIGH;
        end
    end

    assign pulse = (STATE == HIGH && pulse_count > 0) ? 1 : 0;
    
endmodule