`timescale 1ns / 1ps

module cpu_tb();
    reg clock, reset;
    wire [7:0] address, to_memory;
    wire write;
    reg [7:0] from_memory;
    
    // Instantiate the CPU module
    cpu uut (
        .address(address),
        .to_memory(to_memory),
        .write(write),
        .from_memory(from_memory),
        .clock(clock),
        .reset(reset)
    );
    
    // Clock generation (100MHz)
    always begin
        #5 clock = ~clock;
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        clock = 0;
        reset = 1;
        from_memory = 8'h00;
        
        // Open VCD file for waveform dumping
        $dumpfile("cpu_wave.vcd");
        $dumpvars(0, cpu_tb);
        
        // Reset the CPU
        #10 reset = 0;
        #20 reset = 1;
        
        $display("[%0t] CPU Reset Complete", $time);
        
        // Test 1: LDA_IMM instruction (0x86) with immediate value 0xAA
        from_memory = 8'h86; // LDA_IMM opcode
        #50;
        from_memory = 8'hAA; // Immediate value
        #50;
        $display("[%0t] Test 1: LDA_IMM completed. A should be 0xAA", $time);
        
        // Test 2: LDB_IMM instruction (0x88) with immediate value 0x55
        from_memory = 8'h88; // LDB_IMM opcode
        #50;
        from_memory = 8'h55; // Immediate value
        #50;
        $display("[%0t] Test 2: LDB_IMM completed. B should be 0x55", $time);
        
        // Test 3: ADD_AB instruction (0x42) - A + B
        from_memory = 8'h42; // ADD_AB opcode
        #100; // Allow time for execution
        $display("[%0t] Test 3: ADD_AB completed. A should be 0xFF, CCR[NZVC] should be 1001", $time);
        
        // Test 4: STA_DIR instruction (0x96) to store result at 0xE1
        from_memory = 8'h96; // STA_DIR opcode
        #50;
        from_memory = 8'hE1; // Address
        #50;
        $display("[%0t] Test 4: STA_DIR completed. Address 0xE1 should contain 0xFF", $time);
        
        // Test 5: LDB_DIR instruction (0x89) to load from address 0x80
        from_memory = 8'h89; // LDB_DIR opcode
        #50;
        from_memory = 8'h80; // Address
        #50;
        // Provide data at address 0x80
        from_memory = 8'h22; // Data to load
        #50;
        $display("[%0t] Test 5: LDB_DIR completed. B should be 0x22", $time);
        
        // Test 6: ADD_AB instruction again (0x42) - A + B (0xFF + 0x22)
        from_memory = 8'h42; // ADD_AB opcode
        #100;
        $display("[%0t] Test 6: ADD_AB completed. A should be 0x21, CCR[NZVC] should be 0001 (carry)", $time);
        
        // Test 7: STA_DIR instruction to store final result at 0xE2
        from_memory = 8'h96; // STA_DIR opcode
        #50;
        from_memory = 8'hE2; // Address
        #50;
        $display("[%0t] Test 7: STA_DIR completed. Address 0xE2 should contain 0x21", $time);
        
        // End simulation
        #100;
        $display("[%0t] All CPU tests completed", $time);
        $finish;
    end
    
    // Monitor important signals
    always @(posedge clock) begin
        $display("[%0t] PC: %h, IR: %h, A: %h, B: %h, CCR: %b, Addr: %h, Data: %h, Write: %b",
            $time,
            uut.DP.PC,
            uut.DP.IR,
            uut.DP.A,
            uut.DP.B,
            uut.DP.CCR_Result,
            address,
            write ? to_memory : from_memory,
            write);
    end
    
    // Automatic verification checks
    always @(posedge clock) begin
        // Check A register after first ADD_AB
        if (uut.DP.IR == 8'h42 && uut.DP.PC == 8'h02 && uut.DP.A != 8'hFF) begin
            $display("[%0t] ERROR: First ADD_AB failed. A should be 0xFF, got 0x%h", 
                    $time, uut.DP.A);
        end
        
        // Check B register after LDB_DIR
        if (uut.DP.IR == 8'h89 && uut.DP.PC == 8'h02 && uut.DP.B != 8'h22) begin
            $display("[%0t] ERROR: LDB_DIR failed. B should be 0x22, got 0x%h", 
                    $time, uut.DP.B);
        end
        
        // Check A register after second ADD_AB
        if (uut.DP.IR == 8'h42 && uut.DP.PC == 8'h02 && uut.DP.A != 8'h21) begin
            $display("[%0t] ERROR: Second ADD_AB failed. A should be 0x21, got 0x%h", 
                    $time, uut.DP.A);
        end
    end
endmodule