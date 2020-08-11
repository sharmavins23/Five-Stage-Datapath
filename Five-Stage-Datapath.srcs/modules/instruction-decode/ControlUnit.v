`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Control Unit
// Instruction Stage: Instruction Decode
//
// Description: Determines which MIPS instruction is being processed, and
//              outputs corresponding signals into other portions of the
//              datapath. Contains the control unit for the arithmetic logic
//              unit as well.
//              The control unit also calculates stalls and forwarding enable
//              signals in order to prevent hazards in instruction execution.
////////////////////////////////////////////////////////////////////////////////

// RegisterWrite and memoryWrite signals are semi redundant, and might be simplified?
// Opcode could also be passed through pipelines to simplify stall calculation.
module ControlUnit(
    // Inputs
    input [5:0] opCode,                 // Instruction signals
    input [5:0] funct,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] mregisterNumber,        // Memory access signals
    input mmemoryToRegister,
    input mregisterWrite,
    input [4:0] eregisterNumber,        // Execution signals
    input ememoryToRegister,
    input eregisterWrite,
    input branchEqualityCheck,
    // Outputs
    output reg stall,                   // Whether there currently is a lw data dependency stall
    output reg [1:0] pcSource,          // NextPCMux selector
    output reg pcWriteEnable,           // Enables pipeline registers PC and IF_ID
    output reg registerWrite,           // Whether data is written out to a register
    output reg memoryToRegister,        // Whether data output to registers is from ALU or memory
    output reg memoryWrite,             // Whether data is written to memory
    output reg jalInstruction,          // Whether the instruction is type jal
    output reg [3:0] aluControl,        // ALU control signals (comprised of ALUOp and ALUControl)
    output reg aluImmediate,            // Whether the instruction uses the immediate section
    output reg shiftInstruction,        // Whether the shift amount is used instead of the loaded register
    output reg destinationRegisterRT,   // Whether the destination register is RT
    output reg signedExtension,         // Whether the immediate value to extend is signed
    output reg [1:0] forwardB,          // ForwardMux selector for input A
    output reg [1:0] forwardA           // ForwardMux selector for input B
    );

    // Signals stating whether rs and rt registers are used
    reg isRSUsed, isRTUsed;

    initial begin
        pcSource = 2'b00; // Select the PC adder
        pcWriteEnable = 1;
    end

    always @(*) begin
        // * MIPS Instruction signal encoding
        case(opCode)
            // r-format ////////////////////////////////////////////////////////
            6'b000000: begin
                // All r-format instructions have the same signals here.
                pcSource = 2'b00;
                registerWrite = 1;
                memoryToRegister = 0;
                memoryWrite = 0;
                jalInstruction = 0;
                aluImmediate = 0;
                destinationRegisterRT = 0;
                signedExtension = 1'bx; // We're not using the extension
                isRSUsed = 1;
                isRTUsed = 1;

                // ALU control is determined based on the funct code.
                case(funct)
                    6'b100000: // add: register add
                        aluControl = 4'bx000;
                    6'b100010: // sub: register subtract
                        aluControl = 4'bx100;
                    6'b100100: // and: register AND
                        aluControl = 4'bx001;
                    6'b100101: // or: register OR
                        aluControl = 4'bx101;
                    6'b100110: // xor: register XOR
                        aluControl = 4'bx010;
                    6'b000000: // sll: shift left
                        aluControl = 4'b0011;
                    6'b000010: // srl: logical shift right
                        aluControl = 4'b0111;
                    6'b000011: // sra: arithmetic shift right
                        aluControl = 4'b1111;
                    6'b001000: begin // jr: register jump
                        pcSource = 2'b10;
                        aluControl = 4'bxxxx; // Doesn't matter
                    end
                    6'b000000: begin // noop: no operation
                        pcSource = 2'b00;
                        registerWrite = 0;
                        memoryToRegister = 1'bx;
                        memoryWrite = 0;
                        jalInstruction = 0;
                        aluControl = 4'bxxxx; // Doesn't matter
                        aluImmediate = 1'bx;
                        shiftInstruction = 1'bx;
                        destinationRegisterRT = 1'bx;
                        signedExtension = 1'bx;
                        isRSUsed = 0;
                        isRTUsed = 0;
                    end
                endcase
            end
            // i-format ////////////////////////////////////////////////////////
            6'b001000: begin // addi: immediate add
                pcSource = 2'b00;
                registerWrite = 1;
                memoryToRegister = 0;
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bx000; // ADD
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1;
                signedExtension = 1;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            6'b001100: begin // andi: immediate AND
                pcSource = 2'b00;
                registerWrite = 1;
                memoryToRegister = 0;
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bx001; // AND
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1;
                signedExtension = 0;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            6'b001101: begin // ori: immediate OR
                pcSource = 2'b00;
                registerWrite = 1;
                memoryToRegister = 0;
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bx101; // OR
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1;
                signedExtension = 0;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            6'b001110: begin // xori: immediate XOR
                pcSource = 2'b00;
                registerWrite = 1;
                memoryToRegister = 0;
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bx010; // XOR
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1;
                signedExtension = 0;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            6'b100011: begin // lw: load memory word
                pcSource = 2'b00;
                registerWrite = 1;
                memoryToRegister = 1;
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bx000; // ADD
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1;
                signedExtension = 1;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            6'b101011: begin // sw: store memory word
                pcSource = 2'b00;
                registerWrite = 0;
                memoryToRegister = 1'bx;
                memoryWrite = 1;
                jalInstruction = 0;
                aluControl = 4'bx000; // ADD
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1'bx;
                signedExtension = 1;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            6'b000100: begin // beq: branch on equal
                if (branchEqualityCheck) pcSource = 2'b01;
                else pcSource = 2'b00;
                registerWrite = 0;
                memoryToRegister = 1'bx;
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bx010; // XOR
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1'bx;
                signedExtension = 1;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            6'b000101: begin // bne: branch on not equal
                if (~branchEqualityCheck) pcSource = 2'b01;
                else pcSource = 2'b00;
                registerWrite = 0;
                memoryToRegister = 1'bx;
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bx010; // XOR
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1'bx;
                signedExtension = 1;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            6'b001111: begin // lui: load upper immediate
                pcSource = 2'b00;
                registerWrite = 1;
                memoryToRegister = 1; // In textbook, this is inaccurate
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bx110; // LUI
                aluImmediate = 1;
                shiftInstruction = 0;
                destinationRegisterRT = 1;
                signedExtension = 0;
                isRSUsed = 1;
                isRTUsed = 1;
            end
            // j-format ////////////////////////////////////////////////////////
            6'b000010: begin // j: jump
                pcSource = 2'b11;
                registerWrite = 0;
                memoryToRegister = 1'bx;
                memoryWrite = 0;
                jalInstruction = 0;
                aluControl = 4'bxxxx; // Don't care
                aluImmediate = 1'bx;
                shiftInstruction = 0;
                destinationRegisterRT = 1'bx;
                signedExtension = 1'bx;
                isRSUsed = 0;
                isRTUsed = 0;
            end
            6'b000011: begin // jal: jump and link (call)
                pcSource = 2'b11;
                registerWrite = 0;
                memoryToRegister = 1'bx;
                memoryWrite = 0;
                jalInstruction = 1;
                aluControl = 4'bxxxx; // Don't care
                aluImmediate = 1'bx;
                shiftInstruction = 0;
                destinationRegisterRT = 1'bx;
                signedExtension = 1'bx;
                isRSUsed = 0;
                isRTUsed = 0;
            end
        endcase

        // * Stall calculation
        // A stall occurs when an instruction uses data loaded from a previous
        //  lw instruction. We can check whether a load word instruction exists
        //  if it writes data to a register and loads that data from memory.
        // An lui instruction should trigger a stall as well.

        // In execution, if load word instruction writes to the current register
        //  rs or rt...
        stall = eregisterWrite & ememoryToRegister & (eregisterNumber != 0) & ((isRSUsed & (eregisterNumber == rs)) | (isRTUsed & (eregisterNumber == rt)));
        // There will be a stall. In which case...
        if (stall) begin
            registerWrite = 0; // Do not write anything to any registers.
            memoryWrite = 0; // Do not write anything to memory.
            pcWriteEnable = 0;
        end else begin
            pcWriteEnable = 1;
        end
        // This 'cancels' our instructions.

        // * Forwarding calculation
        // All other hazards can be worked around using forwarding, or by our
        //  existing implementation of delayed branching and branch slots.

        // Forwarding for ALU input A
        // Default: No forwarding required.
        forwardA = 2'b00;
        // In execution stage, if the register will be written to, and that
        // register is the current RS, and the data isn't memory loaded to RS...
        if (eregisterWrite & ((eregisterNumber != 0) & (eregisterNumber == rs)) & ~ememoryToRegister) begin
            // Forward data from EXE to ALU.
            forwardA = 2'b01;
        end 
        // In memory access stage...
        else if (mregisterWrite & ((mregisterNumber != 0) & (mregisterNumber == rs)) & ~mmemoryToRegister) begin
            // Forward data from MEM to the ALU.
            forwardA = 2'b10;
        end
        // If lw instruction in memory access stage...
        else if (mregisterWrite & ((mregisterNumber != 0) & (mregisterNumber == rs)) & mmemoryToRegister) begin
            // Forward data from Data Memory Out to the ALU.
            forwardA = 2'b11;
        end

        // Forwarding for ALU input B
        // Default: No forwarding required.
        forwardB = 2'b00;
        // In execution stage, if the register will be written to, and that
        // register is the current RT, and the data isn't memory loaded to RT...
        if (eregisterWrite & ((eregisterNumber != 0) & (eregisterNumber == rt)) & ~ememoryToRegister) begin
            // Forward data from EXE to ALU.
            forwardB = 2'b01;
        end 
        // In memory access stage...
        else if (mregisterWrite & ((mregisterNumber != 0) & (mregisterNumber == rt)) & ~mmemoryToRegister) begin
            // Forward data from MEM to the ALU.
            forwardB = 2'b10;
        end
        // If lw instruction in memory access stage...
        else if (mregisterWrite & ((mregisterNumber != 0) & (mregisterNumber == rt)) & mmemoryToRegister) begin
            // Forward data from Data Memory Out to the ALU.
            forwardB = 2'b11;
        end
    end
endmodule
