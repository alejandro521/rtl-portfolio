
`timescale 1ns/1ps
module tb_count_pulser ();
    logic rst_n;
    logic clk;
    logic valid;
    logic [31:0] count;
    logic ready;
    logic ack;
    logic pulse;

    parameter int CLK_PERIOD = 10;

    count_pulser uut (
        .rst_n(rst_n),
        .clk(clk),
        .valid(valid),
        .count(count),
        .ready(ready),
        .ack(ack),
        .pulse(pulse)
    );

    always # (CLK_PERIOD / 2) clk = ~clk;
    
    initial begin
        rst_n = 0;
        clk = 1;
        valid = 0;
        count = 0;

        # (CLK_PERIOD * 3);  // Hold reset for 3 clock cycles
        rst_n = 1;
        
        wait (ready == 1);
        # (CLK_PERIOD * 3 + 1);
        valid = 1;
        count = 32'd5;

        wait (ack == 1);
        # (1);
        valid = 0;

        wait (ready == 1);
        # (CLK_PERIOD * 3 + 1);
        valid = 1;
        count = 32'd6;
        
        wait (ack == 1);
        # (1);
        valid = 0;

        wait (ready == 1);
        
        # (CLK_PERIOD * 10);
        $finish;
    end

endmodule