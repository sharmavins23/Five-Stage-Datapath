`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Control Unit
// Instruction Stage: Instruction Decode
//
// Description: Determines which MIPS instruction is being processed, and
//              outputs corresponding signals into other portions of the
//              datapath. Contains the control unit for the arithmetic logic
//              unit as well.
////////////////////////////////////////////////////////////////////////////////


module ControlUnit(
    // Inputs
    input [5:0] opCode,
    input [5:0] funct,
    // Outputs
    output reg registerWrite,
    output reg memoryToRegister,
    output reg memoryWrite,
    output reg [3:0] aluControl,
    output reg aluImmediate,
    output reg destinationRegisterRT
    );

    always @(*) begin
        case(opCode)
            // r-format ////////////////////////////////////////////////////////
            6'b000000: begin
                // All r-format instructions have the same signals here.
                registerWrite = 1;
                memoryToRegister = 0;
                memoryWrite = 0;
                aluImmediate = 0;
                destinationRegisterRT = 0;

                // ALU control is determined based on the funct code.
                case(funct)
                    6'b100000: // add: register add
                        aluControl = 4'b0010;
                    6'b100010: // sub: register subtract
                        aluControl = 4'b0110;
                    6'b100100: // and: register AND
                        aluControl = 4'b0000;
                    6'b100101: // or: register OR
                        aluControl = 4'b0001;
                    6'b100110: // xor: register XOR
                        aluControl = 4'bxxxx;
                    6'b000000: // sll: shift left
                        aluControl = 4'bxxxx;
                    6'b000010: // srl: logical shift right
                        aluControl = 4'bxxxx;
                    6'b000011: // sra: arithmetic shift right
                        aluControl = 4'bxxxx;
                    6'b001000: // jr: register jump
                        aluControl = 4'bxxxx;
                endcase
            end
            // i-format ////////////////////////////////////////////////////////
            6'b001000: begin // addi: immediate add
            end
            6'b001100: begin // andi: immediate AND
            end
            6'b001101: begin // ori: immediate OR
            end
            6'b001110: begin // xori: immediate XOR
            end
            6'b100011: begin // lw: load memory word
                registerWrite = 1;
                memoryToRegister = 1;
                memoryWrite = 0;
                aluControl = 4'b0010;
                aluImmediate = 1;
                destinationRegisterRT = 1;
            end
            6'b101011: begin // sw: store memory word
                registerWrite = 0;
                memoryToRegister = 1'bx;
                memoryWrite = 1;
                aluControl = 4'b0010;
                aluImmediate = 1;
                destinationRegisterRT = 1'bx;
            end
            6'b000100: begin // beq: branch on equal
                registerWrite = 0;
                memoryToRegister = 1'bx;
                memoryWrite = 0;
                aluControl = 4'b0110;
                aluImmediate = 1;
                destinationRegisterRT = 1'bx;
            end
            6'b000101: begin // bne: branch on not equal
            end
            6'b001111: begin // lui: load upper immediate
            end
            // j-format ////////////////////////////////////////////////////////
            6'b000010: begin // j: jump
            end
            6'b000011: begin // jal: jump and link (call)
            end
        endcase
    end
endmodule
