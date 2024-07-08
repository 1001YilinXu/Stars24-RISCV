/*
    Module Name: tb_stop_watch
    Description: Test bench for stop_watch module
*/

`timescale 1ms / 100us

`include "src/alu_if.vh"
`include "src/cpu_pkg.vh"



module signExtender_tb ();

    // Testbench parameters
    parameter WAIT = 5;

    logic tb_checking_outputs; 
    integer tb_test_num;

    // DUT (design under test) ports
    //not needed because of interface !!

    // Task to check ALU output
    task check_immOut;
    input logic[31:0] exp_signEx_out; 
    begin
        tb_checking_outputs = 1'b1;
        if(signExif.immOut == exp_signEx_out)
            $info("Correct signEx_Out: %0d.", exp_signEx_out);
        else
            $error("Incorrect signEx_out. Expected: %0d. Actual: %0d.", exp_signEx_out, signExif.immOut); 
        tb_checking_outputs = 1'b0;  
        #(WAIT);
    end
    endtask

    signExtender_if signExif ();
    startTB TB_prog (.signExif);
    signExtender tb_signExif(signExif);

endmodule

    // DUT Portmap

program startTB(
    signExtender_if.tb signExif
);
initial begin
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 



$finish;
end
endprogram