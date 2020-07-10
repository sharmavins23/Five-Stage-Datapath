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
    // Module instantiation
    Clock Clock(clock);
    Datapath Datapath(clock, currentPC);

    initial begin
        #5; // Positive edge of the first clock cycle //////////////////////////
    end
endmodule
