`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Forward Multiplexer
// Instruction Stage: Instruction Decode
//
// Description: Determines the ALU's input for the next stage, and acts as the
//              controller for any forwarding of instruction values from future
//              stages of previous instructions to current stages of current
//              instructions. Determines between four choices:
//              1. The register memory's output;
//              2. The ALU output at the execution stage;
//              3. The ALU output at the memory access stage;
//              4. The data output at the memory access stage.
////////////////////////////////////////////////////////////////////////////////


module ForwardMux(
    // Inputs
    input [1:0] forwardMuxSelector,
    input [31:0] registryMemoryOut,
    input [31:0] eALUOut,
    input [31:0] mALUOut,
    input [31:0] mDataMemoryOut,
    // Outputs
    output reg [31:0] aluInput
    );

    always @(*) begin
        case(forwardMuxSelector)
            2'b00: aluInput = registryMemoryOut;
            2'b01: aluInput = eALUOut;
            2'b10: aluInput = mALUOut;
            2'b11: aluInput = mDataMemoryOut;
        endcase
    end
endmodule
