// Pseudo Multi-Port RAM Wrapper using Double-Edge Time Multiplexing
module pseudo_dp_ram (
    input  wire       clk,
    // Read Port Interface
    input  wire       ren_rd,
    input  wire [3:0] addr_rd,
    output reg  [7:0] dout_rd,
    // Write Port Interface
    input  wire       wen_wr,
    input  wire [3:0] addr_wr,
    input  wire [7:0] din_wr
);

    // Single-Port Core Memory Array (16 depth x 8 bits width)
    reg [7:0] memory [0:15];

    // Internal Single-Port Interface MUX Signals
    reg [3:0] ram_addr;
    reg [7:0] ram_din;
    reg       ram_wen;
    reg       ram_ren; // Internal Read Enable Register

    // Time-Multiplexing MUX Logic
    // High Clock Phase -> Read Operations (addr_rd)
    // Low Clock Phase  -> Write Operations (addr_wr)
    always @(*) begin
        if (clk) begin
            ram_addr = addr_rd;
            ram_din  = 8'h00;
            ram_ren  = ren_rd;  // Pass read enable signal
            ram_wen  = 1'b0;    // Disable write mode during read phase
        end else begin
            ram_addr = addr_wr;
            ram_din  = din_wr;
            ram_ren  = 1'b0;    // Disable read mode during write phase
            ram_wen  = wen_wr;  // Pass write enable signal
        end
    end

    // Phase 1: Read Access on Rising Edge (Clock High Phase)
    always @(posedge clk) begin
        if (ram_ren) begin
            dout_rd <= memory[ram_addr];
        end
    end

    // Phase 2: Write Access on Falling Edge (Clock Low Phase)
    always @(negedge clk) begin
        if (ram_wen) begin
            memory[ram_addr] <= ram_din;
        end
    end

endmodule
