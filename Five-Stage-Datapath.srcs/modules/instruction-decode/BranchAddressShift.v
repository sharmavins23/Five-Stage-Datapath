`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Branch Address Shift Register
// Instruction Stage: Instruction Decode
//
// Description: Shifts the input 16-bit branch address portion of the fetched
//              instruction left two places.
////////////////////////////////////////////////////////////////////////////////


module BranchAddressShift(
    // Inputs
    input [15:0] branchAddress,
    // Outputs
    output reg [17:0] shiftedBranchAddress
    );

    always @(*) shiftedBranchAddress = branchAddress << 2;
endmodule
