`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Register File Write Multiplexer
// Instruction Stage: Write Back
//
// Description: Determines whether the ALU output or the read memory location
//              from the data memory block is stored in the register file.
////////////////////////////////////////////////////////////////////////////////


module DestinationMux(
    // Inputs
    input memoryToRegister,
    input [31:0] aluOut,
    input [31:0] loadedData,
    // Outputs
    output reg [31:0] registerData
    );

    always @(*) begin
        if (memoryToRegister) registerData = loadedData;
        else registerData = aluOut;
    end
endmodule
