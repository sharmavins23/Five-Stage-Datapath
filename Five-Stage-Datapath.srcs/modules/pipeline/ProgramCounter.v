`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Program Counter Register
// Instruction Stage: Pipeline Register
//
// Description: Pipeline register that begins stage 1 of the datapath. This
//              register iterates through the instructions in the MIPS assembly
//              program.
////////////////////////////////////////////////////////////////////////////////


module ProgramCounter(
    // Inputs
    input clock,
    input [31:0] nextAddress,
    // Outputs
    output reg [31:0] currentAddress
    );
    
    always @(posedge clock) begin
        // Set next program counter value to the input
        currentAddress <= nextAddress;
    end
endmodule
