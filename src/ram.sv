// module ram (
// input logic clk, nRst, write_enable, read_enable,
// input logic [11:0] address_DM, address_IM,
// input logic [31:0] data_in,
// output reg [31:0] data_out,
// output reg [31:0] instr_out,
// output logic pc_enable,
// );
// reg [31:0] memory [4095:0];
 
// typedef enum logic {IDLE, WAIT} StateType;
// StateType state, next_state;
 
// initial begin
// $readmemh("fill.mem", memory);
// end
 
// always_ff @(posedge clk, negedge nRst) begin
// if (!nRst) begin
// state <= IDLE;
// // data_out <= '0;
// // instr_out <= '0;
// end else begin
// state <= next_state;
// // data_out <= memory[address_DM];
// // instr_out <= memory[address_IM];
// end
// end
 
// // assign data_out = memory[address_DM];
// // assign instr_out = memory[address_IM];
 
// always_comb begin
// pc_enable = 1'b1;
// next_state = state;
// case (state)
// IDLE: begin
// if (read_enable | write_enable) begin
// pc_enable = 1'b0;
// next_state = WAIT;
// end
// end
// WAIT: begin
// // pc_enable = 1'b1;
// next_state = IDLE;
// end
// default:;
// endcase
// end
 
// always @(posedge clk) begin
// if (write_enable) begin
// memory[address_DM>>2] <= data_in;
// end
// data_out <= memory[address_DM>>2];
// instr_out <= memory[address_IM>>2];
// end
 
// endmodule

module ram (din, addr, write_en, clk, dout);// 512x8
parameter addr_width = 12;
parameter data_width = 32;
input [addr_width-1:0] addr;
input [data_width-1:0] din;
input write_en, clk;
output [data_width-1:0] dout;
reg [data_width-1:0] dout; // Register for output.
reg [data_width-1:0] mem [(1<<addr_width)-1:0];
 
initial begin
    $readmemh("fill.mem", mem);
end
 
always @(posedge clk)begin
if (write_en)
    mem[(addr)] <= din;
    dout = mem[addr]; // Output register controlled by clock.
end
 
 
endmodule