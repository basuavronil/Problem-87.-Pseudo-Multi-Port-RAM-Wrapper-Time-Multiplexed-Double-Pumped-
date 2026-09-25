`timescale 1ns / 1ps

module tb_pseudo_dp_ram;

    // Inputs
    reg       clk;
    reg       ren_a;
    reg [3:0] addr_a;
    reg       wen_b;
    reg [3:0] addr_b;
    reg [7:0] din_b;

    // Outputs
    wire [7:0] dout_a;

    // Instantiate DUT (Device Under Test)
    pseudo_dp_ram uut (
        .clk(clk),
        .ren_a(ren_a),
        .addr_a(addr_a),
        .dout_a(dout_a),
        .wen_b(wen_b),
        .addr_b(addr_b),
        .din_b(din_b)
    );

    // Clock Generator (100 MHz -> Period = 10ns)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk    = 0;
        ren_a  = 0;
        addr_a = 4'd0;
        wen_b  = 0;
        addr_b = 4'd0;
        din_b  = 8'h00;

        #10; // Wait for initial settling

        // Step 1: Perform Write operation on Port B at Address 4
        $display("--- Step 1: Write 8'hA5 to Address 4 ---");
        wen_b  = 1'b1;
        addr_b = 4'd4;
        din_b  = 8'hA5;
        #10;
        wen_b  = 1'b0;

        // Step 2: Perform Read operation on Port A from Address 4
        $display("--- Step 2: Read from Address 4 ---");
        ren_a  = 1'b1;
        addr_a = 4'd4;
        #10;
        ren_a  = 1'b0;

        // Step 3: Simultaneous Write to Address 8 and Read from Address 4
        $display("--- Step 3: Simultaneous Read Addr 4 & Write Addr 8 ---");
        ren_a  = 1'b1;
        addr_a = 4'd4;
        wen_b  = 1'b1;
        addr_b = 4'd8;
        din_b  = 8'h3C;
        #10;
        ren_a  = 1'b0;
        wen_b  = 1'b0;

        // Step 4: Verify write to Address 8
        $display("--- Step 4: Read from Address 8 ---");
        ren_a  = 1'b1;
        addr_a = 4'd8;
        #10;
        ren_a  = 1'b0;

        #20;
        $display("Simulation Complete!");
        $finish;
    end

    // Monitor Output
    initial begin
        $monitor("Time=%0t ns | CLK=%b | Read Addr=%d -> Dout=%h | Write Addr=%d -> Din=%h (WEN=%b)",
                 $time, clk, addr_a, dout_a, addr_b, din_b, wen_b);
    end

endmodule
