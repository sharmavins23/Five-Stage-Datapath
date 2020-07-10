`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Instruction Fetch/Instruction Decode Stage Pipeline Register
// Instruction Stage: Pipeline Register
//
// Description: Pipeline register between stages 1 and 2 of the datapath. Passes
//              through an untouched version of the current instruction each
//              clock cycle.
////////////////////////////////////////////////////////////////////////////////


module IF_ID(
    // Inputs
    input clock,
    input [31:0] loadedInstruction,
    // Outputs
    output reg [31:0] savedInstruction
    );
    
    always @(posedge clock) begin
        // Save the instruction being pushed in
        savedInstruction <= loadedInstruction;
    end
endmodule
