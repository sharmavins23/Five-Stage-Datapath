`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Branch Address Program Counter Adder
// Instruction Stage: Instruction Decode
//
// Description: Adds the branch address offset value to the future program
//              counter value to get the absolute program counter value that
//              the branch instruction refers to. 
////////////////////////////////////////////////////////////////////////////////


module BranchPCAdder(
    // Inputs
    input [31:0] programCounter,
    input [17:0] branchOffset,
    // Outputs
    output reg [31:0] branchAddress
    );

    // Used for sign extension of offset
    reg [31:0] extendedBranchOffset;
    
    always @(*) begin
        extendedBranchOffset = {{14{branchOffset[17]}}, branchOffset};

        // Add the PC and extended offset to get the proper address
        branchAddress = programCounter + extendedBranchOffset;
    end
endmodule
