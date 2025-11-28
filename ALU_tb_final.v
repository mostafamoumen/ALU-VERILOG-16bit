`timescale 1ns/1ps

module alu_tb;

    // inputs to ALU
    reg [15:0] A_tb;
    reg [15:0] B_tb;
    reg [4:0]  F_tb;
    reg      cin_tb;

    // outputs from ALU
    wire [15:0] Result_tb;
    wire [5:0]  status_tb;

    // Flags for easier reading (C, Z, N, V, P, A)
    wire cf_tb, zf_tb, nf_tb, vf_tb, pf_tb, af_tb;
    integer i;

    // Instantiate the ALU (Unit Under Test)
    alu DUT (
        .A(A_tb), 
        .B(B_tb), 
        .F(F_tb), 
        .cin(cin_tb), 
        .Result(Result_tb), 
        .status(status_tb)
    );

    // Mapping (Unpacking the status bus)
    assign {cf_tb, zf_tb, nf_tb, vf_tb, pf_tb, af_tb} = status_tb;

    // Testing the ALU
    initial begin
        // Initialize
        A_tb = 0;
        B_tb = 0;
        F_tb = 0;
        cin_tb = 0;

        #10;

        // PASS 1:
        // 1. We use the maximum 16-bit value (0xFFFF) + 1 to force a wrap-around, 
        //    which tests the Carry Flag (CF=1) and Zero Flag (ZF=1).
        // 2. We force cin=1 to verify that operations like ADC and SBB correctly use the input carry.
        // 3. We test the Auxiliary Flag (AF) because 0xFFFF + 1 causes a carry to ripple 
        //    through every single bit (including bit 3 to bit 4).

        $display("PASS 1: Testing CARRY, ZERO & LOGIC (Inputs: FFFF, 0001, cin=1)");
        
        for (i = 0; i < 32; i = i + 1) begin
            A_tb = 16'hffff;
            B_tb = 16'h0001;
            cin_tb = 1;      
            F_tb = i;        
            
            #10;

            $display("F=%05b | Result=%h | Flags(CZNVPA)=%b",
                     F_tb, Result_tb, status_tb);
        end

        // PASS 2: The "Signed Overflow" Test
        // Inputs: 7FFF + 0001
        // Purpose: Forces Signed Overflow (VF=1) and Negative Result (NF=1)
        //          (Max Positive becomes Max Negative)
        
        $display("PASS 2: Testing OVERFLOW & NEGATIVE (Inputs: 7FFF, 0001, cin=0)");

        for (i = 0; i < 32; i = i + 1) begin
            A_tb = 16'h7fff; // Max Positive Number
            B_tb = 16'h0001; // +1
            cin_tb = 0;      // Clear carry to test pure signed arithmetic
            F_tb = i;        // set opcode
            
            #10;             // wait for ALU to compute

            $display("F=%05b | Result=%h | Flags(CZNVPA)=%b",
                     F_tb, Result_tb, status_tb);
        end

        $finish;
    end

endmodule