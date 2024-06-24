
//make sure name of test bench is still correct
`include "pc_if.vh"


`timescale 1ms / 100us

module pc_tb ();

localparam CLK_PERIOD = 10; 

//all logic
logic tb_clk;
integer testCaseNum;

//set up interface
pc_if pcif ();

test PROG(.pcuf, .tb_clk, testCaseNum);

//is this call right?
pc DUT(pcif);

task reset_dut;
    @(negedge tb_clk);
    tb_nRST = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRST = 1'b1;
    @(posedge tb_clk);
endtask

// Clock generation block
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

task checkOut;
    input logic [31:0] exp_out;
    @(negedge tb_clk);
    tb_checking_outputs = 1'b1;
    if(tb_out == exp_out)
        $info("Correct address %0d.", exp_out);
    else
        $error("Incorrect address. Expected: %0d. Actual: %0d.", exp_out, tb_out); 
    
    #(1);
    tb_checking_outputs = 1'b0;  
endtask
//make an operation to check the operation???
    // task whichOp;
    // input logic [5:0] operation;
    // if operation
    // endtask
//do I need to set an inital value to PC?

endmodule

program test (
    pc_if.tb pcif,
    input tb_clk,
    integer testCaseNum
);
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    pcif.nRST = 1;
    pcif.negative = 0;
    pcif.iready = 1;
    pcif.ALUneg = 0;
    pcif.cuOP = 5'b0;
    
    testCaseNum = 100;
    tb_test_num = -1;
    tb_test_case = "Initializing";

    // ************************************************************************
    // Test Case 0: Power-on-Reset of the DUT
    // ************************************************************************
        //Check to see if reset address is correct
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);
        tb_nRST = 0;
        #2;
        checkOut(32'b0);
        @(negedge tb_clk);
        tb_nRST = 1;
        #2;
        checkOut(32'b0);
    // ************************************************************************
    // Test Case 1: Testing JAL operation
    // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 1: JAL operation";
        reset_dut;
        $display("\n\n%s", tb_test_case);
        pcif.signExtend = 0;
        pcif.rs1Read = 0;
        pcif.CUOp= JAL;
        //change negative and zero values to ensure works properly for different values
        pcif.negative = 0;
        pcif.zero = 0;
        pcif.iready = 1;
        //loop through test cases
        for (integer i = 1; i < testCaseNum; i++) begin
            for (integer j = 1; j < testCaseNum; j++) begin
            pcif.signExtend = pcif.signExtend + j;
            pcif.rs1Read = pcif.rs1Read + i;
            @(negedge tb_clk);
            checkOut(pcif.rs1Read + pcif.signExtend + 4);
            end 
        end





    #1;
    $finish;
end
endprogram
