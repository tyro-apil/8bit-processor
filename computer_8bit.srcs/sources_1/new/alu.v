`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 05:44:10 PM
// Design Name: 
// Module Name: alu
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


module alu(
    output reg [7:0] Result,
    output reg [3:0] NZVC,
    input wire [7:0] In1, In2,
    input wire [2:0] ALU_Sel
    );
    
    
    always @(In1, In2, ALU_Sel) begin
        case (ALU_Sel)
            3'b000: begin
                {NZVC[0], Result} = In1 + In2;
                
                NZVC[3] = Result[7];
                
                if (Result == 0)
                    NZVC[2] = 1;
                else
                    NZVC[2] = 0;
                
                //--Two's Comp Overflow Flag 
                if ( ((In1[7]==0) && (In2[7]==0) && (Result[7] == 1)) || 
                ((In1[7]==1) && (In2[7]==1) && (Result[7] == 0)) ) 
                    NZVC[1] = 1; 
                else 
                    NZVC[1] = 0; 
                end
            
            3'b001: begin
                {NZVC[0], Result} = In1 - In2;
                
                NZVC[3] = Result[7];
                
                if (Result == 0)
                    NZVC[2] = 1;
                else
                    NZVC[2] = 0;
                
                //--Two's Comp Overflow Flag 
                if ( ((In1[7]==0) && (In2[7]==1) && (Result[7] == 1)) || 
                ((In1[7]==1) && (In2[7]==0) && (Result[7] == 0)) ) 
                    NZVC[1] = 1; 
                else 
                    NZVC[1] = 0; 
                end
            
            3'b010: begin
            
                Result = In1 & In2;
                NZVC[0] = 0;
                NZVC[1] = 0;
                NZVC[3] = Result[7]; 
                NZVC[2] = (Result == 0) ? 1 : 0; 
                
                end
                
            3'b011: begin
            
                Result = In1 | In2;
                NZVC[0] = 0;
                NZVC[1] = 0;
                NZVC[3] = Result[7]; 
                NZVC[2] = (Result == 0) ? 1 : 0; 
                
                end
                   
            
            default: begin
                Result = 8'hXX;
                NZVC = 4'hX;
                end
        endcase      
    end
    
endmodule
