`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Next Program Counter Multiplexer
// Instruction Stage: Instruction Fetch
//
// Description: Determines the next program counter value between a series of
//              four choices:
//              1. The current program counter, plus four;
//              2. The target address of a branching (BEQ/BNE) instruction;
//              3. The target address in the register of a JR instruction;
//              4. The jump (immediate) address of a jump (J/JAL) instruction.
////////////////////////////////////////////////////////////////////////////////


module NextPCMux(
    // Inputs
    input [1:0] programCounterSelector
    input [31:0] currentPCPlusFour,
    input [31:0] branchingTarget,
    input [31:0] jumpRegisterTarget,
    input [31:0] jumpImmediateTarget,
    // Outputs
    output reg [31:0] nextPC
    );

    always @(*) begin
        case(programCounterSelector)
            2'b00: nextPC = currentPCPlusFour;
            2'b01: nextPC = branchingTarget;
            2'b10: nextPC = jumpRegisterTarget;
            2'b11: nextPC = jumpImmediateTarget;
        endcase
    end
endmodule
