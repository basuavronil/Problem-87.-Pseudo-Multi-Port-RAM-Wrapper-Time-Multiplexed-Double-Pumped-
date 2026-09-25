`timescale 1ns / 1ps

module tb_pseudo_dp_ram;

    // Testbench Signals
    reg       clk;
    reg       ren_rd;
    reg [3:0] addr_rd;
    wire [7:0] dout_rd;

    reg       wen_wr;
    reg [3:0] addr_wr;
    reg [7:0] din_wr;

    // Instantiate DUT (Device Under Test)
    pseudo_dp_ram uut (
        .clk(clk),
        .ren_rd(ren_rd),
        .addr_rd(addr_rd),
        .dout_rd(dout_rd),
        .wen_wr(wen_wr),
        .addr_wr(addr_wr),
        .din_wr(din_wr)
    );

    // Clock Generator: 100 MHz (Period = 10ns)
    always #5 clk = ~clk;

    // VCD Waveform Dump Setup
    initial begin
        $dumpfile("pseudo_dp_ram.vcd");
        $dumpvars(0, tb_pseudo_dp_ram);
    end

    // Terminal Monitor Setup
    initial begin
        $monitor("Time=%0t ns | CLK=%b | READ: Addr=%d Data=%h (REN_RD=%b, RAM_REN=%b) | WRITE: Addr=%d Data=%h (WEN_WR=%b, RAM_WEN=%b)",
                 $time, clk, addr_rd, dout_rd, ren_rd, uut.ram_ren, addr_wr, din_wr, wen_wr, uut.ram_wen);
    end

    // Stimulus Block
    initial begin
        // Initialize Inputs
        clk     = 0;
        ren_rd  = 0;
        addr_rd = 4'd0;
        wen_wr  = 0;
        addr_wr = 4'd0;
        din_wr  = 8'h00;

        #10;

        // Step 1: Write 8'hA5 to Address 4
        wen_wr  = 1'b1;
        addr_wr = 4'd4;
        din_wr  = 8'hA5;
        #10;
        wen_wr  = 1'b0;

        // Step 2: Read from Address 4
        ren_rd  = 1'b1;
        addr_rd = 4'd4;
        #10;
        ren_rd  = 1'b0;

        // Step 3: Simultaneous Read Addr 4 & Write Addr 8
        ren_rd  = 1'b1;
        addr_rd = 4'd4;
        wen_wr  = 1'b1;
        addr_wr = 4'd8;
        din_wr  = 8'h3C;
        #10;
        ren_rd  = 1'b0;
        wen_wr  = 1'b0;

        // Step 4: Read from Address 8
        ren_rd  = 1'b1;
        addr_rd = 4'd8;
        #10;
        ren_rd  = 1'b0;

        #20;
        $finish;
    end

endmodule
