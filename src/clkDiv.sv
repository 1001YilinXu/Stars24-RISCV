module clkDiv(input logic clk, nRST,
                input logic clkStart,
                input logic clear,
                output logic clkOut);
                
  logic [6:0] nextCount, count;

    always_ff@(posedge clk, negedge nRST)
        if (!nRST)
            count <= 0;
        else
            count <= nextCount;

    always_comb begin
        if (count == 7'd20) begin
            nextCount = 0;
            clkOut = 1;
        end
        else if (clkStart == 1 | clear == 1)begin
            nextCount = count + 1;
            clkOut = 0;
        end
        else begin
            nextCount = count;
            clkOut = 0;
        end

    end
  endmodule