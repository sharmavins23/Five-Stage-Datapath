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
            4'b0000: // AND
                out = a & b;
            4'b0001: // OR
                out = a | b;
            4'b0010: // add
                out = a + b;
            4'b0110: // subtract
                out = a - b;
            4'b0111: begin // set on less than
                if (a < b)
                    out = 1;
                else
                    out = 0;
            end
            4'b1100: // NOR
                out = ~(a | b);

        endcase
    end
endmodule
