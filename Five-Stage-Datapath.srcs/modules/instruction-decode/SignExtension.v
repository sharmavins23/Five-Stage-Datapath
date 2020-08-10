`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Immediate Value Sign Extension
// Instruction Stage: Instruction Decode
//
// Description: Concatenates and extends the immediate value of the instruction
//              from a 16 bit value to a 32 bit value.
//              An input signal determines whether the extended value is signed
//              or unsigned, and if signed, the value is concatenated properly.
//              Otherwise, the value is concatenated with zeroes alone.
////////////////////////////////////////////////////////////////////////////////


module SignExtension(
    // Inputs
    input [15:0] immediate,
    input signedExtension,
    // Outputs
    output reg [31:0] immediateExtended
    );

    // Concatenate the immediate value with the first bit to get proper sign
    always @(*) begin
        if (signedExtension) 
            immediateExtended = {{17{immediate[15]}}, immediate[14:0]};
        else
            immediateExtended = {{16{1'b0}}, immediate};
    end
endmodule
