`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Jump and Link Arithmetic Logic Unit Output Multiplexer
// Instruction Stage: Execution
//
// Description: This mux chooses the ALU output value between what is calculated
//              in the ALU and the iterated program counter value for the
//              Jump and Link instruction.
////////////////////////////////////////////////////////////////////////////////


module JalALUMux(
    // Inputs
    input isJalInstruction,
    input [31:0] jalPC,
    input [31:0] aluOut,
    // Outputs
    output reg [31:0] chosenValue
    );

    always @(*) begin
        if (isJalInstruction) chosenValue = jalPC;
        else chosenValue = aluOut;
    end
endmodule
