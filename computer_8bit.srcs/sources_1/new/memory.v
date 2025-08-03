`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 03:16:02 PM
// Design Name: 
// Module Name: memory
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


module memory(
    output reg [7:0] data_out,
    output reg [7:0] port_out_00, port_out_01, port_out_02, port_out_03, port_out_04, 
                     port_out_05, port_out_06, port_out_07, port_out_08, port_out_09,
                     port_out_10, port_out_11, port_out_12, port_out_13, port_out_14,
                     port_out_15,
    input wire [7:0] address, data_in,
                     port_in_00, port_in_01, port_in_02, port_in_03, port_in_04,
                     port_in_05, port_in_06, port_in_07, port_in_08, port_in_09,
                     port_in_10, port_in_11, port_in_12, port_in_13, port_in_14,
                     port_in_15,
    input wire clock, reset, write
    );
    
    wire [7:0] rom_data_out, rw_data_out;
    
    
    rom_128x8_sync rom_mem (
        .data_out(rom_data_out),
        .address(address),
        .clock(clock)
    );
    
    rw_96x8_sync rw_mem (
        .data_out(rw_data_out),
        .address(address),
        .data_in(data_in),
        .clock(clock),
        .write(write)
    );
    
    always @ (address, rom_data_out, rw_data_out,
     port_in_00, port_in_01, port_in_02, port_in_03,
     port_in_04, port_in_05, port_in_06, port_in_07,
     port_in_08, port_in_09, port_in_10, port_in_11,
     port_in_12, port_in_13, port_in_14, port_in_15)
     begin: MUX1
         if ((address >= 0) && (address <= 127) )
            data_out = rom_data_out;
         else if ( (address >= 128) && (address <= 223) )
            data_out = rw_data_out;
         else if (address == 8'hF0) data_out = port_in_00;
         else if (address == 8'hF1) data_out = port_in_01;
         else if (address == 8'hF2) data_out = port_in_02;
         else if (address == 8'hF3) data_out = port_in_03;
         else if (address == 8'hF4) data_out = port_in_04;
         else if (address == 8'hF5) data_out = port_in_05;
         else if (address == 8'hF6) data_out = port_in_06;
         else if (address == 8'hF7) data_out = port_in_07;
         else if (address == 8'hF8) data_out = port_in_08;
         else if (address == 8'hF9) data_out = port_in_09;
         else if (address == 8'hFA) data_out = port_in_10;
         else if (address == 8'hFB) data_out = port_in_11;
         else if (address == 8'hFC) data_out = port_in_12;
         else if (address == 8'hFD) data_out = port_in_13;
         else if (address == 8'hFE) data_out = port_in_14;
         else if (address == 8'hFF) data_out = port_in_15;
         else data_out = 8'hXX;
     end
    
    
    //-- port_out_00 (address E0) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_00 <= 8'h00; 
        else 
        if ((address == 8'hE0) && (write)) 
            port_out_00 <= data_in; 
    end
    
    //-- port_out_01 (address E1) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_01 <= 8'h00; 
        else 
        if ((address == 8'hE1) && (write)) 
            port_out_01 <= data_in; 
    end
    
    //-- port_out_02 (address E2) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_02 <= 8'h00; 
        else 
        if ((address == 8'hE2) && (write)) 
            port_out_02 <= data_in; 
    end
    
    //-- port_out_03 (address E3) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_03 <= 8'h00; 
        else 
        if ((address == 8'hE3) && (write)) 
            port_out_03 <= data_in; 
    end
    
    //-- port_out_04 (address E4) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_04 <= 8'h00; 
        else 
        if ((address == 8'hE4) && (write)) 
            port_out_04 <= data_in; 
    end
    
    //-- port_out_05 (address E5) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_05 <= 8'h00; 
        else 
        if ((address == 8'hE5) && (write)) 
            port_out_05 <= data_in; 
    end
    
    //-- port_out_06 (address E6) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_06 <= 8'h00; 
        else 
        if ((address == 8'hE6) && (write)) 
            port_out_06 <= data_in; 
    end
    
    //-- port_out_07 (address E7) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_07 <= 8'h00; 
        else 
        if ((address == 8'hE7) && (write)) 
            port_out_07 <= data_in; 
    end
    
    //-- port_out_08 (address E8) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_08 <= 8'h00; 
        else 
        if ((address == 8'hE8) && (write)) 
            port_out_08 <= data_in; 
    end
    
    //-- port_out_09 (address E9) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_09 <= 8'h00; 
        else 
        if ((address == 8'hE9) && (write)) 
            port_out_09 <= data_in; 
    end
    
    //-- port_out_10 (address EA) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_10 <= 8'h00; 
        else 
        if ((address == 8'hEA) && (write)) 
            port_out_10 <= data_in; 
    end
    
    //-- port_out_11 (address EB) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_11 <= 8'h00; 
        else 
        if ((address == 8'hEB) && (write)) 
            port_out_11 <= data_in; 
    end
    
    //-- port_out_12 (address EC) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_12 <= 8'h00; 
        else 
        if ((address == 8'hEC) && (write)) 
            port_out_12 <= data_in; 
    end
    
    //-- port_out_13 (address ED) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_13 <= 8'h00; 
        else 
        if ((address == 8'hED) && (write)) 
            port_out_13 <= data_in; 
    end
    
    //-- port_out_14 (address EE) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_14 <= 8'h00; 
        else 
        if ((address == 8'hEE) && (write)) 
            port_out_14 <= data_in; 
    end
    
    //-- port_out_15 (address EF) 
    always @ (posedge clock or negedge reset) begin 
        if (!reset) 
            port_out_15 <= 8'h00; 
        else 
        if ((address == 8'hEF) && (write)) 
            port_out_15 <= data_in; 
    end
    
endmodule
