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
     
    reg [7:0] ROM [0:127];
    reg EN;

    initial begin
        $readmemh("rom_contents.mem", ROM);
    end

    always @(address) begin
        if ((address >= 0) && (address <= 127))
            EN = 1'b1;
        else
            EN = 1'b0;
    end
    
    always @(posedge clock) begin
//        EN <= ((address >= 0) && (address <= 127));
        if (EN)
            data_out <= ROM[address];
    end
    
endmodule
