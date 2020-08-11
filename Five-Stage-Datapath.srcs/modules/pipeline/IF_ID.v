`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Instruction Fetch/Instruction Decode Stage Pipeline Register
// Instruction Stage: Pipeline Register
//
// Description: Pipeline register between stages 1 and 2 of the datapath. Passes
//              through an untouched version of the current instruction each
//              clock cycle. Also passes through the next program counter. Only
//              functions when enabled.
////////////////////////////////////////////////////////////////////////////////


module IF_ID(
    // Inputs
    input clock,
    input enable,
    input [31:0] nextPC,
    input [31:0] loadedInstruction,
    // Outputs
    output reg [31:0] dnextPC,
    output reg [31:0] savedInstruction
    );
    
    always @(posedge clock) begin
        if (enable) begin
            dnextPC <= nextPC;
            savedInstruction <= loadedInstruction;
        end
    end
endmodule
