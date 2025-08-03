`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2025 09:09:15 AM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb;

    // Inputs
    reg [7:0] In1;
    reg [7:0] In2;
    reg [2:0] ALU_Sel;

    // Outputs
    wire [7:0] Result;
    wire [3:0] NZVC;

    // Instantiate the ALU module
    alu uut (
        .Result(Result),
        .NZVC(NZVC),
        .In1(In1),
        .In2(In2),
        .ALU_Sel(ALU_Sel)
    );

    initial begin
        // Test cases

        // Addition: 5 + 3 = 8, NZVC = 4'b0000 (N=0, Z=0, V=0, C=0)
        In1 = 8'd5;
        In2 = 8'd3;
        ALU_Sel = 3'b000;
        #10;

        // Addition: 127 + 1 = 128 (overflow), NZVC = 4'b1010 (N=1, Z=0, V=1, C=0)
        In1 = 8'd127;
        In2 = 8'd1;
        ALU_Sel = 3'b000;
        #10;

        // Subtraction: 10 - 4 = 6, NZVC = 4'b0000 (N=0, Z=0, V=0, C=0)
        In1 = 8'd10;
        In2 = 8'd4;
        ALU_Sel = 3'b001;
        #10;

        // Subtraction: 5 - 10 = -5 (underflow), NZVC = 4'b1001 (N=1, Z=0, V=0, C=1)
        In1 = 8'd5;
        In2 = 8'd10;
        ALU_Sel = 3'b001;
        #10;

        // AND: 0xF0 & 0x0F = 0x00, NZVC = 4'b0010 (N=0, Z=1, V=0, C=0)
        In1 = 8'hF0;
        In2 = 8'h0F;
        ALU_Sel = 3'b010;
        #10;

        // OR: 0xF0 | 0x0F = 0xFF, NZVC = 4'b1000 (N=1, Z=0, V=0, C=0)
        In1 = 8'hF0;
        In2 = 8'h0F;
        ALU_Sel = 3'b011;
        #10;

        // Default case
        In1 = 8'd0;
        In2 = 8'd0;
        ALU_Sel = 3'b111; // Invalid selection
        #10;

        $finish; // End simulation
    end

    // Monitor outputs (optional, for debugging)
    initial begin
        $monitor("Time=%0t | In1=%h, In2=%h, ALU_Sel=%b | Result=%h, NZVC=%b",
                 $time, In1, In2, ALU_Sel, Result, NZVC);
    end

endmodule

