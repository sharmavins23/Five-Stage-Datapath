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
        // Verilog Assignment       Binary          Label   MIPS    Parameters
        instructionMemory[000] = 8'b00111100; // 0x3c010000
        instructionMemory[001] = 8'b00000001; //    main:   lui     $1, 0
        instructionMemory[002] = 8'b00000000; //                    at
        instructionMemory[003] = 8'b00000000; // (00)

        instructionMemory[004] = 8'b00110100; // 0x34240050
        instructionMemory[005] = 8'b00100100; //            ori     $4, $1, 80
        instructionMemory[006] = 8'b00000000; //                    a0  at
        instructionMemory[007] = 8'b01010000; // (04)

        instructionMemory[008] = 8'b00001100; // 0x0c00001b
        instructionMemory[009] = 8'b00000000; //    call:   jal     sum
        instructionMemory[010] = 8'b00000000;
        instructionMemory[011] = 8'b00011011; // (08)

        instructionMemory[012] = 8'b00100000; // 0x20050004
        instructionMemory[013] = 8'b00000101; //    dslot1: addi    $5, $0, 4
        instructionMemory[014] = 8'b00000000; //                    a1
        instructionMemory[015] = 8'b00000100; // (0c)

        instructionMemory[016] = 8'b10101100; // 0xac820000
        instructionMemory[017] = 8'b10000010; //    return: sw      $2, 0 ($4) 
        instructionMemory[018] = 8'b00000000; //                    v0     a0
        instructionMemory[019] = 8'b00000000; // (10)

        instructionMemory[020] = 8'b10001100; // 0x8c890000
        instructionMemory[021] = 8'b10001001; //            lw      $9, 0 ($4)
        instructionMemory[022] = 8'b00000000; //                    t1     a0
        instructionMemory[023] = 8'b00000000; // (14)

        instructionMemory[024] = 8'b00000001; // 0x01244022
        instructionMemory[025] = 8'b00100100; //            sub     $8, $9, $4
        instructionMemory[026] = 8'b01000000; //                    t0  t1  a0
        instructionMemory[027] = 8'b00100010; // (18)

        instructionMemory[028] = 8'b00100000; // 0x20050003
        instructionMemory[029] = 8'b00000101; //            addi    $5, $0, 3
        instructionMemory[030] = 8'b00000000; //                    a1
        instructionMemory[031] = 8'b00000011; // (1c)

        instructionMemory[032] = 8'b00100000; // 0x20a5ffff
        instructionMemory[033] = 8'b10100101; //    loop2:  addi    $5, $5, -1
        instructionMemory[034] = 8'b11111111; //                    a1  a1
        instructionMemory[035] = 8'b11111111; // (20)

        instructionMemory[036] = 8'b00110100; // 0x34a8ffff
        instructionMemory[037] = 8'b10101000; //            ori     $8, $5, 0xffff
        instructionMemory[038] = 8'b11111111; //                    t0  a1  65535
        instructionMemory[039] = 8'b11111111; // (24)

        instructionMemory[040] = 8'b00111001; // 0x39085555
        instructionMemory[041] = 8'b00001000; //            xori    $8, $8, 0x5555
        instructionMemory[042] = 8'b01010101; //                    t0  t0  21845
        instructionMemory[043] = 8'b01010101; // (28)

        instructionMemory[044] = 8'b00100000; // 0x2009ffff
        instructionMemory[045] = 8'b00001001; //            addi    $9, $0, -1
        instructionMemory[046] = 8'b11111111; //                    t1
        instructionMemory[047] = 8'b11111111; // (2c)

        instructionMemory[048] = 8'b00110001; // 0x312affff
        instructionMemory[049] = 8'b00101010; //            andi    $10, $9, 0xffff
        instructionMemory[050] = 8'b11111111; //                    t2   t1  65535
        instructionMemory[051] = 8'b11111111; // (30)

        instructionMemory[052] = 8'b00000001; // 0x01493025
        instructionMemory[053] = 8'b01001001; //            or      $6, $10, $9
        instructionMemory[054] = 8'b00110000; //                    a2  t2   t1
        instructionMemory[055] = 8'b00100101; // (34)

        instructionMemory[056] = 8'b00000001; // 0x01494026
        instructionMemory[057] = 8'b01001001; //            xor     $8, $10, $9
        instructionMemory[058] = 8'b01000000; //                    t0  t2   t1
        instructionMemory[059] = 8'b00100110; // (38)

        instructionMemory[060] = 8'b00000001; // 0x01463824
        instructionMemory[061] = 8'b01000110; //            and     $7, $10, $6
        instructionMemory[062] = 8'b00111000; //                    a3  t2   a2
        instructionMemory[063] = 8'b00100100; // (3c)

        instructionMemory[064] = 8'b00010000; // 0x10a00003
        instructionMemory[065] = 8'b10100000; //            beq     $5, $0, shift
        instructionMemory[066] = 8'b00000000; //                    a1
        instructionMemory[067] = 8'b00000011; // (40)

        instructionMemory[068] = 8'b00000000; // 0x00000000
        instructionMemory[069] = 8'b00000000; //    dslot2: nop
        instructionMemory[070] = 8'b00000000;
        instructionMemory[071] = 8'b00000000; // (44)

        instructionMemory[072] = 8'b00001000; // 0x08000008
        instructionMemory[073] = 8'b00000000; //            j       loop2
        instructionMemory[074] = 8'b00000000;
        instructionMemory[075] = 8'b00001000; // (48)

        instructionMemory[076] = 8'b00000000; // 0x00000000
        instructionMemory[077] = 8'b00000000; //    dslot3: nop
        instructionMemory[078] = 8'b00000000;
        instructionMemory[079] = 8'b00000000; // (4c)

        instructionMemory[080] = 8'b00100000; // 0x2005ffff
        instructionMemory[081] = 8'b00000101; //    shift:  addi    $5, $0, -1
        instructionMemory[082] = 8'b11111111; //                    a1
        instructionMemory[083] = 8'b11111111; // (50)

        instructionMemory[084] = 8'b00000000; // 0x000543c0
        instructionMemory[085] = 8'b00000101; //            sll     $8, $5, 15
        instructionMemory[086] = 8'b01000011; //                    t0  a1
        instructionMemory[087] = 8'b11000000; // (54)

        instructionMemory[088] = 8'b00000000; // 0x00084400
        instructionMemory[089] = 8'b00001000; //            sll     $8, $8, 16
        instructionMemory[090] = 8'b01000100; //                    t0  t0
        instructionMemory[091] = 8'b00000000; // (58)

        instructionMemory[092] = 8'b00000000; // 0x00084403
        instructionMemory[093] = 8'b00001000; //            sra     $8, $8, 16
        instructionMemory[094] = 8'b01000100; //                    t0  t0
        instructionMemory[095] = 8'b00000011; // (5c)

        instructionMemory[096] = 8'b00000000; // 0x000843c2
        instructionMemory[097] = 8'b00001000; //            srl     $8, $8, 15
        instructionMemory[098] = 8'b01000011; //                    t0  t0
        instructionMemory[099] = 8'b11000010; // (60)

        instructionMemory[100] = 8'b00001000; // 0x08000019
        instructionMemory[101] = 8'b00000000; //    finish: j       finish
        instructionMemory[102] = 8'b00000000;
        instructionMemory[103] = 8'b00011001; // (64)

        instructionMemory[104] = 8'b00000000; // 0x00000000
        instructionMemory[105] = 8'b00000000; //    dslot4: nop
        instructionMemory[106] = 8'b00000000;
        instructionMemory[107] = 8'b00000000; // (68)

        instructionMemory[108] = 8'b00000000; // 0x00004020
        instructionMemory[109] = 8'b00000000; //    sum:    add     $8, $0, $0
        instructionMemory[110] = 8'b01000000; //                    t0
        instructionMemory[111] = 8'b00100000; // (6c)

        instructionMemory[112] = 8'b10001100; // 0x8c890000
        instructionMemory[113] = 8'b10001001; //    loop:   lw      $9, 0($4)
        instructionMemory[114] = 8'b00000000; //                    t1    a0
        instructionMemory[115] = 8'b00000000; // (70)

        instructionMemory[116] = 8'b00000001; // 0x01094020
        instructionMemory[117] = 8'b00001001; //    stall:  add     $8, $8, $9
        instructionMemory[118] = 8'b01000000; //                    t0  t0  t1
        instructionMemory[119] = 8'b00100000; // (74)

        instructionMemory[120] = 8'b00100000; // 0x20a5ffff
        instructionMemory[121] = 8'b10100101; //            addi    $5, $5, -1
        instructionMemory[122] = 8'b11111111; //                    a1  a1
        instructionMemory[123] = 8'b11111111; // (78)

        instructionMemory[124] = 8'b00010100; // 0x14a0fffc
        instructionMemory[125] = 8'b10100000; //            bne     $5, $0, loop
        instructionMemory[126] = 8'b11111111; //                    a1
        instructionMemory[127] = 8'b11111100; // (7c)

        instructionMemory[128] = 8'b00100000; // 0x20840004
        instructionMemory[129] = 8'b10000100; //    dslot5: addi    $4, $4, 4
        instructionMemory[130] = 8'b00000000; //                    a0  a0
        instructionMemory[131] = 8'b00000100; // (80)

        instructionMemory[132] = 8'b00000011; // 0x03e00008
        instructionMemory[133] = 8'b11100000; //            jr      $31
        instructionMemory[134] = 8'b00000000; //                    ra
        instructionMemory[135] = 8'b00001000; // (84)

        instructionMemory[136] = 8'b00000000; // 0x00081000
        instructionMemory[137] = 8'b00001000; //    dslot6: sll     $2, $8, 0
        instructionMemory[138] = 8'b00010000; //                    v0  t0
        instructionMemory[139] = 8'b00000000; // (88)
    end
    
    always @(*) begin
        // Fetch instruction given address, loading each individual byte
        loadedInstruction[31:24] = instructionMemory[address];
        loadedInstruction[23:16] = instructionMemory[address+1];
        loadedInstruction[15:8] = instructionMemory[address+2];
        loadedInstruction[7:0] = instructionMemory[address+3];
    end
endmodule
