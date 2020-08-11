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
    wire stall;
    wire eregisterWrite;
    wire ememoryToRegister;
    wire ememoryWrite;
    wire ejalInstruction;
    wire [3:0] ealuControl;
    wire ealuImmediate;
    wire eshiftRegister;
    wire [31:0] enextPC;
    wire [31:0] eregisterQA;
    wire [31:0] eregisterQB;
    wire [31:0] eimmediateExtended;
    wire [4:0] edestination;

    // Execution
    wire mregisterWrite;
    wire mmemoryToRegister;
    wire mmemoryWrite;
    wire [31:0] maluOut;
    wire [31:0] mloadedRegister;
    wire [4:0] mdestination;

    // Memory Access
    wire wregisterWrite;
    wire wmemoryToRegister;
    wire [31:0] wloadedData;
    wire [31:0] waluOut;
    wire [4:0] wdestination;

    // Write Back
    wire [31:0] wDataWritten;

    // Module instantiation ////////////////////////////////////////////////////

    Clock Clock(clockSignal);
    Datapath Datapath(
        clock,
        currentPC,
        savedInstruction,
        stall,
        eregisterWrite,
        ememoryToRegister,
        ememoryWrite,
        ejalInstruction,
        ealuControl,
        ealuImmediate,
        eshiftRegister,
        enextPC,
        eregisterQA,
        eregisterQB,
        eimmediateExtended,
        edestination,
        mregisterWrite,
        mmemoryToRegister,
        mmemoryWrite,
        maluOut,
        mloadedRegister,
        mdestination,
        wregisterWrite,
        wmemoryToRegister,
        wloadedData,
        waluOut,
        wdestination,
        wDataWritten
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
            // First instruction enters Memory Access
            // Second instruction enters Execution
            // Third instruction enters Instruction Decode
            // Fourth instruction enters Instruction Fetch

        #10; // Positive edge of the fifth clock cycle /////////////////////////
            // First instruction enters Write Back
            // Second instruction enters Memory Access
            // Third instruction enters Execution
            // Fourth instruction enters Instruction Decode
            // Fifth instruction enters Instruction Fetch

        #10; // Positive edge of the sixth clock cycle /////////////////////////
            // First instruction has completed.
            // Second instruction enters Write Back
            // Third instruction enters Memory Access
            // Fourth instruction enters Execution
            // Fifth instruction enters Instruction Decode
        
        #10; // Positive edge of the seventh clock cycle ///////////////////////
            // Second instruction has completed.
            // Third instruction enters Write Back
            // Fourth instruction enters Memory Access
            // Fifth instruction enters Execution

        #10; // Positive edge of the eighth clock cycle ////////////////////////
            // Third instruction has completed.
            // Fourth instruction enters Write Back
            // Fifth instruction enters Memory Access

        #10; // Positive edge of the ninth clock cycle /////////////////////////
            // Fourth instruction has completed.
            // Fifth instruction enters Write Back
        
        #10; // Positive edge of the tenth clock cycle /////////////////////////
            // All instructions have completed.
        
        #5;
        enable = 0; // Stop clock motion
    end
endmodule
