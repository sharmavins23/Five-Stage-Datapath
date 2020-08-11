`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Program Instruction Memory
// Instruction Stage: Instruction Fetch
//
// Description: Contains all of the program instructions, addressed in sets of
//              byte portions. Each instruction is four memory locations long.
//              In an actual computer, this is the ROM module.
////////////////////////////////////////////////////////////////////////////////


// TODO: Add instructions for final project work
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

        // lw $a0, 08($at)
        // 100011 00001 00100 0000000000001000
        instructionMemory[108] = 8'b10001100;
        instructionMemory[109] = 8'b00100100;
        instructionMemory[110] = 8'b00000000;
        instructionMemory[111] = 8'b00001000;
        // This has a hex value of 0x8C240008

        // lw $a1, 12($at)
        // 100011 00001 00101 0000000000001100
        instructionMemory[112] = 8'b10001100;
        instructionMemory[113] = 8'b00100101;
        instructionMemory[114] = 8'b00000000;
        instructionMemory[115] = 8'b00001100;
        // This has a hex value of 0x8C25000C

        // add $a2, $v0, $t2
        // 000000 00010 01010 00110 00000 100000
        instructionMemory[116] = 8'b00000000;
        instructionMemory[117] = 8'b01001010;
        instructionMemory[118] = 8'b00110000;
        instructionMemory[119] = 8'b00100000;
        // This has a hex value of 0x004A3020
    end
    
    always @(*) begin
        // Fetch instruction given address, loading each individual byte
        loadedInstruction[31:24] = instructionMemory[address];
        loadedInstruction[23:16] = instructionMemory[address+1];
        loadedInstruction[15:8] = instructionMemory[address+2];
        loadedInstruction[7:0] = instructionMemory[address+3];
    end
endmodule
