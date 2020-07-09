`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Clock
//
// Description: Module that outputs an inverting high/low clock signal.
////////////////////////////////////////////////////////////////////////////////


module Clock(
    // Outputs
    output reg signal
    );
    
    initial begin
        signal <= 0; // Assign our initial clock value 
    end
    
    always begin
        #5; // One clock cycle takes 10ns.
        signal = ~signal;
    end
endmodule
