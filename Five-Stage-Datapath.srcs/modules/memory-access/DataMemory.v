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

        // A00000AA
        dataMemory[0] = 8'hA0;
        dataMemory[1] = 8'h00;
        dataMemory[2] = 8'h00;
        dataMemory[3] = 8'hAA;
        // 10000011
        dataMemory[4] = 8'h10;
        dataMemory[5] = 8'h00;
        dataMemory[6] = 8'h00;
        dataMemory[7] = 8'h11;
        // 20000022
        dataMemory[8] = 8'h20;
        dataMemory[9] = 8'h00;
        dataMemory[10] = 8'h00;
        dataMemory[11] = 8'h22;
        // 30000033
        dataMemory[12] = 8'h30;
        dataMemory[13] = 8'h00;
        dataMemory[14] = 8'h00;
        dataMemory[15] = 8'h33;
        // 40000044
        dataMemory[16] = 8'h40;
        dataMemory[17] = 8'h00;
        dataMemory[18] = 8'h00;
        dataMemory[19] = 8'h44;
        // 50000055
        dataMemory[20] = 8'h50;
        dataMemory[21] = 8'h00;
        dataMemory[22] = 8'h00;
        dataMemory[23] = 8'h55;
        // 60000066
        dataMemory[24] = 8'h60;
        dataMemory[25] = 8'h00;
        dataMemory[26] = 8'h00;
        dataMemory[27] = 8'h66;
        // 70000077
        dataMemory[28] = 8'h70;
        dataMemory[29] = 8'h00;
        dataMemory[30] = 8'h00;
        dataMemory[31] = 8'h77;
        // 80000088
        dataMemory[32] = 8'h80;
        dataMemory[33] = 8'h00;
        dataMemory[34] = 8'h00;
        dataMemory[35] = 8'h88;
        // 90000099
        dataMemory[36] = 8'h90;
        dataMemory[37] = 8'h00;
        dataMemory[38] = 8'h00;
        dataMemory[39] = 8'h99;
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
