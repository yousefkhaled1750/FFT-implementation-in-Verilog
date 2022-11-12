module FFT_tb ();
    
    /* FFT parameters */
    parameter F_POINT_tb = 8;
    parameter DATA_WIDTH_tb = 16;
    parameter STAGES_tb = 4 ;
    parameter ADDR_WIDTH_tb = STAGES_tb;
    parameter N_tb = 2**STAGES_tb;
    parameter error_bits = 5;
    integer i;


/* Input real signals */
reg [DATA_WIDTH_tb - 1 : 0]  input_real_tb [N_tb - 1 : 0];
/* Input imag signals */
reg [DATA_WIDTH_tb - 1 : 0]  input_imag_tb [N_tb - 1 : 0];
/* Output real signals */
wire [DATA_WIDTH_tb - 1 : 0]  output_real_tb [N_tb - 1 : 0];
/* Output imag signals */
wire [DATA_WIDTH_tb - 1 : 0]  output_imag_tb [N_tb - 1 : 0];
/* reference output real signals */
reg [DATA_WIDTH_tb - 1 : 0]  output_real_ref_tb [N_tb - 1 : 0];
/* reference output imag signals */
reg [DATA_WIDTH_tb - 1 : 0]  output_imag_ref_tb [N_tb - 1 : 0];
/* error signals */
reg [DATA_WIDTH_tb - 1 : 0]  output_real_err_tb;
reg [DATA_WIDTH_tb - 1 : 0]  output_imag_err_tb;


initial begin
        $dumpfile("FFT_16.vcd");
        $dumpvars;
        $readmemb("../Reference/input_16_real.txt",input_real_tb);
        $readmemb("../Reference/input_16_imag.txt",input_imag_tb);
        $readmemb("../Reference/output_16_real.txt",output_real_ref_tb);
        $readmemb("../Reference/output_16_imag.txt",output_imag_ref_tb);

        #10
        /* display the results of fft module and the reference model */
        for (i = 0; i < N_tb; i = i+1 ) begin
        if (output_real_tb[i]>output_real_ref_tb[i]) begin
            output_real_err_tb = (output_real_tb[i]>>error_bits) - (output_real_ref_tb[i]>>error_bits);
        end else begin
            output_real_err_tb = (output_real_ref_tb[i]>>error_bits) - (output_real_tb[i]>>error_bits);
        end
        if (output_imag_tb[i]>output_imag_ref_tb[i]) begin
            output_imag_err_tb = (output_imag_tb[i]>>error_bits) - (output_imag_ref_tb[i]>>error_bits);
        end else begin
            output_imag_err_tb = (output_imag_ref_tb[i]>>error_bits) - (output_imag_tb[i]>>error_bits);
        end
        $display("output[%d] in  matlab  = %b_%b",i, output_real_ref_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output_real_ref_tb[i][F_POINT_tb-1:0]);
        $display("                     + j %b_%b\n", output_imag_ref_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output_imag_ref_tb[i][F_POINT_tb-1:0]);
        $display("output[%d] in  verilog = %b_%b",i, output_real_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output_real_tb[i][F_POINT_tb-1:0]);  
        $display("                     + j %b_%b\n", output_imag_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output_imag_tb[i][F_POINT_tb-1:0]);
        $display("difference: %b_%b",output_real_err_tb[DATA_WIDTH_tb-1:F_POINT_tb], output_real_err_tb[F_POINT_tb-1:0] );
        $display("+ j %b_%b",output_imag_err_tb[DATA_WIDTH_tb-1:F_POINT_tb], output_imag_err_tb[F_POINT_tb-1:0]);
        $display("/*************************************************************/");
        end

end

//module fft_16_DIT #(
//    parameter DATA_WIDTH = 16,
//    parameter F_POINT = 8
//) (
//    input   wire [DATA_WIDTH-1:0] x0_r,x1_r,x2_r,x3_r,x4_r,x5_r,x6_r,x7_r,
//    input   wire [DATA_WIDTH-1:0] x8_r,x9_r,x10_r,x11_r,x12_r,x13_r,x14_r,x15_r,
//    input   wire [DATA_WIDTH-1:0] x0_i,x1_i,x2_i,x3_i,x4_i,x5_i,x6_i,x7_i,
//    input   wire [DATA_WIDTH-1:0] x8_i,x9_i,x10_i,x11_i,x12_i,x13_i,x14_i,x15_i,
//    output  reg  [DATA_WIDTH-1:0] y0_r,y1_r,y2_r,y3_r,y4_r,y5_r,y6_r,y7_r,
//    output  reg  [DATA_WIDTH-1:0] y8_r,y9_r,y10_r,y11_r,y12_r,y13_r,y14_r,y15_r,
//    output  reg  [DATA_WIDTH-1:0] y0_i,y1_i,y2_i,y3_i,y4_i,y5_i,y6_i,y7_i,
//    output  reg  [DATA_WIDTH-1:0] y8_i,y9_i,y10_i,y11_i,y12_i,y13_i,y14_i,y15_i
//);
fft_16_DIT #(.DATA_WIDTH(DATA_WIDTH_tb), .F_POINT(F_POINT_tb)) DUT_FFT
(
.x0_r(input_real_tb[0])        ,.x1_r(input_real_tb[1])       ,.x2_r(input_real_tb[2])       ,.x3_r(input_real_tb[3]),
.x4_r(input_real_tb[4])       ,.x5_r(input_real_tb[5])       ,.x6_r(input_real_tb[6])       ,.x7_r(input_real_tb[7]),
.x8_r(input_real_tb[8])        ,.x9_r(input_real_tb[9])       ,.x10_r(input_real_tb[10])     ,.x11_r(input_real_tb[11]),
.x12_r(input_real_tb[12])     ,.x13_r(input_real_tb[13])    ,.x14_r(input_real_tb[14])   ,.x15_r(input_real_tb[15]),
.x0_i(input_imag_tb[0])        ,.x1_i(input_imag_tb[1])       ,.x2_i(input_imag_tb[2])       ,.x3_i(input_imag_tb[3]),
.x4_i(input_imag_tb[4])       ,.x5_i(input_imag_tb[5])       ,.x6_i(input_imag_tb[6])       ,.x7_i(input_imag_tb[7]),
.x8_i(input_imag_tb[8])        ,.x9_i(input_imag_tb[9])       ,.x10_i(input_imag_tb[10])     ,.x11_i(input_imag_tb[11]),
.x12_i(input_imag_tb[12])     ,.x13_i(input_imag_tb[13])    ,.x14_i(input_imag_tb[14])   ,.x15_i(input_imag_tb[15]),

.y0_r(output_real_tb[0])        ,.y1_r(output_real_tb[1])       ,.y2_r(output_real_tb[2])       ,.y3_r(output_real_tb[3]),
.y4_r(output_real_tb[4])       ,.y5_r(output_real_tb[5])       ,.y6_r(output_real_tb[6])       ,.y7_r(output_real_tb[7]),
.y8_r(output_real_tb[8])        ,.y9_r(output_real_tb[9])       ,.y10_r(output_real_tb[10])     ,.y11_r(output_real_tb[11]),
.y12_r(output_real_tb[12])     ,.y13_r(output_real_tb[13])    ,.y14_r(output_real_tb[14])   ,.y15_r(output_real_tb[15]),
.y0_i(output_imag_tb[0])        ,.y1_i(output_imag_tb[1])       ,.y2_i(output_imag_tb[2])       ,.y3_i(output_imag_tb[3]),
.y4_i(output_imag_tb[4])       ,.y5_i(output_imag_tb[5])       ,.y6_i(output_imag_tb[6])       ,.y7_i(output_imag_tb[7]),
.y8_i(output_imag_tb[8])        ,.y9_i(output_imag_tb[9])       ,.y10_i(output_imag_tb[10])     ,.y11_i(output_imag_tb[11]),
.y12_i(output_imag_tb[12])     ,.y13_i(output_imag_tb[13])    ,.y14_i(output_imag_tb[14])   ,.y15_i(output_imag_tb[15])
);

endmodule