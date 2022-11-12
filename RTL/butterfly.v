module butterfly #(
    parameter Q = 8,
    parameter DATA_WIDTH = 16
) (
    input   wire    [DATA_WIDTH-1:0] in1_r,in1_i,
    input   wire    [DATA_WIDTH-1:0] in2_r,in2_i,
    input   wire    [DATA_WIDTH-1:0] w_r,w_i,
    output  reg     [DATA_WIDTH-1:0] out1_r,out1_i,
    output  reg     [DATA_WIDTH-1:0] out2_r,out2_i
);

reg [DATA_WIDTH-1:0] pre_r, pre_i;

always @(*) begin
    pre_r  = multiply(in2_r,w_r) - multiply(in2_i,w_i);
    pre_i  = multiply(in2_r,w_i) + multiply(in2_i,w_r);
    out1_r = in1_r + pre_r;
    out1_i = in1_i + pre_i;
    out2_r = in1_r - pre_r;
    out2_i = in1_i - pre_i;
end



function [DATA_WIDTH-1:0] multiply;
    input [DATA_WIDTH-1:0]       A,B;
    reg   [DATA_WIDTH-1:0]     positive_A, positive_B;
    reg   [2*DATA_WIDTH-1:0]     long_multiply,signed_multiply;

    begin
        /*we want to make multiply operation on positive numbers*/
        positive_A = A[DATA_WIDTH-1]? -A: A;   
        positive_B = B[DATA_WIDTH-1]? -B: B;
        long_multiply = positive_A * positive_B;
        /*the result should be negative if any input is negative*/
        signed_multiply = A[DATA_WIDTH-1]^B[DATA_WIDTH-1]? -long_multiply:long_multiply; 
        /*we window the result containing half of the integer part and half of the fractional part*/
        multiply = signed_multiply[Q+DATA_WIDTH-1:Q];    
    end
    
endfunction
    
endmodule