
//make sure name of test bench is still correct
`include "src/pc_if.vh"
`include "src/cpu_pkg.vh"
`include "src/pc.sv"
import cpu_pkg::*;

`timescale 1ms / 100us

module pc_tb ();

localparam CLK_PERIOD = 10; 

//all logic
logic tb_clk;

// Clock generation block
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

//set up interface
pc_if pcif ();

test PROG(.pcif(pcif), .tb_clk(tb_clk));

//is this call right?
pc DUT(pcif);


endmodule

program test (
    pc_if.tb pcif,
    input tb_clk
);

logic [31:0] intermResult;
integer testCaseNum;
logic tb_checking_outputs;
integer tb_test_num;
string tb_test_case;


task reset_dut;
    @(negedge tb_clk);
    pcif.nRST = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    pcif.nRST = 1'b1;
    @(posedge tb_clk);
endtask

task checkOut;
    input logic [31:0] exp_out;
    @(negedge tb_clk);
    tb_checking_outputs = 1'b1;
    if(pcif.PCaddr == exp_out)
        $info("Correct address %0d.", exp_out);
    else
        $error("Incorrect address. Expected: %0d. Actual: %0d.", exp_out, pcif.PCaddr); 
    
    #(1);
    tb_checking_outputs = 1'b0;  
endtask


initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    pcif.nRST = 1;
    pcif.ALUneg = 0;
    pcif.iready = 1;
    pcif.ALUneg = 0;
    pcif.cuOP = 5'b0;
    pcif.Zero = 0;
    pcif.clk = tb_clk;
    pcif.rs1Read = 32'b0;
    pcif.signExtend = 32'b0;
    testCaseNum = 100;
    tb_test_num = -1;
    tb_test_case = "Initializing";
    intermResult = 0;
    // ************************************************************************
    // Test Case 0: Power-on-Reset of the DUT
    // ************************************************************************
        //Check to see if reset address is correct
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);
        pcif.nRST = 0;
        #2;
        checkOut(32'b0);
        @(negedge tb_clk);
        pcif.nRST = 1;
        #2;
        checkOut(32'b0);
    // ************************************************************************
    // Test Case 1: Testing JAL operation
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 1: JAL operation";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP= JAL;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 0;
        pcif.iready = 1;
        //loop through test cases
        for (integer i = 1; i < testCaseNum; i++) begin
            for (integer j = 1; j < testCaseNum; j++) begin
            pcif.signExtend = pcif.signExtend + j;
            pcif.rs1Read = pcif.rs1Read + i;
            @(negedge tb_clk);

            //check operation for JAL
            checkOut(pcif.signExtend + 32'd4 + pcif.pc);
            end 
        end
    // ************************************************************************
    // Test Case 2: Testing JALR operation
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 2: JALR operation";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = JALR;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 0;
        pcif.iready = 1;
        //loop through test cases
        for (integer i = 1; i < testCaseNum; i++) begin
            for (integer j = 1; j < testCaseNum; j++) begin
            pcif.signExtend = pcif.signExtend + j;
            pcif.rs1Read = pcif.rs1Read + i;
            @(negedge tb_clk);
            intermResult = pcif.rs1Read + pcif.signExtend;
            checkOut(32'd4 + {intermResult[31:1], 0});
            end 
        end
    // ************************************************************************
    // Test Case 3: Testing BEQ with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 3: Testing BEQ with failed zero condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BEQ;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 0;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + 32'd4);
    // ************************************************************************
    // Test Case 4: Testing BNE with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 4: Testing BNE with failed zero condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BNE;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 1;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(32'd4 + pcif.pc);
    // ************************************************************************
    // Test Case 5: Testing BLT with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 5: Testing BLT with failed negative condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BLT;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 1;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(32'd4 + pcif.pc);
    // ************************************************************************
    // Test Case 6: Testing BGE with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 6: Testing BGE with failed negative condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BLT;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 1;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(32'd4 + pcif.pc);
    // ************************************************************************
    // Test Case 7: Testing BGEU with failed zero condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 7: Testing BGEU with failed negative condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BGEU;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 1;
        pcif.Zero = 1;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(32'd4 + pcif.pc);
    // ************************************************************************
    // Test Case 8: Testing BEQ 
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 8: Testing BEQ with passed condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BEQ;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 1;
        pcif.Zero = 1;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + pcif.signExtend);
    // ************************************************************************
    // Test Case 9: Testing BNE with passed condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 9: Testing BNE with passed condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BNE;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 0;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + pcif.signExtend);
    // ************************************************************************
    // Test Case 10: Testing BLT with passed condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 10: Testing BLT with passed condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BLT;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 1;
        pcif.Zero = 0;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + pcif.signExtend);
    // ************************************************************************
    // Test Case 11: Testing BGE with equal to condition
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 11: Testing BGE with equal to condition";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BGE;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 1;
        pcif.Zero = 1;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + pcif.signExtend);
    // ************************************************************************
    // Test Case 12: Testing BGE with negative = 0
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 12: Testing BGE with negative = 0";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BGE;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 0;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + pcif.signExtend);

    // ************************************************************************
    // Test Case 13: Testing BLTU with negative = 1
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 13: Testing BLTU with negative = 0";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BLTU;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 1;
        pcif.Zero = 0;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + pcif.signExtend);
    // ************************************************************************
    // Test Case 14: Testing BGEU with negative = 0
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 14: Testing BGEU with negative = 0";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BGEU;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 0;
        pcif.Zero = 0;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + pcif.signExtend);
    // ************************************************************************
    // Test Case 15: Testing BGEU with zero = 1
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 15: Testing BGEU with zero = 1";
        reset_dut;
        $display("\n\n%s", tb_test_case);

        //set initial values
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.cuOP = BGEU;

        //change negative and zero values to ensure works properly for different values
        pcif.ALUneg = 1;
        pcif.Zero = 1;
        pcif.iready = 1;
        //loop through test cases
        @(negedge tb_clk);
        checkOut(pcif.pc + pcif.signExtend);


    #1;
    $finish;
end
endprogram
