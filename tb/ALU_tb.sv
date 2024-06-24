/*
    Module Name: tb_stop_watch
    Description: Test bench for stop_watch module
*/

`timescale 1ms / 100us

module ALU_tb ();

    // Testbench parameters
    parameter WAIT = 6;
    logic CLK = 0;

    logic tb_checking_outputs; 
    integer tb_test_num;

    // DUT (design under test) ports
    //not needed because of interface !!

    // Task to check ALU output
    task check_ALU_out;
    input logic[31:0] exp_ALU_out; 
    begin
        tb_checking_outputs = 1'b1;
        if(aluif.ALUResult == expectedALU)
            $info("Correct ALU_o: %0d.", exp_ALU_o);
        else
            $error("Incorrect ALU_o. Expected: %0d. Actual: %0d.", ex[_ALU_out], ALUOut); 
        tb_checking_outputs = 1'b0;  
        #(WAIT);
    end
    endtask

    alu_if aluif ();
    startTB TB_prog (.aluif);
    alu tb_alu(aluif);

endmodule

    // DUT Portmap

program startTB(
    alu_if.tb aluif
);
initial begin
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    //SLL / SLLI
    aluif.inputA = 32'd8;
    aluif.inputB = 32'd3;
    aluif.ALUOp = 
    check_ALU_out(xxxx);

    //SRA/SRAI
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);

    //ADD/ADDI
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);

    //sub
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);

    //OR/ORI
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);

    //XOR/XORI
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);

    //AND/ANDI
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);

    //SLT/SLTI
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);

    //SLTU
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);


$finish;
end
endprogram

initial begin
        $dumpfile("dump.vcd");
        $dumpvars; 

end
        // Initialize test bench signals
        aluif.inputA = '0;
        aluif.inputB = '0;
        aluif.op = 

        // Wait some time before starting first test case
        #(0.1);

        // ************************************************************************
        // Test Case 0: Power-on-Reset of the DUT
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);

        tb_button_i = 1'b1;  // press button
        tb_nRst_i = 1'b0;  // activate reset

        // Wait for a bit before checking for correct functionality
        #(2);
        check_mode_o(IDLE, "IDLE");
        check_time_o('0);

        // Check that the reset value is maintained during a clock cycle
        @(negedge tb_clk);
        check_mode_o(IDLE, "IDLE");
        check_time_o('0);

        // Release the reset away from a clock edge
        @(negedge tb_clk);
        tb_nRst_i  = 1'b1;   // Deactivate the chip reset
        tb_nRst_i  = 1'b0;   // activate the chip reset
        // Check that internal state was correctly keep after reset release
        check_mode_o(IDLE, "IDLE");
        check_time_o('0);

        tb_button_i = 1'b0;  // release button

$finish

//////////////////////////////////////////////////////////below is for reference

    // Main Test Bench Process
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals
        tb_button_i = 1'b0; 
        tb_nRst_i = 1'b1;
        tb_checking_outputs = 1'b0;
        tb_test_num = -1;
        tb_test_case = "Initializing";

        // Wait some time before starting first test case
        #(0.1);

        // ************************************************************************
        // Test Case 0: Power-on-Reset of the DUT
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);

        tb_button_i = 1'b1;  // press button
        tb_nRst_i = 1'b0;  // activate reset

        // Wait for a bit before checking for correct functionality
        #(2);
        check_mode_o(IDLE, "IDLE");
        check_time_o('0);

        // Check that the reset value is maintained during a clock cycle
        @(negedge tb_clk);
        check_mode_o(IDLE, "IDLE");
        check_time_o('0);

        // Release the reset away from a clock edge
        @(negedge tb_clk);
        tb_nRst_i  = 1'b1;   // Deactivate the chip reset
        tb_nRst_i  = 1'b0;   // activate the chip reset
        // Check that internal state was correctly keep after reset release
        check_mode_o(IDLE, "IDLE");
        check_time_o('0);

        tb_button_i = 1'b0;  // release button

        // ************************************************************************
        // Test Case 1: Iterating through the different modes
        // ************************************************************************
        tb_test_num += 1;
        reset_dut;
        tb_test_case = "Test Case 1: Iterating through the different modes";
        $display("\n\n%s", tb_test_case);

        // Initially, mode_o is IDLE
        check_mode_o(IDLE, "IDLE"); 

        // Press button (IDLE->CLEAR)
        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay 
        check_mode_o(CLEAR, "CLEAR"); 

        // Press button (CLEAR->RUNNING)
        single_button_press(); 
        #(CLK_PERIOD * 5);
        check_mode_o(RUNNING, "RUNNING"); 

        // Press button (back to IDLE)
        single_button_press(); 
        #(CLK_PERIOD * 5);
        check_mode_o(IDLE, "IDLE"); 

        // ************************************************************************
        // Test Case 2: Only Changes Modes during Rising edges
        // ************************************************************************
        tb_test_num += 1; 
        reset_dut;
        tb_test_case = "Test Case 2: Stop watch changes mode once for each button press";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk); 
        tb_button_i = 1'b1;  // press button

        #(CLK_PERIOD * 20);  // keep button pressed a long time
        check_mode_o(CLEAR, "CLEAR"); 


        @(negedge tb_clk); 
        tb_button_i = 1'b0;  // release button

        // Keep adding to this test case!!

        ////////////////////////////////
        // ADD MORE TEST CASES HERE!! //
        ////////////////////////////////


        ////////////// running check

        @(negedge tb_clk); 
        tb_button_i = 1'b1;  // press button

        #(CLK_PERIOD * 20);  // keep button pressed a long time
        check_mode_o(RUNNING, "RUNNING"); 


        @(negedge tb_clk); 
        tb_button_i = 1'b0;  // release button

        //////////// idle check

                @(negedge tb_clk); 
        tb_button_i = 1'b1;  // press button

        #(CLK_PERIOD * 20);  // keep button pressed a long time
        check_mode_o(IDLE, "IDLE"); 


        @(negedge tb_clk); 
        tb_button_i = 1'b0;  // release button

        // ************************************************************************
        // Test Case 3: When mode is RUNNING, verify time_o increments every second
        // ************************************************************************
        tb_test_num += 1; 
        reset_dut;
        tb_test_case = "Test Case 3: When mode is RUNNING, verify time_o increments every second";
        $display("\n\n%s", tb_test_case);

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay  
        //now clear

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay 
        //now running

        #1050;
        check_time_o(5'b00001);

        #1000;
        check_time_o(5'b00010);

        #5000;
        check_time_o(5'b00111);

        // ************************************************************************
        // Test Case 4: Verify time_o stops changing after stop watch returns to IDLE
        // ************************************************************************
        tb_test_num += 1; 
        reset_dut;
        tb_test_case = "Test Case 4: Verify time_o stops changing after stop watch returns to IDLE";
        $display("\n\n%s", tb_test_case);

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay  
        //now clear

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay 
        //now running

        #1050;
        check_time_o(5'b00001);

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay 
        //now idle

        check_time_o(5'b00001);

        #4000;
        check_time_o(5'b00001);

        // ************************************************************************
        // Test Case 5: Verify count clears when mode transitions to CLEAR
        // ************************************************************************
        tb_test_num += 1; 
        reset_dut;
        tb_test_case = "Test Case 5: Verify count clears when mode transitions to CLEAR";
        $display("\n\n%s", tb_test_case);

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay  
        //now clear

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay 
        //now running

        #3050;
        check_time_o(5'b00011);

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay 
        //now idle

        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay 
        //now clear

        #1050;

        check_time_o(5'b0);
        check_mode_o(CLEAR, "CLEAR");

        $finish; 
    end

endmodule 