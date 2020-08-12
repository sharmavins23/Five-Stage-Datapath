`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Arithmetic Logic Unit
// Instruction Stage: Execution
//
// Description: Performs all (six) MIPS architecture arithmetic and logical
//              operations.
////////////////////////////////////////////////////////////////////////////////


module ArithmeticLogicUnit(
    // Inputs
    input [3:0] aluControl,
    input [31:0] a,
    input [31:0] b,
    // Outputs
    output reg [31:0] out
    );

    always @(*) begin
        // ALU control bits specify the function
        case(aluControl)
            4'bx000: // ADD
                out = a + b;
            4'bx100: // SUB
                out = a - b;
            4'bx001: // AND
                out = a & b;
            4'bx101: // OR
                out = a | b;
            4'bx010: // XOR
                out = a ^ b;
            4'bx110: // LUI
                out = b << 16;
            4'b0011: // SLL
                out = b << a;
            4'b0111: // SRL
                out = b >> a;
            4'b1111: // SRA
                out = b >>> a;
        endcase
    end
endmodule
