`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Testbench
//
// Description: Major simulation module. As the simulation module, this is the
//              highest level layer.
////////////////////////////////////////////////////////////////////////////////


module Testbench();
    // Wire instantiation
    wire clock;
    wire [31:0] currentPC;
    wire [31:0] savedInstruction;
    // Module instantiation
    Clock Clock(clock);
    Datapath Datapath(
        clock,
        currentPC,
        savedInstruction
        );
    
    initial begin
        #5; // Positive edge of the first clock cycle //////////////////////////
    end
endmodule
