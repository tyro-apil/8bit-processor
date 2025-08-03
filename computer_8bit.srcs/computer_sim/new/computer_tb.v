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

    // Declare testbench signals
    reg clock;
    reg reset;

    // Instantiate the Device Under Test (DUT) - the top-level 'computer' module
    computer DUT (
        .clock(clock),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever begin
            #5 clock = ~clock;
        end
    end

    // Initial block for stimulus generation
    initial begin
        // Initialize signals
        reset = 1;    

        // Apply reset sequence
        #5; 
        reset = 0;

        // Monitor signals (you can add more signals to monitor as needed)
        // This example monitors the CPU's address and data_cpu2mem, and the memory's data_out
        $monitor("Time=%0t | Reset=%b | Clock=%b | CPU_Address=%h | CPU_To_Memory=%h | MEM_Data_Out=%h | IR=%h | A=%h | B=%h | NZVC=%b", 
                 $time, reset, clock, DUT.CPU.address, DUT.CPU.to_memory, DUT.MEMORY.data_out, 
                 DUT.CPU.DP.IR, DUT.CPU.DP.A, DUT.CPU.DP.B, DUT.CPU.DP.CCR_Result);

        // Add specific test scenarios here
        // For example, let the processor run for a certain number of clock cycles
        #500;

        // End simulation
        $finish;
    end

endmodule

