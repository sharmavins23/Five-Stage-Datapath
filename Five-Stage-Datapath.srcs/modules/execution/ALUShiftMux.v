`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Arithmetic Logic Unit Shift Multiplexer
// Instruction Stage: Execution
//
// Description: This multiplexer enables shift instructions (sll, srl, sra) by
//              selecting between the shift amount portion of the immediate
//              field, and the input register.
////////////////////////////////////////////////////////////////////////////////


module ALUShiftMux(
    // Inputs
    input isShiftInstruction,
    input [31:0] aluInA,
    input [4:0] shiftAmt,
    // Outputs
    output reg [31:0] aluInput
    );

    always @(*) begin
        if (isShiftInstruction) aluInput = {{27{1'b0}}, shiftAmt};
        else aluInput = aluInA;
    end
endmodule
