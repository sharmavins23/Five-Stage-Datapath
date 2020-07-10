`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Program Counter Adder
// Instruction Stage: Instruction Fetch
//
// Description: Iterates the program counter to read the next instruction from
//              instruction memory on every single clock cycle.
////////////////////////////////////////////////////////////////////////////////


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
    
    always @(*) begin
        // Iterate the address up by two words
        nextAddress = currentAddress + 4;
    end
endmodule
