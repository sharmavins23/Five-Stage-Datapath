`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Program Counter Adder
// Instruction Stage: Instruction Fetch
//
// Description: Iterates the program counter to read the next instruction from
//              instruction memory on every single clock cycle.
////////////////////////////////////////////////////////////////////////////////

// This could be a universal module.
module PCAdder(
    // Inputs
    input [31:0] currentAddress,
    // Outputs
    output reg [31:0] nextAddress
    );
    
    initial begin
        // Our program starts at address 100, so at the start we'll pass in 100
        nextAddress = 100;
    end
    
    // Iterate the address up by one word
    always @(*) nextAddress = currentAddress + 4;
endmodule
