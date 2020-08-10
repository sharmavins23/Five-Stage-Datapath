`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Arithmetic Logic Unit Input Equality Checker
// Instruction Stage: Instruction Decode
//
// Description: This module pre-emptively checks if the values rs and rt are
//              equal for branching instructions, in order to eliminate control
//              hazards with branching instructions.
////////////////////////////////////////////////////////////////////////////////


module ALUInEqualCheck(
    // Input
    input [31:0] aluInputA,
    input [31:0] aluInputB,
    // Output
    output reg aluInputsAreEqual
    );

    always @(*) begin
        // Signal is high if inputs are equal
        if (aluInputA == aluInputB) aluInputsAreEqual = 1;
        else aluInputsAreEqual = 0;
    end
endmodule
