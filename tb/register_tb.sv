`include "src/register_file_if.vh"
`include "src/register_file.sv"
`include "src/cpu_pkg.vh"
`timescale 10ns / 1ns

module register_tb;
import cpu_pkg::*;
	register_file_if rfif();

logic clk = 0, nrst;

parameter CLK_PER = 10;
always #(CLK_PER/2) clk ++;

test PROG(.regif, .clk, .nrst);
register_file DUT(.clk(clk), .nRST(nrst), rfif);

endmodule

program test(
	input logic clk,
	input logic nrst,
	register_file_if.tb rfif
);

logic tb_check_output;
logic [4:0] tb_index; 
integer tb_testnum = 0;
string tb_test_case;


task reset_dut;
  @(negedge clk);
  tb_nRst_i = 1'b0; 
  @(negedge clk);
  @(negedge clk);
  tb_nRst_i = 1'b1;
  @(posedge clk);
endtask

task check_reg1;
input logic[31:0] tb_exp_reg_data;
	@(negedge clk);
	if(regif.read_data1 == tb_exp_reg_data)
		$info("Correct reg data: %0d.", tb_exp_reg_data);
	else
		$error("Incorrect reg data. Actual: %0d. Exp: %0d.", regif.read_data1, tb_exp_reg_data); 
endtask

task check_reg2;
input logic[31:0] tb_exp_reg_data;
	@(negedge clk);
	if(regif.read_data2 == tb_exp_reg_data)
		$info("Correct reg data: %0d.", tb_exp_reg_data);
	else
		$error("Incorrect reg data. Actual: %0d. Exp: %0d.", regif.read_data1, tb_exp_reg_data); 
endtask

initial begin
$dumpfile("dump.vcd");
$dumpvars; 

tb_testnum = 0;
tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
nrst = 1;
rfif.read_index1 = 0;
#(5);
check_reg1('0);
@(negedge clk);
check_reg1('0);
@(negedge clk);
check_reg1('0);

end


endprogram