`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Register File Memory
// Instruction Stage: Instruction Decode
//
// Description: Contains all of the 32 bit MIPS instruction registers, and loads
//              them on command for the rest of the program.
//              If the write-enable signal is turned on, the given destination
//              register will also be written with data simultaneously.
////////////////////////////////////////////////////////////////////////////////


module RegistryMemory(
    // Inputs
    input clock,
    input [4:0] rna,
    input [4:0] rnb,
    input writeEnable,
    input [31:0] writeData,
    input [4:0] writeDestination,
    // Outputs
    output reg [31:0] registerQA,
    output reg [31:0] registerQB
    );

    // Registry memory, 32 bits wide, holding 32 instructions
    reg [31:0] registry [31:0];
    
    integer i;
    initial begin
        // Manually initializing register files to zeroed values
        for (i = 0; i < 32; i = i+1) begin
            registry[i] <= 0;
        end
    end

    always @(posedge clock) begin
        // Write-back functionality with write-enable
        if (writeEnable) begin
            registry[writeDestination] <= writeData;
        end
    end

    always @(negedge clock) begin
        // Sync inputs with outputs
        registerQA <= registry[rna];
        registerQB <= registry[rnb];
    end
endmodule
