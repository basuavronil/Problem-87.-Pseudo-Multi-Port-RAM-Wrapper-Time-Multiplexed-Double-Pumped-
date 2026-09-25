// Pseudo Multi-Port RAM Wrapper using Double-Edge Time Multiplexing
module pseudo_dp_ram (
    input  wire       clk,
    // Port A (Read Port)
    input  wire       ren_a,
    input  wire [3:0] addr_a,
    output reg  [7:0] dout_a,
    // Port B (Write Port)
    input  wire       wen_b,
    input  wire [3:0] addr_b,
    input  wire [7:0] din_b
);

    // Single-Port Core Memory (16 depth x 8 bits width)
    reg [7:0] memory [0:15];

    // Internal Single-Port Interface MUX Signals
    reg [3:0] ram_addr;
    reg [7:0] ram_din;
    reg       ram_wen;

    // Time-Multiplexing MUX Logic
    // High Clock Phase -> Port A (Read)
    // Low Clock Phase  -> Port B (Write)
    always @(*) begin
        if (clk) begin
            ram_addr = addr_a;
            ram_din  = 8'h00;
            ram_wen  = 1'b0; // Force read mode
        end else begin
            ram_addr = addr_b;
            ram_din  = din_b;
            ram_wen  = wen_b; // Apply write enable
        end
    end

    // Phase 1: Read Access on Rising Edge (Clock High Phase)
    always @(posedge clk) begin
        if (ren_a) begin
            dout_a <= memory[ram_addr];
        end
    end

    // Phase 2: Write Access on Falling Edge (Clock Low Phase)
    always @(negedge clk) begin
        if (ram_wen) begin
            memory[ram_addr] <= ram_din;
        end
    end

endmodule
