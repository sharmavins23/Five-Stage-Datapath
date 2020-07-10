`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Program Instruction Memory
// Instruction Stage: Instruction Fetch
//
// Description: Contains all of the program instructions, addressed in sets of
//              byte portions. Each instruction is four memory locations long.
////////////////////////////////////////////////////////////////////////////////


module InstructionMemory(
    // Inputs
    input [31:0] address,
    // Outputs
    output reg [31:0] loadedInstruction
    );
    
    // Instruction memory file, 8 bits wide, capable of holding 128 instructions
    reg [7:0] instructionMemory [0:511];
    
    initial begin
        // Manually loading our program instructions
        
        // lw $v0, 00($at)
        // 100011 00001 00010 0000000000000000
        instructionMemory[100] = 8'b10001100;
        instructionMemory[101] = 8'b00100010;
        instructionMemory[102] = 8'b00000000;
        instructionMemory[103] = 8'b00000000;
        // This has a hex value of 0x8C220000
        
        // lw $v1, 04($at)
        // 100011 00001 00011 0000000000000100
        instructionMemory[104] = 8'b10001100;
        instructionMemory[105] = 8'b00100011;
        instructionMemory[106] = 8'b00000000;
        instructionMemory[107] = 8'b00000100;
        // This has a hex value of 0x8C230004
    end
    
    always @(*) begin
        // Fetch instruction given address, loading each individual byte
        loadedInstruction[31:24] = instructionMemory[address];
        loadedInstruction[23:16] = instructionMemory[address+1];
        loadedInstruction[15:8] = instructionMemory[address+2];
        loadedInstruction[7:0] = instructionMemory[address+3];
    end
endmodule
