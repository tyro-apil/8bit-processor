`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 03:16:02 PM
// Design Name: 
// Module Name: rom_128x8_sync
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


module rom_128x8_sync(
    output reg [7:0] data_out,
    input wire [7:0] address,
    input wire clock
    );
    
    parameter LDA_IMM = 8'h86; //-- Load Register A with Immediate Addressing 
    parameter LDA_DIR = 8'h87; //-- Load Register A with Direct Addressing 
    parameter LDB_IMM = 8'h88; //-- Load Register B with Immediate Addressing 
    parameter LDB_DIR = 8'h89; //-- Load Register B with Direct Addressing 
    parameter STA_DIR = 8'h96; //-- Store Register A to memory (RAM or IO) 
    parameter STB_DIR = 8'h97; //-- Store Register B to memory (RAM or IO) 
    parameter ADD_AB = 8'h42; //-- A <= A + B 
    parameter BRA = 8'h20; //-- Branch Always 
    parameter BEQ = 8'h23; //--Branch if Z=1
     
    reg [7:0] ROM [0:127];
    reg EN;
    
    initial
     begin
         ROM[0] = LDA_IMM;
         ROM[1] = 8'hAA;
         ROM[2] = STA_DIR;
         ROM[3] = 8'hE0;
         ROM[4] = BRA;
         ROM[5] = 8'h00;
     end

    always @(address) begin
        if ((address >= 0) && (address <= 127))
            EN = 1'b1;
        else
            EN = 1'b0;
    end
    
    always @(posedge clock) begin
        if (EN)
            data_out <= ROM[address];
    end
    
endmodule
