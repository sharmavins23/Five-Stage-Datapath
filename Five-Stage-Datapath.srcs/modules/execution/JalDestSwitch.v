`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Jump and Link Destination Register Switch
// Instruction Stage: Execution
//
// Description: This switch chooses whether the destination register is the
//              immediate register number value from before, or if the register
//              value is just 31 (since, for the jal instruction, the stored
//              register is $at, or register 31.)
////////////////////////////////////////////////////////////////////////////////

// This could be a multiplexer.
module JalDestSwitch(
    // Inputs
    input isJalInstruction,
    input [4:0] writeDestination,
    // Outputs
    output reg [4:0] registerNumber
    );

    always @(*) begin
        if (isJalInstruction) registerNumber = 31;
        else registerNumber = writeDestination;
    end
endmodule
