
//make sure name of test bench is still correct
`include "pc_if.vh"


`timescale 1ms / 100us

module pc_tb ();

localparam CLK_PERIOD = 10; 

//all logic
logic tb_clk;
logic [31:0] tb_PC, tb_nextPC, tb_rs1Read, tb_signExtend;
logic [5:0] tb_op;
logic tb_checking_outputs, tb_extendZeros, tb_zero, tb_negative, tb_iready, tb_nRST;

//set up interface
pc_if pcif ();
//is this call right?
pc DUT(pcif, .nRST(tb_nRST), .clk(tb_clk));

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
pc_if.tb pcif; 

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

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
        
        pcif.CUOp= JAL;
        pcif.signExtend = signExtendIn;
        pcif.negative = 0;
        pcif.zero = 0;
        pcif.iready = 1;
        //loop through test cases
        for (integer i = 1; i < testCaseNum; i++) begin
            for (integer j = 1; j < testCaseNum; j++) begin
            
            pcif.rs1Read = 32'b0 + i;
            end 
        end
        @(negedge tb_clk);
        checkOut(signExtendIn + 4);
        wait(CLK_PERIOD);
        signExtendIn = 32'h1234;
        checkOut(signExtendIn + 4);
        wait(CLK_PERIOD);
        signExtendIn = 32'h2222;
        rs1ReadIn = 32'h1111;




    #1;
    $finish;
end

endmodule