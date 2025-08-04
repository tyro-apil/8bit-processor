`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 12:22:48 PM
// Design Name: 
// Module Name: cpu
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


module cpu(
    output wire [7:0] address, to_memory,
    output wire write,
    input wire [7:0] from_memory,
    input wire clock, reset
    );
    
    wire IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load;
    wire [1:0] Bus1_Sel, Bus2_Sel;
    wire [2:0] ALU_Sel;
    wire [3:0] CCR_Result;
    wire [7:0] IR;
    
    control_unit CU(
        .IR(IR),
        .CCR_Result(CCR_Result),
        .ALU_Sel(ALU_Sel),
        .clock(clock),
        .reset(reset),
        .Bus1_Sel(Bus1_Sel),
        .Bus2_Sel(Bus2_Sel),
        .IR_Load(IR_Load),
        .MAR_Load(MAR_Load),
        .PC_Load(PC_Load),
        .PC_Inc(PC_Inc),
        .A_Load(A_Load),
        .B_Load(B_Load),
        .CCR_Load(CCR_Load),
        .write(write)
    );
    
    datapath DP(
        .address(address),
        .to_memory(to_memory),
        .IR(IR),
        .CCR_Result(CCR_Result),
        .from_memory(from_memory),
        .ALU_Sel(ALU_Sel),
        .clock(clock),
        .reset(reset),
        .Bus1_Sel(Bus1_Sel),
        .Bus2_Sel(Bus2_Sel),
        .IR_Load(IR_Load),
        .MAR_Load(MAR_Load),
        .PC_Load(PC_Load),
        .PC_Inc(PC_Inc),
        .A_Load(A_Load),
        .B_Load(B_Load),
        .CCR_Load(CCR_Load)
    );
    
endmodule
