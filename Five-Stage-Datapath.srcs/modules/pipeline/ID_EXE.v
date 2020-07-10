`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Instruction Decode/Execution Stage Pipeline Register
// Instruction Stage: Pipeline Register
//
// Description: Pipeline register between stages 2 and 3 of the datapath. Passes
//              through most control unit signals, as well as destination signal
//              chosen, immediate sign extension signals, and loaded registry
//              values.
////////////////////////////////////////////////////////////////////////////////


module ID_EXE(
    // Inputs
    input clock,
    input registerWrite,
    input memoryToRegister,
    input memoryWrite,
    input [3:0] aluControl,
    input aluImmediate,
    input [4:0] destination,
    input [31:0] registerQA,
    input [31:0] registerQB,
    input [31:0] immediateExtended,
    // Outputs
    output reg eregisterWrite,
    output reg ememoryToRegister,
    output reg ememoryWrite,
    output reg [3:0] ealuControl,
    output reg ealuImmediate,
    output reg [4:0] edestination,
    output reg [31:0] eregisterQA,
    output reg [31:0] eregisterQB,
    output reg [31:0] eimmediateExtended
    );

    always @(posedge clock) begin
        // Assignments in register
        eregisterWrite <= registerWrite;
        ememoryToRegister <= memoryToRegister;
        ememoryWrite <= memoryWrite;
        ealuControl <= aluControl;
        ealuImmediate <= aluImmediate;
        edestination <= destination;
        eregisterQA <= registerQA;
        eregisterQB <= registerQB;
        eimmediateExtended <= immediateExtended;
    end
endmodule
