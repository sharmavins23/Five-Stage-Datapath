`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Jump and Link Program Counter Adder
// Instruction Stage: Execution
//
// Description: Since the Jump and Link instruction has to jump back and skip
//              the branch delay instruction, this module iterates the program
//              counter with four again.
////////////////////////////////////////////////////////////////////////////////


module JalPCAdder(
    // Inputs
    input [31:0] currentAddress,
    // Outputs
    output reg [31:0] iteratedAddress
    );

    // Iterate the address up by one word
    always @(*) iteratedAddress = currentAddress + 4;
endmodule
