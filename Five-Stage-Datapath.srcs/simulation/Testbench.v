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
        // There are 35 instructions written into the instruction memory (ROM).

        // If all instructions were running without stalls or hazards, there
        //  would be 4+n clock cycles, where n is the number of instructions.
        // However, each instruction can possibly incur (at most) one stall.
        // The absolute maximum number of clock cycles for this datapath to 
        //  execute all programmed instructions is 3+2n.

        // In this program's case, the absolute maximum number of clock cycles
        //  to execute the program would be 73.
        #730;
        // The program does have looping behavior, so it might possibly compute
        //  more than 35 instructions. However, doubling the amount of
        //  instructions is, for our purposes, a generous estimate.

        #5; // Down to negative edge
        enable = 0; // Stop clock motion
    end
endmodule
