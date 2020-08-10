`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Jump Address Shift Register
// Instruction Stage: Instruction Decode
//
// Description: Takes the 26-bit jump address portion of a jump instruction and
//              shifts it left two bits to create a partial 28-bit jump address.
////////////////////////////////////////////////////////////////////////////////


module JumpAddressShift(
    // Inputs
    input [25:0] jumpAddress,
    // Outputs
    output reg [27:0] shiftedJumpAddress
    );

    always @(*) shiftedJumpAddress = jumpAddress << 2;
endmodule
