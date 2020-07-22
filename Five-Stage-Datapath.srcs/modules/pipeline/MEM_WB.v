`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Memory Access/Write Back
// Instruction Stage: Pipeline Register
//
// Description: Pipeline register between stages 4 and 5 of the datapath. Passes
//              through the output of the ALU, as well as the loaded information
//              from the data memory, and other control unit signals.
////////////////////////////////////////////////////////////////////////////////


module MEM_WB(
    // Inputs
    input clock,
    input mregisterWrite,
    input mmemoryToRegister,
    input [4:0] mdestination,
    input [31:0] aluOut,
    input [31:0] loadedData,
    // Outputs
    output reg wregisterWrite,
    output reg wmemoryToRegister,
    output reg [4:0] wdestination,
    output reg [31:0] waluOut,
    output reg [31:0] wloadedData
    );

    always @(posedge clock) begin
        // Assignments in register
        wregisterWrite <= mregisterWrite;
        wmemoryToRegister <= mmemoryToRegister;
        wdestination <= mdestination;
        waluOut <= aluOut;
        wloadedData <= loadedData;
    end
endmodule
