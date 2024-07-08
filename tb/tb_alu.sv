
`timescale 1ms / 100us

module tb_alu ();

    logic [31:0]tb_inputA, tb_inputB;
    cuOPType aluOP;
    logic [31:0] ALUResult;
    logic negative, zero;

    alu a1(.inputA(tb_inputA), .inputB(tb_inputB), .aluOP(aluOP), .ALUResult(ALUResult), .negative(negative), .zero(zero));


    // Testbench parameters
    parameter WAIT = 5;

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
        if(ALUResult == exp_ALU_out)
            $info("Correct ALU_o: %0d.", exp_ALU_out);
        else
            $error("Incorrect ALU_o. Expected: %0d. Actual: %0d.", exp_ALU_out, ALUResult); 
        tb_checking_outputs = 1'b0;  
        #(WAIT);
    end
    endtask

    task check_neg;
    input exp_neg; 
    begin
        tb_check_neg_out = 1'b1;
        if(negative == exp_neg)
            $info("Correct neg out: %0d.", exp_neg);
        else
            $error("Incorrect neg out. Expected: %0d. Actual: %0d.", exp_neg, negative); 
        tb_check_neg_out = 1'b0;
        #(WAIT);
    end
    endtask

    task check_zero;
    input exp_zero; 
    begin
        tb_check_zero_out = 1'b1;
        if(zero == exp_zero)
            $info("Correct zero out: %0d.", exp_zero);
        else
            $error("Incorrect zero out. Expected: %0d. Actual: %0d.", exp_zero, zero); 
        tb_check_zero_out = 1'b0;
        #(WAIT);
    end
    endtask

    initial begin
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    //SLL / SLLI
    tb_test_num = 0; //test case unsigned 0
    $display("%d", tb_test_num);
    tb_inputA = 32'd256;
    tb_inputB = 32'd3;
    aluOP = CU_SLL;
    check_ALU_out(32'd2048);

    

    tb_test_num += 1; //test case signed 1
    $display("%d", tb_test_num);
    tb_inputA = -32'd256;
    tb_inputB = 32'd3;;
    aluOP = CU_SLL;
    check_ALU_out(-32'd2048);

    //SRA/SRAI unsigned
    tb_test_num += 1; //test case 2
    $display("%d", tb_test_num);
    tb_inputA = -32'd9984;
    tb_inputB = 32'd3;
    aluOP = CU_SRL;
    check_ALU_out(-32'd1248);

    tb_test_num += 1; //test case 3
    $display("%d", tb_test_num);
    tb_inputA = -32'd1000;
    tb_inputB = 32'd3;
    aluOP = CU_SRL;
    check_ALU_out(-32'd125);

    //ADD/ADDI
    ////////////////////////////////////
    //pos plus pos
    tb_test_num += 1; //test case 4
    $display("%d", tb_test_num);
    tb_inputA = 32'd40;
    tb_inputB = 32'd90;
    aluOP = CU_ADD;
    check_ALU_out(32'd130);
    check_neg(0);

    //negative plus negative
    tb_test_num += 1; //test case 5
    $display("%d", tb_test_num);
    tb_inputA = -32'd8;
    tb_inputB = -32'd10;
    aluOP = CU_ADD;
    check_ALU_out(-32'd18);
    check_neg(1);

    //positve plus negative
    tb_test_num += 1; //test case 6
    $display("%d", tb_test_num);
    tb_inputA = 32'd10;
    tb_inputB = -32'd8;
    aluOP = CU_ADD;
    check_ALU_out(32'd2);
    check_neg(0);

    //negative plus positive
    tb_test_num += 1; //test case 7
    $display("%d", tb_test_num);
    tb_inputA = -32'd20;
    tb_inputB = 32'd4;
    aluOP = CU_ADD;
    check_ALU_out(-32'd16);
    check_neg(1);

    //check zero
    tb_test_num += 1; //test case 8
    $display("%d", tb_test_num);
    tb_inputA = 32'd10;
    tb_inputB = 32'd10;
    aluOP = CU_SUB;
    check_zero(1);

    /////////////////////////////////

    //sub
    /////////////////////////////////////////////////////////
    //neg minus neg
    tb_test_num += 1; //test case 9
    $display("%d", tb_test_num);
    tb_inputA = -32'd10;
    tb_inputB = -32'd5;
    aluOP = CU_SUB;
    check_ALU_out(-32'd5);
    check_neg(1);

    //pos minus pos
    tb_test_num += 1; //test case 10
    $display("%d", tb_test_num);
    tb_inputA = 32'd15;
    tb_inputB = 32'd5;
    aluOP = CU_SUB;
    check_ALU_out(32'd10);

    //pos - neg
    tb_test_num += 1; //test case 11
    $display("%d", tb_test_num);
    tb_inputA = 32'd20;
    tb_inputB = -32'd5;
    aluOP = CU_SUB;
    check_ALU_out(32'd25);

    //neg - pos
    tb_test_num += 1; //test case 12
    $display("%d", tb_test_num);
    tb_inputA = -32'd20;
    tb_inputB = 32'd10;
    aluOP = CU_SUB;
    check_ALU_out(-32'd30);

    //check zero
    tb_test_num += 1; //test case 13 
    $display("%d", tb_test_num);
    tb_inputA = 32'd10;
    tb_inputB = 32'd10;
    aluOP = CU_SUB;
    check_zero(1);

    ////////////////////////////////////////////////////////////

    //OR/ORI 
    tb_test_num += 1; //test case 14
    $display("%d", tb_test_num);
    tb_inputA = 32'b0010;
    tb_inputB = 32'b1101;
    aluOP = CU_OR;
    check_ALU_out(32'b1111);

    //XOR/XORI
    tb_test_num += 1; //test case 15
    $display("%d", tb_test_num);
    tb_inputA = 32'b100011;
    tb_inputB = 32'b101010;
    aluOP = CU_XOR;
    check_ALU_out(32'b001001);

    //AND/ANDI
    tb_test_num += 1; //test case 16
    $display("%d", tb_test_num);
    tb_inputA = 32'b100110;
    tb_inputB = 32'b111100;
    aluOP = CU_XOR;
    check_ALU_out(32'b100100);

    //SLT/SLTI
    tb_test_num += 1; //test case 17
    $display("%d", tb_test_num);
    tb_inputA = -32'd15;
    tb_inputB = 32'd10;
    aluOP = CU_SLT;
    check_ALU_out(32'd1);

    //SLTU
    tb_test_num += 1; //test case 18
    $display("%d", tb_test_num);
    tb_inputA = 32'd8;
    tb_inputB = 32'd10;
    aluOP = CU_SLTU;
    check_ALU_out(32'd1);

    //SRL
    tb_test_num += 1; //test case 19
    $display("%d", tb_test_num);
    tb_inputA = 32'd1000;
    tb_inputB = 32'd2;
    aluOP = CU_SRL;
    check_ALU_out(32'd250);
$finish;
end

endmodule

module alu(
    input logic[31:0]inputA, inputB,
    input cuOPType aluOP,
    output logic[31:0]ALUResult,
    output logic negative, zero
);
//input A and B must be signed!
logic [31:0] unsignedA, unsignedB;
assign unsignedA = inputA;
assign unsignedB = inputB;
always_comb begin
    //will this zero cause an issue?
    zero = 0;
    case (aluOP)
    CU_SLL:
        ALUResult = inputA << inputB[4:0];
    CU_SRA:
        ALUResult = inputA >>> inputB[4:0];
    CU_SRL:
        ALUResult = inputA >> inputB;
    CU_ADD:
        ALUResult = inputA + inputB;
    CU_SUB: begin
        ALUResult = inputA - inputB;
        if (ALUResult == 0)
            zero = 1;
            end
    CU_OR: 
        ALUResult = inputA | inputB;
    CU_XOR:
        ALUResult = inputA ^ inputB;
    CU_AND:
        ALUResult = inputA & inputB;
    CU_SLT: begin
        if (inputA < inputB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0;
            end 
    CU_SLTU: begin
        if (unsignedA < unsignedB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0;
             end
    //do I need a defualt case?

    endcase
    negative = ALUResult[31];
end
endmodule   