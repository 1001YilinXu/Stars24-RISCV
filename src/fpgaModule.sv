
typedef enum logic [2:0] {
    NUM1, OPSEL, NUM2, RESULT, DISPLAY
} stateLog;

module fpgaModule (
input logic clk, nrst,
input logic [31:0] instruction, dataIn, writeData,
input logic [19:0] buttons,
output logic [7:0] ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, right, left, 
output logic [31:0] address, dataOut,
output logic FPGAEnable, writeFPGA, CPUEnable, nrstFPGA
);

//logic definitions
    stateLog state, nextState;
    logic en, enData;
    logic currCPUEnable;
    logic currFPGAEnable;
    logic currFPGAWrite;
    logic instructionTrue, nextTrue;
    logic [7:0] data, nextData, hexop, nextHex;
    logic [15:0] halfData;
		logic [127:0] row1, row2, nextRow1, nextRow2;
    logic keyStrobe, key;
    
    assign CPUEnable = currCPUEnable;
    assign writeFPGA = currFPGAWrite;
    assign FPGAEnable = currFPGAEnable;

edgeDetector edg(.clk(clk), .nRst_i(nrst), .button_i(key), .button_p(en));
edgeDetector edg2(.clk(clk), .nRst_i(nrst), .button_i(~keyStrobe), .button_p(enData));
keypad pad (.clk(clk), .rst(nrst), .receive_ready(keyStrobe), .data_received(halfData), .read_row(buttons[3:0]), .scan_col({left[2], left[4], left[6], left[0]}));
lcd1602 lcd (.clk(clk), .rst(nrst), .row_1(row1), .row_2(row2), .lcd_en(left[5]), .lcd_rw(left[3]), .lcd_rs(left[1]), .lcd_data(right));
//always ff to change logic to next
// always_ff@(posedge clk, negedge nrst) begin
//     if (!nrst) begin
//         state <= NUM1;
//     end
//     else if (en | instructionTrue) begin
//         state <= nextState;
//     end
// end

always_ff@(posedge clk, negedge nrst) begin
    if (!nrst) begin
        state <= NUM1;
    end else if (instructionTrue) begin
			state <= nextState;
		end else if (enData) begin
        state <= nextState;
		end 
end

always_ff@(posedge clk, negedge nrst)begin
    if(!nrst) begin
        data <= 0;
    end else if(enData) begin
        data <= nextData;
    end
end

always_ff@(posedge clk, negedge nrst)begin
	if(!nrst) begin
		row1 <= 0;
		row2 <= 0;
		hexop <= 0;
	end else begin
		row1 <= nextRow1;
		row2 <= nextRow2;
		hexop <= nextHex;
	end
end

always_comb begin
    if(instruction == 32'hffffffff)
        instructionTrue = 1;
    else 
        instructionTrue = 0;

    casez ({state, halfData[7:0] == 8'b00100011})
    {NUM1, 1'b1}: nextState = OPSEL;
    {OPSEL, 1'b1}: nextState = NUM2;
    {NUM2, 1'b1}: nextState = RESULT;
    {RESULT, 1'b0}: begin
    if (instructionTrue) 
        nextState = DISPLAY;
    else 
        nextState = RESULT;
    end
    {DISPLAY, 1'b1}: nextState = NUM1;
    default: nextState = state;
    endcase
end

keysync f1 (.clk(clk), .keyin(buttons[19:0]), .keyclk(key), .rst(nrst), .keyout());
bcd f2 (.in(data), .out(dataOut));
ssdec f3 (.in(data[7:4]), .enable(state == NUM2), .out(ss2[6:0]));
ssdec f4 (.in(data[3:0]), .enable(state == NUM2), .out(ss1[6:0]));
ssdec f5 (.in(data[7:4]), .enable(state == OPSEL), .out(ss4[6:0]));
ssdec f6 (.in(data[3:0]), .enable(state == OPSEL), .out(ss3[6:0]));
ssdec f7 (.in(data[7:4]), .enable(state == NUM1), .out(ss6[6:0]));
ssdec f8 (.in(data[3:0]), .enable(state == NUM1), .out(ss5[6:0]));
ssdec f9 (.in(dataIn[7:4]), .enable(state == DISPLAY), .out(ss8[6:0]));
ssdec f10 (.in(dataIn[3:0]), .enable(state == DISPLAY), .out(ss7[6:0]));

always_comb begin
    currCPUEnable = 0;
    currFPGAEnable = 1;
    currFPGAWrite = 1;
    nrstFPGA = 1;
		nextHex = hexop;
		nextRow1 = row1;
		nextRow2 = row2;
    casez(state)
        NUM1: begin
            if(|buttons[3:0] && (halfData[7:0] != 8'b00100011)) begin
                nextData = {data[3:0], halfData[3:0]};
                //need to fix
                address = 32'd220;
								nextRow1 = {{4'b0011, data[7:4]}, {4'b0011, data[3:0]}, row1[111:0]};
            end else begin
                nextData = data;
                address = 32'd320;
            end
        end
        OPSEL: begin
            if(|buttons[3:0] && (halfData[7:0] != 8'b00100011)) begin
                nextData = {4'b0, halfData[3:0]};
                //need to fix
                address = 32'd260;
								casez(halfData[7:0])
									8'hD: nextHex = 8'b11111101; //div
									8'hC: nextHex = 8'b01111000; //mul
									8'hB: nextHex = 8'b00101101; //sub
									8'hA: nextHex = 8'b00101011; //add
									default: nextHex = hexop;
								endcase
								nextRow1 = {row1[127:64], nextHex, row1[55:0]};
            end else begin
                nextData = data;
                address = 32'd320;
            end
        end
        NUM2: begin
            if(|buttons[3:0] && (halfData[7:0] != 8'b00100011)) begin
                nextData = {data[3:0], halfData[3:0]};
                //need to fix
                address = 32'd240;
								nextRow1 = {row1[127:16], {4'b0011, data[7:4]}, {4'b0011, data[3:0]}};
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
            nrstFPGA = 0;
						nextRow1 = row1;
						nextRow2 = {row2[127:24], 8'b00111101, {4'b0011, dataIn[7:4]}, {4'b0011, dataIn[3:0]}};
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