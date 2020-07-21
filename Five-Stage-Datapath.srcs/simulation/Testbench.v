`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Testbench
//
// Description: Major simulation module. As the simulation module, this is the
//              highest level layer.
////////////////////////////////////////////////////////////////////////////////


module Testbench();
    // Wire instantiation //////////////////////////////////////////////////////

    // Program Counter
    reg enable;
    wire clockSignal;
    assign clock = clockSignal && enable;
    wire [31:0] currentPC;
    
    // Instruction Fetch
    wire [31:0] savedInstruction;

    // Instruction Decode
    wire eregisterWrite;
    wire ememoryToRegister;
    wire ememoryWrite;
    wire [3:0] ealuControl;
    wire ealuImmediate;
    wire [4:0] edestination;
    wire [31:0] eregisterQA;
    wire [31:0] eregisterQB;
    wire [31:0] eimmediateExtended;

    // Execution
    wire mregisterWrite;
    wire mmemoryToRegister;
    wire mmemoryWrite;
    wire [4:0] mdestination;
    wire [31:0] maluOut;
    wire [31:0] mloadedRegister;

    // Module instantiation ////////////////////////////////////////////////////

    Clock Clock(clockSignal);
    Datapath Datapath(
        clock,
        currentPC,
        savedInstruction,
        eregisterWrite,
        ememoryToRegister,
        ememoryWrite,
        ealuControl,
        ealuImmediate,
        edestination,
        eregisterQA,
        eregisterQB,
        eimmediateExtended,
        mregisterWrite,
        mmemoryToRegister,
        mmemoryWrite,
        mdestination,
        maluOut,
        mloadedRegister
        );
    
    initial begin
        enable = 1; // Enable signal on clock

        #5; // Positive edge of the first clock cycle //////////////////////////
            // First instruction enters Instruction Fetch

        #10; // Positive edge of the second clock cycle ////////////////////////
            // First instruction enters Instruction Decode
            // Second instruction enters Instruction Fetch

        #10; // Positive edge of the third clock cycle /////////////////////////
            // Second instruction enters Instruction Decode

        #10; // Positive edge of the fourth clock cycle ////////////////////////
            // All instructions have completed current processing.

        #15; // Positive edge of the fifth clock cycle /////////////////////////
        
        enable = 0; // Stop clock motion
    end
endmodule
