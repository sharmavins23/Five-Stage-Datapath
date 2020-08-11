`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Instruction Decode/Execution Stage Pipeline Register
// Instruction Stage: Pipeline Register
//
// Description: Pipeline register between stages 3 and 4 of the datapath. Passes
//              through some control unit signals, as well as destination
//              register signal, ALU output, and loaded register signal.
////////////////////////////////////////////////////////////////////////////////


module EXE_MEM(
    // Inputs
    input clock,
    input eregisterWrite,
    input ememoryToRegister,
    input ememoryWrite,
    input [31:0] aluOut,
    input [31:0] loadedRegister,
    input [4:0] edestination,
    // Outputs
    output reg mregisterWrite,
    output reg mmemoryToRegister,
    output reg mmemoryWrite,
    output reg [31:0] maluOut,
    output reg [31:0] mloadedRegister,
    output reg [4:0] mdestination
    );

    always @(posedge clock) begin
        // Assignments in register
        mregisterWrite <= eregisterWrite;
        mmemoryToRegister <= ememoryToRegister;
        mmemoryWrite <= ememoryWrite;
        maluOut <= aluOut;
        mloadedRegister <= loadedRegister;
        mdestination <= edestination;
    end
endmodule
