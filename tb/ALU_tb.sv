/*
    Module Name: tb_stop_watch
    Description: Test bench for stop_watch module
*/

`timescale 1ms / 100us

`include "src/alu_if.vh"
`include "src/cpu_pkg.vh"

module ALU_tb ();

    // Testbench parameters
    parameter WAIT = 6;
    logic CLK = 0;

    logic tb_checking_outputs; 
    logic tb_check_neg_out;
    logic tb_check_zero_out;
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

    task check_neg;
    input exp_neg; 
    begin
        tb_check_neg_out = 1'b1;
        if(aluif.negative == exp_neg)
            $info("Correct neg out: %0d.", exp_neg);
        else
            $error("Incorrect neg out. Expected: %0d. Actual: %0d.", exp_neg, aluif.negative); 
        tb_check_neg_out = 1'b0;
        #(WAIT);
    end
    endtask

    task check_zero;
    input exp_zero; 
    begin
        tb_check_zero_out = 1'b1;
        if(aluif.zero == exp_zero)
            $info("Correct zero out: %0d.", exp_zero);
        else
            $error("Incorrect zero out. Expected: %0d. Actual: %0d.", exp_zero, aluif.zero); 
        tb_check_zero_out = 1'b0;
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
    tb_test_num = 0; //test case unsigned
    aluif.inputA = 32'd256;
    aluif.inputB = 32'd3;;
    aluif.ALUOp = ALU_SLL;
    check_ALU_out(32'd2048);

    tb_test_num = 0; //test case signed
    aluif.inputA = -32'd256;
    aluif.inputB = 32'd3;;
    aluif.ALUOp = ALU_SLL;
    check_ALU_out(-32'd2048);

    //SRA/SRAI unsigned
    tb_test_num += 1; //test case 
    aluif.inputA = 32'd9984;
    aluif.inputB = 32'd3;
    aluif.ALUOp = ALU_SRL;
    check_ALU_out(32'd1248);

    tb_test_num += 1; //test case 
    aluif.inputA = -32'd1000;
    aluif.inputB = 32'd3;
    aluif.ALUOp = ALU_SRL;
    check_ALU_out(-32'd125);

    //ADD/ADDI
    ////////////////////////////////////
    //pos plus pos
    tb_test_num += 1; //test case 
    aluif.inputA = 32'd40;
    aluif.inputB = 32'd90;
    aluif.ALUOp = ALU_ADD;
    check_ALU_out(32'd130);
    check_neg(0);

    //negative plus negative
    tb_test_num += 1; //test case 
    aluif.inputA = -32'd8;
    aluif.inputB = -32'd10;
    aluif.ALUOp = ALU_ADD;
    check_ALU_out(-32'd18);
    check_neg(1);

    //positve plus negative
    tb_test_num += 1; //test case 
    aluif.inputA = 32'd10;
    aluif.inputB = -32'd8;
    aluif.ALUOp = ALU_ADD;
    check_ALU_out(32'd2);
    check_neg(0);

    //negative plus positive
    tb_test_num += 1; //test case 
    aluif.inputA = -32'd20;
    aluif.inputB = 32'd4;
    aluif.ALUOp = ALU_ADD;
    check_ALU_out(-32'd16);
    check_neg(1);

    //check zero
    tb_test_num += 1; //test case 
    aluif.inputA = 32'd10;
    aluif.inputB = 32'd10;
    aluif.ALUOp = ALU_SUB;
    check_zero(1);

    /////////////////////////////////

    //sub
    /////////////////////////////////////////////////////////
    //neg minus neg
    tb_test_num += 1; //test case 
    aluif.inputA = -32'd10;
    aluif.inputB = -32'd5;
    aluif.ALUOp = ALU_SUB;
    check_ALU_out(-32'd5);
    check_neg(1);

    //pos minus pos
    tb_test_num += 1; //test case 
    aluif.inputA = 32'd15;
    aluif.inputB = 32'd5;
    aluif.ALUOp = ALU_SUB;
    check_ALU_out(32'd10);

    //pos - neg
    tb_test_num += 1; //test case 
    aluif.inputA = 32'd20;
    aluif.inputB = -32'd5;
    aluif.ALUOp = ALU_SUB;
    check_ALU_out(32'd25);

    //neg - pos
    tb_test_num += 1; //test case 
    aluif.inputA = -32'd20;
    aluif.inputB = 32'd10;
    aluif.ALUOp = ALU_SUB;
    check_ALU_out(-32'd30);

    //check zero
    tb_test_num += 1; //test case 
    aluif.inputA = 32'd10;
    aluif.inputB = 32'd10;
    aluif.ALUOp = ALU_SUB;
    check_zero(1);

    ////////////////////////////////////////////////////////////

    //OR/ORI 
    tb_test_num += 1; //test case 
    aluif.inputA = 32'b0010;
    aluif.inputB = 32'b1101;
    aluif.ALUOp = ALU_OR;
    check_ALU_out(32'b1111);

    //XOR/XORI
    tb_test_num += 1; //test case 
    aluif.inputA = 32'b100011;
    aluif.inputB = 32'b101010;
    aluif.ALUOp = ALU_XOR;
    check_ALU_out(32'b001001);

    //AND/ANDI
    tb_test_num += 1; //test case 
    aluif.inputA = 32'b100110;
    aluif.inputB = 32'b111100;
    aluif.ALUOp = ALU_XOR;
    check_ALU_out(32'b100100);

    //SLT/SLTI
    tb_test_num += 1; //test case 
    aluif.inputA = -32'd15;
    aluif.inputB = 32'd10;
    aluif.ALUOp = ALU_SLT;
    check_ALU_out(32'd1);

    //SLTU
    tb_test_num += 1; //test case 
    aluif.inputA = 32'd8;
    aluif.inputB = 32'd10;
    aluif.ALUOp = ALU_SLTU;
    check_ALU_out(32'd1);

    //SRL
    tb_test_num += 1; //test case 
    aluif.inputA = 
    aluif.inputB =
    aluif.ALUOp = 
    check_ALU_out(xxxx);


$finish;
end
endprogram