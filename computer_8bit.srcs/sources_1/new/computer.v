`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 12:23:04 PM
// Design Name: 
// Module Name: computer
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


module computer(
    input wire clock, reset
    );
    
    wire [7:0] address, data_cpu2mem, data_mem2cpu;
    wire write;
    
    cpu CPU(
        .address(address),
        .from_memory(data_mem2cpu),
        .to_memory(data_cpu2mem),
        .clock(clock),
        .reset(reset),
        .write(write)
    );
    
    memory MEMORY(
        .address(address),
        .data_in(data_cpu2mem),
        .data_out(data_mem2cpu),
        .clock(clock),
        .reset(reset),
        .write(write)
    );
    
endmodule
