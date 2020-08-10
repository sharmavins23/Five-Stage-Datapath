`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Jump Address Shift Register
// Instruction Stage: Instruction Decode
//
// Description: Shifts the input 26-bit jump address portion of the fetched
//              instruction left two places.
////////////////////////////////////////////////////////////////////////////////


module JumpAddressShift(
    // Inputs
    input [25:0] jumpAddress,
    // Outputs
    output reg [27:0] shiftedJumpAddress
    );

    always @(*) shiftedJumpAddress = jumpAddress << 2;
endmodule
