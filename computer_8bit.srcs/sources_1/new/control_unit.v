`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 05:44:46 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    output reg IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write,
    output reg [2:0] ALU_Sel,
    output reg [1:0] Bus1_Sel, Bus2_Sel,
    input wire clock, reset,
    input wire [7:0] IR,
    input wire [3:0] CCR_Result
    );
    
    reg [7:0] current_state, next_state;
    
    // Load and Store Opcodes
    parameter LDA_IMM = 8'h86; // Load Register A using Immediate Addressing
    parameter LDA_DIR = 8'h87; // Load Register A using Direct Addressing
    parameter LDB_IMM = 8'h88; // Load Register B using Immediate Addressing
    parameter LDB_DIR = 8'h89; // Load Register B using Direct Addressing
    parameter STA_DIR = 8'h96; // Store Register A to Memory using Direct Addressing
    parameter STB_DIR = 8'h97; // Store Register B to Memory using Direct Addressing

    // Data Manipulation Opcodes
    parameter ADD_AB  = 8'h42; // A = A + B
    parameter SUB_AB  = 8'h43; // A = A - B
    parameter AND_AB  = 8'h44; // A = A AND B
    parameter OR_AB   = 8'h45; // A = A OR B
    parameter INCA    = 8'h46; // A = A + 1
    parameter INCB    = 8'h47; // B = B + 1
    parameter DECA    = 8'h48; // A = A - 1
    parameter DECB    = 8'h49; // B = B - 1

    // Branch Opcodes
    parameter BRA     = 8'h20; // Branch Always to Address Provided
    parameter BMI     = 8'h21; // Branch to Address Provided if N=1
    parameter BPL     = 8'h22; // Branch to Address Provided if N=0
    parameter BEQ     = 8'h23; // Branch to Address Provided if Z=1
    parameter BNE     = 8'h24; // Branch to Address Provided if Z=0
    parameter BVS     = 8'h25; // Branch to Address Provided if V=1
    parameter BVC     = 8'h26; // Branch to Address Provided if V=0
    parameter BCS     = 8'h27; // Branch to Address Provided if C=1
    parameter BCC     = 8'h28; // Branch to Address Provided if C=0

    // ALU_Sel Definitions
    parameter ALU_ADD_SEL = 3'b000;
    parameter ALU_SUB_SEL = 3'b001;
    parameter ALU_AND_SEL = 3'b010;
    parameter ALU_OR_SEL  = 3'b011;
    parameter ALU_NO_OP   = 3'bXXX;

    // Bus1_Sel Definitions
    parameter BUS1_PC = 2'b00;
    parameter BUS1_A  = 2'b01;
    parameter BUS1_B  = 2'b10;
    parameter BUS1_NO_SEL = 2'bXX;

    // Bus2_Sel Definitions
    parameter BUS2_ALU_RESULT = 2'b00;
    parameter BUS2_BUS1       = 2'b01;
    parameter BUS2_FROM_MEMORY = 2'b10;
    parameter BUS2_NO_SEL     = 2'bXX;
    
    
    // FSM State Definitions
    // Fetch Cycle States
    parameter S_FETCH_0 = 0;  // Put PC onto MAR to provide address of Opcode
    parameter S_FETCH_1 = 1;  // Increment PC
    parameter S_FETCH_2 = 2;  // Load IR from memory (Opcode)
    parameter S_DECODE_3 = 3; // Opcode decode state

    // LDA_IMM (Load A Immediate) states (3 states)
    parameter S_LDA_IMM_4 = 4;  // PC to MAR (address of immediate data)
    parameter S_LDA_IMM_5 = 5;  // Load A from memory, Increment PC
    parameter S_LDA_IMM_6 = 6;  // End of instruction

    // LDA_DIR (Load A Direct) states (6 states)
    parameter S_LDA_DIR_4 = 7;  // PC to MAR (address of direct address)
    parameter S_LDA_DIR_5 = 8;  // Load MAR from memory, Increment PC
    parameter S_LDA_DIR_6 = 9;  // Wait state / internal bus transfer (if needed)
    parameter S_LDA_DIR_7 = 10; // MAR already holds data address, prepare for read
    parameter S_LDA_DIR_8 = 11; // Load A from memory
    parameter S_LDA_DIR_9 = 12; // End of instruction

    // STA_DIR (Store A Direct) states (5 states)
    parameter S_STA_DIR_4 = 13; // PC to MAR (address of direct address)
    parameter S_STA_DIR_5 = 14; // Load MAR from memory, Increment PC
    parameter S_STA_DIR_6 = 15; // Wait state / internal bus transfer
    parameter S_STA_DIR_7 = 16; // Write A to memory
    parameter S_STA_DIR_8 = 17; // End of instruction

    // LDB_IMM (Load B Immediate) states (3 states)
    parameter S_LDB_IMM_4 = 18; // PC to MAR (address of immediate data)
    parameter S_LDB_IMM_5 = 19; // Load B from memory, Increment PC
    parameter S_LDB_IMM_6 = 20; // End of instruction

    // LDB_DIR (Load B Direct) states (6 states)
    parameter S_LDB_DIR_4 = 21; // PC to MAR (address of direct address)
    parameter S_LDB_DIR_5 = 22; // Load MAR from memory, Increment PC
    parameter S_LDB_DIR_6 = 23; // Wait state / internal bus transfer
    parameter S_LDB_DIR_7 = 24; // MAR already holds data address, prepare for read
    parameter S_LDB_DIR_8 = 25; // Load B from memory
    parameter S_LDB_DIR_9 = 26; // End of instruction

    // STB_DIR (Store B Direct) states (5 states)
    parameter S_STB_DIR_4 = 27; // PC to MAR (address of direct address)
    parameter S_STB_DIR_5 = 28; // Load MAR from memory, Increment PC
    parameter S_STB_DIR_6 = 29; // Wait state / internal bus transfer
    parameter S_STB_DIR_7 = 30; // Write B to memory
    parameter S_STB_DIR_8 = 31; // End of instruction

    // BRA (Branch Always) states (3 states)
    parameter S_BRA_4 = 32; // PC to MAR (address of branch target)
    parameter S_BRA_5 = 33; // Load PC from memory
    parameter S_BRA_6 = 34; // End of instruction

    // Conditional Branch states
    parameter S_COND_BR_4 = 35; // PC to MAR (address of branch target)
    parameter S_COND_BR_5 = 36; // Check condition; if true, load PC
    parameter S_COND_BR_6 = 37; // End of instruction

    // Arithmetic/Logic Operation states (2 states each)
    parameter S_ADD_AB_4 = 38; // Perform A+B, set ALU_Sel
    parameter S_ADD_AB_5 = 39; // Load A with result, Load CCR

    parameter S_SUB_AB_4 = 40; // Perform A-B, set ALU_Sel
    parameter S_SUB_AB_5 = 41; // Load A with result, Load CCR

    parameter S_AND_AB_4 = 42; // Perform A&B, set ALU_Sel
    parameter S_AND_AB_5 = 43; // Load A with result, Load CCR

    parameter S_OR_AB_4 = 44; // Perform A|B, set ALU_Sel
    parameter S_OR_AB_5 = 45; // Load A with result, Load CCR

    
    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            current_state <= S_FETCH_0;
        end else begin
            current_state <= next_state;
        end
    end
    
    
    // --- Next State Logic ---
    always @(current_state, IR, CCR_Result) begin: NEXT_STATE_LOGIC
        case (current_state)
            S_FETCH_0: next_state = S_FETCH_1;
            S_FETCH_1: next_state = S_FETCH_2;
            S_FETCH_2: next_state = S_DECODE_3;
            
            S_DECODE_3: begin
                case (IR)
                    LDA_IMM: next_state = S_LDA_IMM_4;
                    LDA_DIR: next_state = S_LDA_DIR_4;
                    LDB_IMM: next_state = S_LDB_IMM_4;
                    LDB_DIR: next_state = S_LDB_DIR_4;
                    STA_DIR: next_state = S_STA_DIR_4;
                    STB_DIR: next_state = S_STB_DIR_4;

                    ADD_AB:  next_state = S_ADD_AB_4;
                    SUB_AB:  next_state = S_SUB_AB_4;
                    AND_AB:  next_state = S_AND_AB_4;
                    OR_AB:   next_state = S_OR_AB_4;

                    BRA:     next_state = S_BRA_4;
                    BMI, BPL, BEQ, BNE, BVS, BVC, BCS, BCC:
                             next_state = S_COND_BR_4;

                    default: next_state = S_FETCH_0;
                endcase
            end
            
            // LDA_IMM Instruction Sequence
            S_LDA_IMM_4: next_state = S_LDA_IMM_5;
            S_LDA_IMM_5: next_state = S_LDA_IMM_6;
            S_LDA_IMM_6: next_state = S_FETCH_0;

            // LDA_DIR Instruction Sequence
            S_LDA_DIR_4: next_state = S_LDA_DIR_5;
            S_LDA_DIR_5: next_state = S_LDA_DIR_6;
            S_LDA_DIR_6: next_state = S_LDA_DIR_7;
            S_LDA_DIR_7: next_state = S_LDA_DIR_8;
            S_LDA_DIR_8: next_state = S_FETCH_0;
//            S_LDA_DIR_8: next_state = S_LDA_DIR_9;
//            S_LDA_DIR_9: next_state = S_FETCH_0;

            // STA_DIR Instruction Sequence
            S_STA_DIR_4: next_state = S_STA_DIR_5;
            S_STA_DIR_5: next_state = S_STA_DIR_6;
            S_STA_DIR_6: next_state = S_STA_DIR_7;
            S_STA_DIR_7: next_state = S_FETCH_0;
//            S_STA_DIR_7: next_state = S_STA_DIR_8;
//            S_STA_DIR_8: next_state = S_FETCH_0;

            // LDB_IMM Instruction Sequence
            S_LDB_IMM_4: next_state = S_LDB_IMM_5;
            S_LDB_IMM_5: next_state = S_LDB_IMM_6;
            S_LDB_IMM_6: next_state = S_FETCH_0;

            // LDB_DIR Instruction Sequence
            S_LDB_DIR_4: next_state = S_LDB_DIR_5;
            S_LDB_DIR_5: next_state = S_LDB_DIR_6;
            S_LDB_DIR_6: next_state = S_LDB_DIR_7;
            S_LDB_DIR_7: next_state = S_LDB_DIR_8;
            S_LDB_DIR_8: next_state = S_FETCH_0;
//            S_LDB_DIR_8: next_state = S_LDB_DIR_9;
//            S_LDB_DIR_9: next_state = S_FETCH_0;

            // STB_DIR Instruction Sequence
            S_STB_DIR_4: next_state = S_STB_DIR_5;
            S_STB_DIR_5: next_state = S_STB_DIR_6;
            S_STB_DIR_6: next_state = S_STB_DIR_7;
            S_STB_DIR_7: next_state = S_FETCH_0;
//            S_STB_DIR_7: next_state = S_STB_DIR_8;
//            S_STB_DIR_8: next_state = S_FETCH_0;

            // BRA (Branch Always) Instruction Sequence
            S_BRA_4: next_state = S_BRA_5;
            S_BRA_5: next_state = S_BRA_6;
            S_BRA_6: next_state = S_FETCH_0;
            
            // Conditional Branch Instruction Sequence
            S_COND_BR_4: next_state = S_COND_BR_5;
            S_COND_BR_5: begin
                case (IR)
                    BEQ: if (CCR_Result[2] == 1) next_state = S_COND_BR_6; else next_state = S_FETCH_0; // Branch if Zero (Z=1)
                    BNE: if (CCR_Result[2] == 0) next_state = S_COND_BR_6; else next_state = S_FETCH_0; // Branch if Not Zero (Z=0)
                    BMI: if (CCR_Result[3] == 1) next_state = S_COND_BR_6; else next_state = S_FETCH_0; // Branch if Minus (N=1)
                    BPL: if (CCR_Result[3] == 0) next_state = S_COND_BR_6; else next_state = S_FETCH_0; // Branch if Plus (N=0)
                    BVS: if (CCR_Result[1] == 1) next_state = S_COND_BR_6; else next_state = S_FETCH_0; // Branch if Overflow Set (V=1)
                    BVC: if (CCR_Result[1] == 0) next_state = S_COND_BR_6; else next_state = S_FETCH_0; // Branch if Overflow Clear (V=0)
                    BCS: if (CCR_Result[0] == 1) next_state = S_COND_BR_6; else next_state = S_FETCH_0; // Branch if Carry Set (C=1)
                    BCC: if (CCR_Result[0] == 0) next_state = S_COND_BR_6; else next_state = S_FETCH_0; // Branch if Carry Clear (C=0)
                    default: next_state = S_FETCH_0;
                endcase
            end
            S_COND_BR_6: next_state = S_FETCH_0;

            // Arithmetic/Logic Instruction Sequences (A = A op B)
            S_ADD_AB_4: next_state = S_ADD_AB_5;
            S_ADD_AB_5: next_state = S_FETCH_0;

            S_SUB_AB_4: next_state = S_SUB_AB_5;
            S_SUB_AB_5: next_state = S_FETCH_0;

            S_AND_AB_4: next_state = S_AND_AB_5;
            S_AND_AB_5: next_state = S_FETCH_0;

            S_OR_AB_4: next_state = S_OR_AB_5;
            S_OR_AB_5: next_state = S_FETCH_0;

            

            default: next_state = S_FETCH_0;
            
        endcase
    end
    
    
    // -- OUTPUT LOGIC --
    always @(current_state, IR) begin: OUTPUT_LOGIC
        
        // Default signal values: Modify needed ones in respective state
        IR_Load = 0;
        MAR_Load = 0;
        PC_Load = 0;
        PC_Inc = 0;
        A_Load = 0;
        B_Load = 0;
        CCR_Load = 0;
        write = 0;
        ALU_Sel = ALU_NO_OP;
        Bus1_Sel = BUS1_NO_SEL; //-- "00"=PC, "01"=A, "10"=B
        Bus2_Sel = BUS2_NO_SEL; //-- "00"=ALU_Result, "01"=Bus1, "10"=from_memory
        
        case (current_state)
            S_FETCH_0:  begin
                        // MAR <- PC
                        MAR_Load = 1;
                        Bus1_Sel = BUS1_PC;
                        Bus2_Sel = BUS2_BUS1;
                        end
                        
            S_FETCH_1:  begin
                        // PC <- PC + 1
                        PC_Inc = 1;
                        end
                        
            S_FETCH_2:  begin
                        // IR <- Instruction from memory
                        IR_Load = 1;
                        Bus2_Sel = BUS2_FROM_MEMORY;
                        end
                        
            S_DECODE_3: begin
                        // Decode instruction
                        end
            
            // -- For Register A --            
            S_LDA_IMM_4:    begin
                            // MAR <- PC
                            MAR_Load = 1;
                            Bus1_Sel = BUS1_PC;
                            Bus2_Sel = BUS2_BUS1;
                            end
                            
            S_LDA_IMM_5:    begin
                            // PC <- PC + 1; A <- Immediate Operand
                            PC_Inc = 1;
                            A_Load = 1;
                            Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_LDA_IMM_6:    begin
                           
                            end
                            
            S_LDA_DIR_4:    begin
                            // MAR <- PC
                            MAR_Load = 1;
                            Bus1_Sel = BUS1_PC;
                            Bus2_Sel = BUS2_BUS1;
                            end
                            
            S_LDA_DIR_5:    begin
                            // PC <- PC + 1; MAR <- Address
                            PC_Inc = 1;
                            MAR_Load = 1;
                            Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_LDA_DIR_6:    begin
                            // Wait state
                            end
                            
            S_LDA_DIR_7:    begin
                            // A <- RW[Address]
                            A_Load = 1;
                            Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_LDA_DIR_8:    begin
                            
                            end
                            
            S_STA_DIR_4:    begin
                            // MAR <- PC
                            MAR_Load = 1;
                            Bus1_Sel = BUS1_PC;
                            Bus2_Sel = BUS2_BUS1;
                            end
                            
            S_STA_DIR_5:    begin
                            // MAR <- Address
                            PC_Inc = 1;
                            MAR_Load = 1;
                            Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_STA_DIR_6:    begin
                            // RW[Address] <- A
                            Bus1_Sel = BUS1_A;
                            write = 1;
                            end
                            
            S_STA_DIR_7:    begin
                            
                            end
                            
            
            // -- For Register B --                
            S_LDB_IMM_4:    begin
                            // MAR <- PC
                            MAR_Load = 1;
                            Bus1_Sel = BUS1_PC;
                            Bus2_Sel = BUS2_BUS1;
                            end
                            
            S_LDB_IMM_5:    begin
                            // PC <- PC + 1; B <- Immediate Operand
                            PC_Inc = 1;
                            B_Load = 1;
                            Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_LDB_IMM_6:    begin
                           
                            end
                            
            S_LDB_DIR_4:    begin
                            // MAR <- PC
                            MAR_Load = 1;
                            Bus1_Sel = BUS1_PC;
                            Bus2_Sel = BUS2_BUS1;
                            end
                            
            S_LDB_DIR_5:    begin
                            // PC <- PC + 1; MAR <- Address
                            PC_Inc = 1;
                            MAR_Load = 1;
                            Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_LDB_DIR_6:    begin
                            // Wait state
                            end
                            
            S_LDB_DIR_7:    begin
                            // B <- RW[Address]
                            B_Load = 1;
                            Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_LDB_DIR_8:    begin
                            
                            end
                            
            S_STB_DIR_4:    begin
                            // MAR <- PC
                            MAR_Load = 1;
                            Bus1_Sel = BUS1_PC;
                            Bus2_Sel = BUS2_BUS1;
                            end
                            
            S_STB_DIR_5:    begin
                            // MAR <- Address
                            PC_Inc = 1;
                            MAR_Load = 1;
                            Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_STB_DIR_6:    begin
                            // RW[Address] <- B
                            Bus1_Sel = BUS1_B;
                            write = 1;
                            end
                            
            S_STB_DIR_7:    begin
                            
                            end
                            
            
            // -- Branching States --
            S_BRA_4:    begin
                        // MAR <- PC
                        MAR_Load = 1;
                        Bus1_Sel = BUS1_PC;
                        Bus2_Sel = BUS2_BUS1;
                        end
                        
            S_BRA_5:    begin
                        // PC <- Address
                        Bus2_Sel = BUS2_FROM_MEMORY;
                        PC_Load = 1;
                        end
                        
            S_BRA_6:    begin
                        
                        end
                        
            S_COND_BR_4:    begin
                            MAR_Load = 1;
                            Bus1_Sel = BUS1_PC;
                            Bus2_Sel = BUS2_BUS1;
                            end
                            
            S_COND_BR_5:    begin
                            case (IR)
                                BEQ: if (CCR_Result[2] == 1) PC_Load = 1; // Z=1
                                BNE: if (CCR_Result[2] == 0) PC_Load = 1; // Z=0
                                BMI: if (CCR_Result[3] == 1) PC_Load = 1; // N=1
                                BPL: if (CCR_Result[3] == 0) PC_Load = 1; // N=0
                                BVS: if (CCR_Result[1] == 1) PC_Load = 1; // V=1
                                BVC: if (CCR_Result[1] == 0) PC_Load = 1; // V=0
                                BCS: if (CCR_Result[0] == 1) PC_Load = 1; // C=1
                                BCC: if (CCR_Result[0] == 0) PC_Load = 1; // C=0
                                default: PC_Load = 0;
                            endcase
                            if (PC_Load)
                                Bus2_Sel = BUS2_FROM_MEMORY;
                            end
                            
            S_COND_BR_6:    begin
                            
                            end
            
            
            // -- ALU Operations --                
            S_ADD_AB_4:     begin
                            ALU_Sel = ALU_ADD_SEL;
                            Bus1_Sel = BUS1_B;
                            end
                            
            S_ADD_AB_5:     begin
                            Bus2_Sel = BUS2_ALU_RESULT;
                            A_Load = 1;
                            CCR_Load = 1;
                            end
                            
            S_SUB_AB_4:     begin
                            ALU_Sel = ALU_SUB_SEL;
                            Bus1_Sel = BUS1_B;
                            end
                            
            S_SUB_AB_5:     begin
                            Bus2_Sel = BUS2_ALU_RESULT;
                            A_Load = 1;
                            CCR_Load = 1;
                            end
                            
            S_AND_AB_4:     begin
                            ALU_Sel = ALU_AND_SEL;
                            Bus1_Sel = BUS1_B;
                            end
                            
            S_AND_AB_5:     begin
                            A_Load = 1;
                            Bus2_Sel = BUS2_ALU_RESULT;
                            CCR_Load = 1;
                            end
                            
            default:        begin
                            
                            end
        endcase
    end
    
endmodule
