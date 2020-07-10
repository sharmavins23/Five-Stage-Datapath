`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Immediate Value Sign Extension
// Instruction Stage: Instruction Decode
//
// Description: Concatenates and extends the immediate value of the instruction
//              from a 16 bit value to a 32 bit value.
////////////////////////////////////////////////////////////////////////////////


module SignExtension(
    // Inputs
    input [15:0] immediate,
    // Outputs
    output reg [31:0] immediateExtended
    );

    always @(*) begin
        // Concatenation to size increase
        immediateExtended = {{16{1'b0}}, immediate};
    end
endmodule
