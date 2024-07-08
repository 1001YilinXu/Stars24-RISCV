
typedef enum logic [2:0] {
    NUM1, OPSEL, NUM2, RESULT, DISPLAY
} stateLog;

module fpgaModule (
input logic clk, nrst,
input logic [31:0] instruction, dataIn,
input logic [19:0] buttons,
output logic [7:0] ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, right, left, 
//output [127:0] row1, row2,
output logic [31:0] address, dataOut,
output logic FPGAEnable, writeFPGA, CPUEnable
);

//logic definitions
    stateLog state, nextState;
    logic en;
    logic currCPUEnable;
    logic currFPGAEnable;
    logic currFPGAWrite;
    logic instructionTrue, nextTrue;
    logic [7:0] data, nextData;
    logic [4:0] halfData;
    logic keyStrobe;
    
    assign CPUEnable = currCPUEnable;
    assign writeFPGA = currFPGAWrite;
    assign FPGAEnable = currFPGAEnable;


edgeDetector edg(.clk(clk), .nRst_i(nrst), .button_i(keyStrobe), .button_p(en));

//always ff to change logic to next
always_ff@(posedge clk, negedge nrst) begin
    if (!nrst) begin
        state <= NUM1;
    end
    else if (en) begin
        state <= nextState;
    end
end

always_ff@(posedge clk, negedge nrst)begin
    if(!nrst) begin
        data <= 0;
    end else if(en) begin
        data <= nextData;
    end
end

always_ff@(posedge clk, negedge nrst)begin
    if(!nrst) begin
        instructionTrue <= 0;
    end else begin
        instructionTrue <= nextTrue;
    end
end

always_comb begin
    if(instruction == 32'hffffffff)
        nextTrue = 1;
    else 
        nextTrue = 0;

    casez ({state, buttons[12], keyStrobe})
    {NUM1, 2'b11}: nextState = OPSEL;
    {OPSEL, 2'b11}: nextState = NUM2;
    {NUM2, 2'b11}: nextState = RESULT;
    {RESULT, 2'b??}: begin
        if(instructionTrue)
            nextState = DISPLAY;
        else 
            nextState = RESULT;
    end
    {DISPLAY, 2'b11}: nextState = NUM1;
    default: nextState = state;
    endcase
end

keysync f1 (.clk(clk), .keyin(buttons[19:0]), .keyclk(keyStrobe), .rst(nrst), .keyout(halfData));
bcd f2 (.in(data), .out(dataOut));
ssdec f3 (.in(data[7:4]), .enable(state == NUM2), .out(ss2[6:0]));
ssdec f4 (.in(data[3:0]), .enable(state == NUM2), .out(ss1[6:0]));
ssdec f5 (.in(data[7:4]), .enable(state == OPSEL), .out(ss4[6:0]));
ssdec f6 (.in(data[3:0]), .enable(state == OPSEL), .out(ss3[6:0]));
ssdec f7 (.in(data[7:4]), .enable(state == NUM1), .out(ss6[6:0]));
ssdec f8 (.in(data[3:0]), .enable(state == NUM1), .out(ss5[6:0]));
ssdec f9 (.in(data[7:4]), .enable(state == DISPLAY), .out(ss8[6:0]));
ssdec f10 (.in(data[3:0]), .enable(state == DISPLAY), .out(ss7[6:0]));
assign right = instruction[7:0];
assign left[2:0] = state;
assign left[7] = CPUEnable;
assign left[6] = writeFPGA;
assign left[5] = FPGAEnable;
always_comb begin
    currCPUEnable = 0;
    currFPGAEnable = 1;
    currFPGAWrite = 1;
    casez(state)
        NUM1: begin
            if(|buttons[9:0]) begin
                nextData = {data[3:0], halfData[3:0]};
                //need to fix
                address = 32'd220;
            end else begin
                nextData = data;
                address = 32'd320;
            end
        end
        3'b001: begin
            if(|buttons[19:16]) begin
                nextData = {3'b0, halfData};
                //need to fix
                address = 32'd260;
            end else begin
                nextData = data;
                address = 32'd320;
            end
        end
        NUM2: begin
            if(|buttons[9:0]) begin
                nextData = {data[3:0], halfData[3:0]};
                //need to fix
                address = 32'd240;
            end else begin
                nextData = data;
                address = 32'd320;
            end
        end
        RESULT: begin
            currCPUEnable = 1;
            currFPGAEnable = 0;
            currFPGAWrite = 0;
            address = 32'd320;
            nextData = data;
        end
        DISPLAY: begin
            //need to fix, result address
            address = 32'd280;
            nextData = dataIn[7:0];
            currFPGAWrite = 0;
        end
        default: begin
            nextData = data;
            address = 32'd320;
        end
    endcase
end

endmodule

module bcd(
input logic [7:0] in,
output logic [31:0] out
);
assign out = in[7:4] * 10 + {28'b0, in[3:0]};
endmodule