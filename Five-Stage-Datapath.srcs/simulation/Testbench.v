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
            // First instruction enters Execution
            // Second instruction enters Instruction Decode
            // Third instruction enters Instruction Fetch

        #10; // Positive edge of the fourth clock cycle ////////////////////////
            // First instruction has completed.
            // Second instruction enters Execution
            // Third instruction enters Instruction Decode
            // Fourth instruction enters Instruction Fetch

        #10; // Positive edge of the fifth clock cycle /////////////////////////
            // Second instruction has completed.
            // Third instruction enters Execution
            // Fourth instruction enters Instruction Decode

        #10; // Positive edge of the sixth clock cycle /////////////////////////
            // Third instruction has completed.
            // Fourth instruction enters Execution
        
        #10; // Positive edge of the seventh clock cycle ///////////////////////
            // All instructions have completed.
        
        #5;
        enable = 0; // Stop clock motion
    end
endmodule
