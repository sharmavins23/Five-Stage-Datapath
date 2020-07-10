`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Destination Multiplexer
// Instruction Stage: Instruction Decode
//
// Description: Determines whether the destination register in the MIPS assembly
//              instruction is rd or rt. The selector comes from the control
//              unit.
////////////////////////////////////////////////////////////////////////////////


module DestinationMux(
    // Inputs
    input [4:0] rd,
    input [4:0] rt,
    input destinationRegisterRT,
    // Outputs
    output reg [4:0] destination
    );

    always @(*) begin
        if (destinationRegisterRT) destination = rt;
        else destination = rd;
    end
endmodule
