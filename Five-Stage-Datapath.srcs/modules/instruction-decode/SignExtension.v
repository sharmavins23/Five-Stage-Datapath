`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Immediate Value Sign Extension
// Instruction Stage: Instruction Decode
//
// Description: Concatenates and extends the immediate value of the instruction
//              from a 16 bit value to a 32 bit value. Inserts 16 binary values
//              after the 16th sign bit of the immediate value in order to
//              "extend" the value. Values are 0 if positive and 1 if negative.
////////////////////////////////////////////////////////////////////////////////


module SignExtension(
    // Inputs
    input [15:0] immediate,
    // Outputs
    output reg [31:0] immediateExtended
    );

    always @(*) begin
        // Check sign of immediate value
        if (immediate[15] == 0) // Positive
            // Simple concatenation to size increase
            immediateExtended = {{16{1'b0}}, immediate};
        else
            // Insert 16 ones to size increase
            immediateExtended = {{16{1'b1}}, immediate};
    end
endmodule