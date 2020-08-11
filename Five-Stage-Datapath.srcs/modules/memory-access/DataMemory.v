`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Program Instruction Memory
// Instruction Stage: Instruction Fetch
//
// Description: Contains all of the program (stack) data, addressed in sets of
//              byte portions. Each instruction is four memory locations long.
//              Data can be written or read out using a data readout signal.
//              In an actual computer, this is the RAM module.
////////////////////////////////////////////////////////////////////////////////


module DataMemory(
    // Inputs
    input memoryWrite,
    input [31:0] address,
    input [31:0] dataIn,
    // Outputs
    output reg [31:0] dataOut
    );

    // Data memory file, 8 bits wide, can hold 32 memory values
    reg [7:0] dataMemory [0:127];

    initial begin
        // Manually loading our data memory
        // Verilog          Binary          Hex
        dataMemory[080] = 8'b00000000; // 0x000000a3
        dataMemory[081] = 8'b00000000;
        dataMemory[082] = 8'b00000000; // Byte 080
        dataMemory[083] = 8'b10100011; // Word 020

        dataMemory[084] = 8'b00000000; // 0x00000027
        dataMemory[085] = 8'b00000000;
        dataMemory[086] = 8'b00000000; // Byte 084
        dataMemory[087] = 8'b00100111; // Word 021

        dataMemory[088] = 8'b00000000; // 0x00000079
        dataMemory[089] = 8'b00000000;
        dataMemory[090] = 8'b00000000; // Byte 088
        dataMemory[091] = 8'b01111001; // Word 022

        dataMemory[092] = 8'b00000000; // 0x00000115
        dataMemory[093] = 8'b00000000;
        dataMemory[094] = 8'b00000001; // Byte 092
        dataMemory[095] = 8'b00010101; // Word 033
    end

    always @(*) begin
        // If memory write signal is high, write the data in to the address
        if (memoryWrite == 1) begin
            dataMemory[address] = dataIn[31:24];
            dataMemory[address+1] = dataIn[23:16];
            dataMemory[address+2] = dataIn[15:8];
            dataMemory[address+3] = dataIn[7:0];
        end

        // Fetch instructions with the input
        dataOut[31:24] = dataMemory[address];
        dataOut[23:16] = dataMemory[address+1];
        dataOut[15:8] = dataMemory[address+2];
        dataOut[7:0] = dataMemory[address+3];
    end
endmodule
