`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 03:16:02 PM
// Design Name: 
// Module Name: rw_96x8_sync
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


module rw_96x8_sync(
    output reg [7:0] data_out,
    input wire [7:0] address, data_in,
    input wire write, clock
    );
    
    reg [7:0] RW [128:223];
    reg EN;
    
    always @(address) begin
        if ((address >= 128) && (address <= 223))
            EN = 1'b1;
        else
            EN = 1'b0;
    end
    
    always @(posedge clock) begin
//        EN <= ((address >= 128) && (address <= 223));
        if (write && EN)
            RW[address] <= data_in;
        else if (!write && EN)
            data_out <= RW[address];
    end
    
endmodule
