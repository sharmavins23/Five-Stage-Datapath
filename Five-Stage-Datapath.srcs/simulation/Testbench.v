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
    wire clock;
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

    // Module instantiation ////////////////////////////////////////////////////

    Clock Clock(clock);
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
        eimmediateExtended
        );
    
    initial begin
        #5; // Positive edge of the first clock cycle //////////////////////////
    end
endmodule
