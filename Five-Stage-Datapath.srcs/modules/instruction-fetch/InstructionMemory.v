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
        instructionMemory[000] = 8'b00111100; // 0x3c010000
        instructionMemory[001] = 8'b00000001;
        instructionMemory[002] = 8'b00000000;
        instructionMemory[003] = 8'b00000000;

        instructionMemory[004] = 8'b00110100; // 0x34240050
        instructionMemory[005] = 8'b00100100;
        instructionMemory[006] = 8'b00000000;
        instructionMemory[007] = 8'b01010000;

        instructionMemory[008] = 8'b00001100; // 0x0c00001b
        instructionMemory[009] = 8'b00000000;
        instructionMemory[010] = 8'b00000000;
        instructionMemory[011] = 8'b00011011;

        instructionMemory[012] = 8'b00100000; // 0x20050004
        instructionMemory[013] = 8'b00000101;
        instructionMemory[014] = 8'b00000000;
        instructionMemory[015] = 8'b00000100;

        instructionMemory[016] = 8'b10101100; // 0xac820000
        instructionMemory[017] = 8'b10000010;
        instructionMemory[018] = 8'b00000000;
        instructionMemory[019] = 8'b00000000;

        instructionMemory[020] = 8'b10001100; // 0x8c890000
        instructionMemory[021] = 8'b10001001;
        instructionMemory[022] = 8'b00000000;
        instructionMemory[023] = 8'b00000000;

        instructionMemory[024] = 8'b00000001; // 0x01244022
        instructionMemory[025] = 8'b00100100;
        instructionMemory[026] = 8'b01000000;
        instructionMemory[027] = 8'b00100010;

        instructionMemory[028] = 8'b00100000; // 0x20050003
        instructionMemory[029] = 8'b00000101;
        instructionMemory[030] = 8'b00000000;
        instructionMemory[031] = 8'b00000011;

        instructionMemory[032] = 8'b00100000; // 0x20a5ffff
        instructionMemory[033] = 8'b10100101;
        instructionMemory[034] = 8'b11111111;
        instructionMemory[035] = 8'b11111111;

        instructionMemory[036] = 8'b00110100; // 0x34a8ffff
        instructionMemory[037] = 8'b10101000;
        instructionMemory[038] = 8'b11111111;
        instructionMemory[039] = 8'b11111111;

        instructionMemory[040] = 8'b00111001; // 0x39085555
        instructionMemory[041] = 8'b00001000;
        instructionMemory[042] = 8'b01010101;
        instructionMemory[043] = 8'b01010101;

        instructionMemory[044] = 8'b00100000; // 0x2009ffff
        instructionMemory[045] = 8'b00001001;
        instructionMemory[046] = 8'b11111111;
        instructionMemory[047] = 8'b11111111;

        instructionMemory[048] = 8'b00110001; // 0x312affff
        instructionMemory[049] = 8'b00101010;
        instructionMemory[050] = 8'b11111111;
        instructionMemory[051] = 8'b11111111;

        instructionMemory[052] = 8'b00000001; // 0x01493025
        instructionMemory[053] = 8'b01001001;
        instructionMemory[054] = 8'b00110000;
        instructionMemory[055] = 8'b00100101;

        instructionMemory[056] = 8'b00000001; // 0x01494026
        instructionMemory[057] = 8'b01001001;
        instructionMemory[058] = 8'b01000000;
        instructionMemory[059] = 8'b00100110;

        instructionMemory[060] = 8'b00000001; // 0x01463824
        instructionMemory[061] = 8'b01000110;
        instructionMemory[062] = 8'b00111000;
        instructionMemory[063] = 8'b00100100;

        instructionMemory[064] = 8'b00010000; // 0x10a00003
        instructionMemory[065] = 8'b10100000;
        instructionMemory[066] = 8'b00000000;
        instructionMemory[067] = 8'b00000011;

        instructionMemory[068] = 8'b00000000; // 0x00000000
        instructionMemory[069] = 8'b00000000;
        instructionMemory[070] = 8'b00000000;
        instructionMemory[071] = 8'b00000000;

        instructionMemory[072] = 8'b00001000; // 0x08000008
        instructionMemory[073] = 8'b00000000;
        instructionMemory[074] = 8'b00000000;
        instructionMemory[075] = 8'b00001000;

        instructionMemory[076] = 8'b00000000; // 0x00000000
        instructionMemory[077] = 8'b00000000;
        instructionMemory[078] = 8'b00000000;
        instructionMemory[079] = 8'b00000000;

        instructionMemory[080] = 8'b00100000; // 0x2005ffff
        instructionMemory[081] = 8'b00000101;
        instructionMemory[082] = 8'b11111111;
        instructionMemory[083] = 8'b11111111;

        instructionMemory[084] = 8'b00000000; // 0x000543c0
        instructionMemory[085] = 8'b00000101;
        instructionMemory[086] = 8'b01000011;
        instructionMemory[087] = 8'b11000000;

        instructionMemory[088] = 8'b00000000; // 0x00084400
        instructionMemory[089] = 8'b00001000;
        instructionMemory[090] = 8'b01000100;
        instructionMemory[091] = 8'b00000000;

        instructionMemory[092] = 8'b00000000; // 0x00084403
        instructionMemory[093] = 8'b00001000;
        instructionMemory[094] = 8'b01000100;
        instructionMemory[095] = 8'b00000011;

        instructionMemory[096] = 8'b00000000; // 0x000843c2
        instructionMemory[097] = 8'b00001000;
        instructionMemory[098] = 8'b01000011;
        instructionMemory[099] = 8'b11000010;

        instructionMemory[100] = 8'b00001000; // 0x08000019
        instructionMemory[101] = 8'b00000000;
        instructionMemory[102] = 8'b00000000;
        instructionMemory[103] = 8'b00011001;

        instructionMemory[104] = 8'b00000000; // 0x00000000
        instructionMemory[105] = 8'b00000000;
        instructionMemory[106] = 8'b00000000;
        instructionMemory[107] = 8'b00000000;

        instructionMemory[108] = 8'b00000000; // 0x00004020
        instructionMemory[109] = 8'b00000000;
        instructionMemory[110] = 8'b01000000;
        instructionMemory[111] = 8'b00100000;

        instructionMemory[112] = 8'b10001100; // 0x8c890000
        instructionMemory[113] = 8'b10001001;
        instructionMemory[114] = 8'b00000000;
        instructionMemory[115] = 8'b00000000;

        instructionMemory[116] = 8'b00000001; // 0x01094020
        instructionMemory[117] = 8'b00001001;
        instructionMemory[118] = 8'b01000000;
        instructionMemory[119] = 8'b00100000;

        instructionMemory[120] = 8'b00100000; // 0x20a5ffff
        instructionMemory[121] = 8'b10100101;
        instructionMemory[122] = 8'b11111111;
        instructionMemory[123] = 8'b11111111;

        instructionMemory[124] = 8'b00010100; // 0x14a0fffc
        instructionMemory[125] = 8'b10100000;
        instructionMemory[126] = 8'b11111111;
        instructionMemory[127] = 8'b11111100;

        instructionMemory[128] = 8'b00100000; // 0x20840004
        instructionMemory[129] = 8'b10000100;
        instructionMemory[130] = 8'b00000000;
        instructionMemory[131] = 8'b00000100;

        instructionMemory[132] = 8'b00000011; // 0x03e00008
        instructionMemory[133] = 8'b11100000;
        instructionMemory[134] = 8'b00000000;
        instructionMemory[135] = 8'b00001000;

        instructionMemory[136] = 8'b00000000; // 0x00081000
        instructionMemory[137] = 8'b00001000;
        instructionMemory[138] = 8'b00010000;
        instructionMemory[139] = 8'b00000000;
    end
    
    always @(*) begin
        // Fetch instruction given address, loading each individual byte
        loadedInstruction[31:24] = instructionMemory[address];
        loadedInstruction[23:16] = instructionMemory[address+1];
        loadedInstruction[15:8] = instructionMemory[address+2];
        loadedInstruction[7:0] = instructionMemory[address+3];
    end
endmodule
