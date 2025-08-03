`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2025 11:23:56 AM
// Design Name: 
// Module Name: memory_tb
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


module memory_tb;

    // Inputs
    reg [7:0] address;
    reg [7:0] data_in;
    reg clock;
    reg reset;
    reg write;

    // Outputs
    wire [7:0] data_out;
    wire [7:0] port_out_00, port_out_01, port_out_02, port_out_03, port_out_04,
                     port_out_05, port_out_06, port_out_07, port_out_08, port_out_09,
                     port_out_10, port_out_11, port_out_12, port_out_13, port_out_14,
                     port_out_15;

    // Instantiate the memory module
    memory uut (
        .data_out(data_out),
        .port_out_00(port_out_00),
        .port_out_01(port_out_01),
        .port_out_02(port_out_02),
        .port_out_03(port_out_03),
        .port_out_04(port_out_04),
        .port_out_05(port_out_05),
        .port_out_06(port_out_06),
        .port_out_07(port_out_07),
        .port_out_08(port_out_08),
        .port_out_09(port_out_09),
        .port_out_10(port_out_10),
        .port_out_11(port_out_11),
        .port_out_12(port_out_12),
        .port_out_13(port_out_13),
        .port_out_14(port_out_14),
        .port_out_15(port_out_15),
        .address(address),
        .data_in(data_in),
        .port_in_00(8'h00), // Connect unused port_in to avoid X's
        .port_in_01(8'h00),
        .port_in_02(8'h00),
        .port_in_03(8'h00),
        .port_in_04(8'h00),
        .port_in_05(8'h00),
        .port_in_06(8'h00),
        .port_in_07(8'h00),
        .port_in_08(8'h00),
        .port_in_09(8'h00),
        .port_in_10(8'h00),
        .port_in_11(8'h00),
        .port_in_12(8'h00),
        .port_in_13(8'h00),
        .port_in_14(8'h00),
        .port_in_15(8'h00),
        .clock(clock),
        .reset(reset),
        .write(write)
    );

    // Clock generation
    always #5 clock = ~clock;

    initial begin
        // Initialize inputs
        clock = 0;
        reset = 1;
        write = 0;
        address = 8'h00;
        data_in = 8'h00;

        // Reset the memory
        reset = 0;
        #10;
        reset = 1;
        #10;

        // Test ROM read (address 0 to 127)
        // ROM[0] = LDA_IMM (8'h86)
        address = 8'h00;
        write = 0;
        #10;

        // ROM[1] = 8'hAA
        address = 8'h01;
        #10;

        // Test RAM write and read (address 128 to 223)
        // Write to address 128
        address = 8'h80; // 128 decimal
        data_in = 8'h55;
        write = 1;
        #10;

        // Read from address 128
        write = 0;
        #10;

        // Write to address 129
        address = 8'h81; // 129 decimal
        data_in = 8'hAA;
        write = 1;
        #10;

        // Read from address 129
        write = 0;
        #10;

        $finish; // End simulation
    end

    // Monitor outputs (optional, for debugging)
    initial begin
        $monitor("Time=%0t | Addr=%h, Data_in=%h, Write=%b | Data_out=%h",
                 $time, address, data_in, write, data_out);
    end

endmodule

