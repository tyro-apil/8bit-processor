`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/24/2025 08:30:00 AM
// Design Name:
// Module Name: computer_tb
// Project Name: 8-bit Computer
// Target Devices:
// Tool Versions:
// Description: Testbench for the 8-bit computer module.
//
// Dependencies:
//   - alu.v
//   - control_unit.v
//   - cpu.v
//   - datapath.v
//   - memory.v
//   - rom_128x8_sync.v
//   - rw_96x8_sync.v
//   - computer.v (Top-level module)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   This testbench provides clock and reset signals to the 'computer' module.
//   It monitors various internal signals to verify the computer's operation.
//   The ROM in rom_128x8_sync.v contains the program for the CPU.
//   The memory.v module handles RAM and I/O.
//////////////////////////////////////////////////////////////////////////////////

module computer_tb();

    // -------------------------------------------------------------------------
    // Testbench Signals
    // Declare reg for signals that will drive inputs to the DUT
    // Declare wire for signals that are outputs from the DUT or internal wires
    // that we want to observe.
    // -------------------------------------------------------------------------
    reg clock;
    reg reset;

    // -------------------------------------------------------------------------
    // Parameters
    // Define clock period for easy modification
    // -------------------------------------------------------------------------
    parameter CLOCK_PERIOD = 10; // 10ns period, 100MHz clock

    // -------------------------------------------------------------------------
    // Instantiate the Device Under Test (DUT)
    // Connect the testbench signals to the DUT's ports (if any).
    // Since 'computer' module has no explicit ports, we connect directly
    // to its internal wires for observation if needed, but for basic
    // simulation, just instantiating it is enough.
    // -------------------------------------------------------------------------
    computer DUT(
    .clock(clock),
    .reset(reset)
    ); // Instantiate the top-level computer module

    // -------------------------------------------------------------------------
    // Clock Generation
    // An always block to generate a continuous clock signal
    // -------------------------------------------------------------------------
    always begin
        #(CLOCK_PERIOD / 2) clock = ~clock; // Toggle clock every half period
    end

    // -------------------------------------------------------------------------
    // Initial Block - Test Stimulus and Monitoring
    // This block runs once at the beginning of the simulation.
    // -------------------------------------------------------------------------
    initial begin
        // Initialize signals
        clock = 0;
        reset = 1; // Assert reset initially

        // ---------------------------------------------------------------------
        // Dump waveforms for simulation analysis
        // This is crucial for debugging in Vivado's waveform viewer.
        // You can specify the hierarchy level to dump.
        // For example, to dump all signals in the 'computer' module and its sub-modules:
        // $dumpvars(0, DUT);
        // Or to dump specific signals:
        // $dumpvars(0, DUT.CPU.DP.PC, DUT.CPU.DP.A, DUT.CPU.DP.B, DUT.MEMORY.port_out_00);
        // ---------------------------------------------------------------------
//        $dumpfile("computer_tb.vcd"); // Specify the VCD file name
//        $dumpvars(0, DUT);             // Dump all signals in the DUT hierarchy

        // ---------------------------------------------------------------------
        // Apply Reset Pulse
        // Hold reset for a few clock cycles to ensure proper initialization
        // ---------------------------------------------------------------------
        #(CLOCK_PERIOD * 2) reset = 0; // De-assert reset after 2 clock cycles

        // ---------------------------------------------------------------------
        // Run Simulation
        // Let the computer run for a certain number of clock cycles.
        // The number of cycles depends on the program loaded in your ROM.
        // You might need to adjust this based on the complexity of your program.
        // ---------------------------------------------------------------------
        #(CLOCK_PERIOD * 100); // Run for 100 clock cycles (adjust as needed)

        // ---------------------------------------------------------------------
        // Display final state or specific messages
        // ---------------------------------------------------------------------
        $display("Simulation finished at time %0t", $time);

        // ---------------------------------------------------------------------
        // Terminate Simulation
        // ---------------------------------------------------------------------
        $finish;
    end

    // -------------------------------------------------------------------------
    // Monitoring Internal Signals (Optional but highly recommended)
    // Use $monitor to display values whenever any of the listed signals change.
    // This provides a text-based trace of execution.
    // Alternatively, rely solely on waveform viewing for detailed analysis.
    // -------------------------------------------------------------------------
    initial begin
        $monitor("Time: %0t | PC: %h | IR: %h | A: %h | B: %h | CCR: %h",
                 $time,
                 DUT.CPU.DP.PC, // Accessing PC from Datapath
                 DUT.CPU.DP.IR, // Accessing IR from Datapath
                 DUT.CPU.DP.A,  // Accessing Register A from Datapath
                 DUT.CPU.DP.B,  // Accessing Register B from Datapath
                 DUT.CPU.DP.CCR_Result, // Accessing CCR from Datapath
                );
    end

endmodule
