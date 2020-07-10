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
            // i-format ////////////////////////////////////////////////////////
            6'b100011: begin // lw: load word
                registerWrite = 1;
                memoryToRegister = 1;
                memoryWrite = 0;
                aluControl = 4'b0010;
                aluImmediate = 1;
                destinationRegisterRT = 1;
            end
        endcase
    end
endmodule
