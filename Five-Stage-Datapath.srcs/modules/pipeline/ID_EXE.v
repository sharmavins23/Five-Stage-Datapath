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
    input jalInstruction,
    input [3:0] aluControl,
    input aluImmediate,
    input aluInShift,
    input [31:0] nextPC,
    input [31:0] registerQA,
    input [31:0] registerQB,
    input [31:0] immediateExtended,
    input [4:0] destination,
    // Outputs
    output reg eregisterWrite,
    output reg ememoryToRegister,
    output reg ememoryWrite,
    output reg ejalInstruction,
    output reg [3:0] ealuControl,
    output reg ealuImmediate,
    output reg ealuInShift,
    output reg [31:0] enextPC,
    output reg [31:0] eregisterQA,
    output reg [31:0] eregisterQB,
    output reg [31:0] eimmediateExtended,
    output reg [4:0] edestination
    );

    always @(posedge clock) begin
        // Assignments in register
        eregisterWrite <= registerWrite;
        ememoryToRegister <= memoryToRegister;
        ememoryWrite <= memoryWrite;
        ejalInstruction <= jalInstruction;
        ealuControl <= aluControl;
        ealuImmediate <= aluImmediate;
        ealuInShift <= aluInShift;
        enextPC <= nextPC;
        eregisterQA <= registerQA;
        eregisterQB <= registerQB;
        eimmediateExtended <= immediateExtended;
        edestination <= destination;
    end
endmodule
