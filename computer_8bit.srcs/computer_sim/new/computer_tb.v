`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2025 11:42:41 AM
// Design Name: 
// Module Name: computer_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module computer_tb;

    // Inputs
    reg clock;
    reg reset;
    
    // Instantiate the Unit Under Test (UUT)
    computer uut (
        .clock(clock),
        .reset(reset)
    );
    
    // Clock generation
    always begin
        #5 clock = ~clock;
    end
    
    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Release reset
        reset = 1;
        
        // Run for enough cycles to execute all instructions
        // Each instruction takes several clock cycles to complete
        // Let's allow 100 clock cycles (20ns each) = 2000ns
        #2000;
        
        // End simulation
        $display("Test completed");
        $finish;
    end
    
    // Monitor memory writes to observe results
    always @(posedge clock) begin
        if (uut.MEMORY.write && uut.MEMORY.address == 8'h80) begin
            $display("Memory write detected at address 80h: Data = %h", uut.MEMORY.data_in);
            $display("Expected result of AA + 55 = FF");
        end
    end
    
endmodule

