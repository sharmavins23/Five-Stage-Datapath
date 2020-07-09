`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Testbench
//
// Description: Major simulation module. As the simulation module, this is the
//              highest level layer.
////////////////////////////////////////////////////////////////////////////////


module Testbench();
    // Wire instantiation
    wire clockSignal;
    // Module instantiation
    Clock Clock(clockSignal);

    initial begin
        #5; // Positive edge of the first clock cycle //////////////////////////
    end
endmodule
