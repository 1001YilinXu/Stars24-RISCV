// FPGA Top Level

`default_nettype none

	typedef enum logic [2:0] {
        INIT, NUM1, NUM2, FINAL, DISPVAL
    } stateLog;

module FPGAModuleCalc (
  // I/O ports
  input  logic hz100, nrst,
  input  logic [20:0] pb,
  input logic [31:0] ramValue, instruction,
  output logic [7:0] ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,

  output logic[31:0] addressOut,   //will be the address that will be written to for the data
  output logic[31:0]dataOut,
  output logic memEnable,
  output logic cpuEnable
);
    //variables used
    stateLog currentState, nextState;
    logic keyStrobe;
    logic [31:0] r1Val, r2Val, nextR1Val, nextR2Val;
    logic [3:0] operation, nextOperation;
    logic [31:0] decOut;
    logic [4:0] dumpVar;
    logic [31:0]r1Count, r2Count, r1NextCount, r2NextCount;
    logic [3:0] ssdec1, ssdec2, ssdec3, ssdec4;
    keysync f1 (.clk(hz100), .keyin(pb[19:0]), .keyclk(keyStrobe), .rst(nrst), .keyout(dumpVar));

    //convert hex to decimal
          integer tens1, ones1, thousandsAnswer, hundredsAnswer, tensAnswer, onesAnswer;
    integer tens2, ones2;
    logic [3:0]tensLog1, onesLog1, thousandsLogAnswer, hundredsLogAnswer, tensLogAnswer, onesLogAnswer;
    logic [3:0]tensLog2, onesLog2;
    integer temp1;
    integer temp2;
    integer temp3;
    logic [15:0] operationDis, nextOperationDis;
 
    logic [6:0] ss4Data, ss3Data;
    logic [3:0] ss5Data, ss2Data;
 
    logic finalEnable; //enable for ssdec for when in final state
    logic displayEnable; //enable for when the user is inputting numbers, operations
 
   always_comb begin
 
        temp1 = r1Val;
 
        tens1 = temp1 / 10;
        ones1 = temp1 % 10;
 
        tensLog1 = tens1[3:0];
        onesLog1 = ones1[3:0];
 
        temp2 = r2Val;
 
        tens2 = temp2 / 10;
        ones2 = temp2 % 10;
 
        tensLog2 = tens2[3:0];
        onesLog2 = ones2[3:0];
 
        temp3 = ramValue; //can go up to 9801//////////////////////////////////////
 
        thousandsAnswer = temp3 / 1000;
        temp3 = temp3 % 1000;
 
        hundredsAnswer = temp3 / 100;
        temp3 = temp3 % 100;
 
        tensAnswer = temp3 / 10;
        onesAnswer = temp3 % 10;
 
        thousandsLogAnswer = thousandsAnswer[3:0];
        hundredsLogAnswer = hundredsAnswer[3:0];
        tensLogAnswer = tensAnswer[3:0];
        onesLogAnswer = onesAnswer[3:0];
 
        if (currentState == FINAL) begin
            ss5Data = thousandsLogAnswer;
            ss4 = {1'b0, ss4Data};
            ss3 = {1'b0, ss3Data};
            ss2Data = onesLogAnswer;
            finalEnable = 1'b1;
            displayEnable = 1'b0;
        end
        else begin
            ss5Data = 0;
            ss4 = operationDis[15:8];
            ss3 = operationDis[7:0];
            ss2Data = 0;
            finalEnable = 1'b0;
            displayEnable = 1'b1;
        end
 
   end
 
    //    ssdec f2 (.in(onesLog1), .enable(1'b1), .out(ss6[6:0])); //old
    // ssdec f3 (.in(tensLog1), .enable(1'b1), .out(ss7[6:0])); //old
    // ssdec f4 (.in(onesLog2), .enable(1'b1), .out(ss0[6:0])); //old
    // ssdec f5 (.in(tensLog2), .enable(1'b1), .out(ss1[6:0])); //old
 
    // assign {ss4, ss3} = operationDis; //old
 
    //always running in background
    ssdec ss4DataDec(.in(hundredsLogAnswer), .enable(1), .out(ss4Data));
    ssdec ss3DataDec(.in(tensLogAnswer), .enable(1), .out(ss3Data));
    //////
    ssdec f2 (.in(onesLog1), .enable(displayEnable), .out(ss6[6:0]));
    ssdec f3 (.in(tensLog1), .enable(displayEnable), .out(ss7[6:0]));
    ssdec f4 (.in(onesLog2), .enable(displayEnable), .out(ss0[6:0]));
    ssdec f5 (.in(tensLog2), .enable(displayEnable), .out(ss1[6:0]));
 
    //thousands place and ones place
    ssdec f6 (.in(ss5Data), .enable(finalEnable), .out(ss5[6:0]));
    ssdec f7 (.in(ss2Data), .enable(finalEnable), .out(ss2[6:0]));

    
//for when we receive the "Equal" output from the CPU, we need an additional comb block for determining what will be displayed on the ss displays

    ////////////////////////////////

    always_ff@(negedge nrst, posedge keyStrobe)
        if (~nrst) begin
            currentState <= NUM1;
            r1Val <= 0;
            r2Val <= 0;
            operation <= 0;
            operationDis <= 16'b0;
            r1Count <= 0;
            r2Count <= 0;
        end
        else begin
            currentState <= nextState;
            r1Val <= nextR1Val;
            r2Val <= nextR2Val;
            operation <= nextOperation;
            operationDis <= nextOperationDis;
            r1Count <= r1NextCount;
            r2Count <= r2NextCount;
        end

    decoder f8 (.pbIn(pb[19:0]), .decOut(decOut));
  
    always_comb begin

    nextClkCount = clkCount;
    casez({currentState, |pb[10:0], |pb[19:16], pb[14], pb[12]}) //numbers, operation, equal, clear 
        {NUM1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1}: begin //inputting numbers begins for num1
            nextState = NUM1;
            r1NextCount = r1Count + 1'b1;
            r2NextCount = r2Count;
            if (r1Count == 32'b00 | r1Count == 32'b01)
                nextR1Val = decOut + (r1Val << 3) + (r1Val << 1);
            else begin
            nextR1Val = r1Val;
            end
            nextR2Val = 0; 
            nextOperation = 0;
            nextOperationDis = 0;
            addressOut = 32'd100;
            dataOut = 0;
            memEnable = 0;
            cpuEnable = 0;
            nextClkCount = 0;
        end

        {NUM1, 1'b0, 1'b1, 1'b0, 1'b0}: begin // operation button was pressed, thus moving on to num2 state
            
            nextState = NUM2;
            r1NextCount = r1Count;
            r2NextCount = r2Count;
            nextR1Val = r1Val;
            nextR2Val = r2Val;
            if (pb[19]) begin
                nextOperation = 4'b1000; //add
                nextOperationDis = 16'b01110111_01011110;
            end
            else if (pb[18]) begin //sub
                nextOperation = 4'b0100;
                nextOperationDis = 16'b01101101_00111110;
            end
            else if (pb[17]) begin //multiply
                nextOperation = 4'b0010;
                nextOperationDis = 16'b01111000_00010000;
            end
            else if (pb[16]) begin //division
                nextOperation = 4'b0001;
                nextOperationDis = 16'b01011110_00010000;
            end
            else begin
                nextOperation = 4'b0000;
                nextOperationDis = 16'b00111111_00111111;
            end

            addressOut = 32'd1;
            dataOut = r1Val;
            memEnable = 1;
            cpuEnable = 0;
        end
        

        {NUM2, 1'b1, 1'b0, 1'b0, 1'b0}: begin //inputting numbers right now, will stay at state num2
            r1NextCount = r1Count;
            r2NextCount = r2Count + 1'b1;
            nextState = NUM2;
            nextR1Val = r1Val;
            if (r2Count == 32'b00 | r2Count == 32'b01)    
                nextR2Val = decOut + (r2Val << 3) + (r2Val << 1);
            else
                nextR2Val = r2Val;

            nextOperation = operation;
            nextOperationDis = operationDis;

            addressOut = 32'd1;
            dataOut = {28'b0, operation};
            memEnable = 1;
            cpuEnable = 0;

        end
        
        {NUM2, 1'b0, 1'b0, 1'b1, 1'b0}: begin //the E (equal button was pressed, thus moving onto the calculation, next final state)
            nextState = FINAL; 
            nextR1Val = r1Val;
            nextR2Val = r2Val;
            nextOperation = operation;
            nextOperationDis = operationDis;
            r1NextCount = r1Count;
            r2NextCount = r2Count;
            addressOut = 32'd1;
            dataOut = r2Val;
            memEnable = 1;
            cpuEnable = 1;
            if (instruction == 32'hffffffff) begin
                
            end

        end

        {FINAL, 1'b1, 1'b0, 1'b0, 1'b1 } begin
            



        end
        // {FINAL, 1'b1, 1'b0, 1'b0, 1'b1}: begin //the final state is on, we stay here
        // nextState = NUM1;
        // nextR1Val = r1Val;
        // nextR2Val = r2Val;
        // nextOperation = operation;
        // nextOperationDis = operationDis;
        // r1NextCount = r1Count;
        // r2NextCount = r2Count;
        // addressOut = 32'd1234;
        // dataOut = 0;
        // memEnable = 0;
        // cpuEnable = 0;
        // if (clkCount >= 200) begin
        // memEnable = 1;
        // cpuEnable = 0;
        // //reset the count somewhere
        // end
        // else
        // nextClkCount = clkCount + 1;
        // end

        {3'b???, 1'b0, 1'b0, 1'b0, 1'b1}: begin //from any state if the clear is pressed
        nextState = NUM1;
        nextR1Val = 0;
        nextR2Val = 0;
        nextOperation = 0;
        nextOperationDis = 0;
        r1NextCount = 0;
        r2NextCount = 0;
        addressOut = 32'd1; //dump address
        dataOut = 0;
        memEnable = 0;
        cpuEnable = 0;
        end
        default: begin
            nextState = currentState;
            nextR1Val = r1Val;
            nextR2Val = r2Val;
            nextOperation = operation;
            nextOperationDis = operationDis;
            r1NextCount = r1Count;
            r2NextCount = r2Count;
            addressOut = 32'd1; //dump address
            dataOut = 0;
            memEnable = 0;
            cpuEnable = 0;
        end
    endcase
end
    integer clkCount, nextClkCount;
    logic startCount, nextStartCount;
    always_ff@(posedge hz100, negedge nrst)
        if (~nrst) begin
            clkCount <= 0;
            startCount <= 0;
        end
        else begin
            clkCount <= nextClkCount;
            startCount <= cpuEnable;
        end
endmodule

module decoder (input logic [19:0] pbIn,
                output logic [31:0] decOut);

    always_comb
        if (pbIn[9])
            decOut = 32'b1001;
        else if (pbIn[8])
            decOut = 32'b1000;
        else if (pbIn[7])
            decOut = 32'b0111;
        else if (pbIn[6])
            decOut = 32'b0110;
        else if (pbIn[5])
            decOut = 32'b0101;
        else if (pbIn[4])
            decOut = 32'b0100;
        else if (pbIn[3])
            decOut = 32'b0011;
        else if (pbIn[2])
            decOut = 32'b0010;
        else if (pbIn[1])
            decOut = 32'b0001;
        else
            decOut = 0;
endmodule