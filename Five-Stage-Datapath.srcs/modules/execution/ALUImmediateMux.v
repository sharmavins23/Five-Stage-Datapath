`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Arithmetic Logic Unit Immediate Multiplexer
// Instruction Stage: Execution
//
// Description: Given the selector from the control unit, determines whether to
//              send the sign-extended immediate value to the ALU or the loaded
//              second register value to the ALU.
////////////////////////////////////////////////////////////////////////////////


module ALUImmediateMux(
    // Inputs
    input aluImm,
    input [31:0] immediate,
    input [31:0] loadedRegister,
    // Outputs
    output reg [31:0] chosenRegister
    );

    always @(*) begin
        if (aluImm)
            chosenRegister = immediate;
        else
            chosenRegister = loadedRegister;
    end
endmodule
