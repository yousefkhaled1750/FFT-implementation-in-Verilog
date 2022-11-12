module Butterfly_tb  ();
    
    
    /* FFT parameters */
    parameter F_POINT_tb = 8;
    parameter DATA_WIDTH_tb = 16;
    parameter ADDR_WIDTH_tb = 3;
    parameter N_tb = 2**ADDR_WIDTH_tb;
    parameter error_bits = 4;
    integer i;

/* Inputs real signals */
reg [DATA_WIDTH_tb - 1 : 0]  input1_real_tb [N_tb - 1 : 0];
reg [DATA_WIDTH_tb - 1 : 0]  input2_real_tb [N_tb - 1 : 0];
/* Inputs imag signals */
reg [DATA_WIDTH_tb - 1 : 0]  input1_imag_tb [N_tb - 1 : 0];
reg [DATA_WIDTH_tb - 1 : 0]  input2_imag_tb [N_tb - 1 : 0];
/* Output real signals */
reg [DATA_WIDTH_tb - 1 : 0]  output1_real_tb [N_tb - 1 : 0];
reg [DATA_WIDTH_tb - 1 : 0]  output2_real_tb [N_tb - 1 : 0];
/* Output imag signals */
reg [DATA_WIDTH_tb - 1 : 0]  output1_imag_tb [N_tb - 1 : 0];
reg [DATA_WIDTH_tb - 1 : 0]  output2_imag_tb [N_tb - 1 : 0];
/* reference output real signals */
reg [DATA_WIDTH_tb - 1 : 0]  output1_real_ref_tb [N_tb - 1 : 0];
reg [DATA_WIDTH_tb - 1 : 0]  output2_real_ref_tb [N_tb - 1 : 0];
/* reference output imag signals */
reg [DATA_WIDTH_tb - 1 : 0]  output1_imag_ref_tb [N_tb - 1 : 0];
reg [DATA_WIDTH_tb - 1 : 0]  output2_imag_ref_tb [N_tb - 1 : 0];

// butturfly unit signals
reg     [DATA_WIDTH_tb-1:0] in1_r_tb,
                            in1_i_tb,
                            in2_r_tb,
                            in2_i_tb;
wire    [DATA_WIDTH_tb-1:0] w_r_tb,
                            w_i_tb;
wire    [DATA_WIDTH_tb-1:0] out1_r_tb,
                            out1_i_tb,
                            out2_r_tb,
                            out2_i_tb;
// rom signal
reg     [ADDR_WIDTH_tb-1:0] address_line_tb;

//error signal 
reg [DATA_WIDTH_tb-1:0] output1_real_err_tb,
                        output1_imag_err_tb,
                        output2_real_err_tb,
                        output2_imag_err_tb;

initial begin
    $dumpfile("butterfly.vcd");
    $dumpvars;
        $readmemb("../Reference/input1_8_real.txt",input1_real_tb);
        $readmemb("../Reference/input1_8_imag.txt",input1_imag_tb);
        $readmemb("../Reference/input2_8_real.txt",input2_real_tb);
        $readmemb("../Reference/input2_8_imag.txt",input2_imag_tb);
        $readmemb("../Reference/output1_8_real.txt",output1_real_ref_tb);
        $readmemb("../Reference/output1_8_imag.txt",output1_imag_ref_tb);
        $readmemb("../Reference/output2_8_real.txt",output2_real_ref_tb);
        $readmemb("../Reference/output2_8_imag.txt",output2_imag_ref_tb);

        /* iterating over the input indices and compare the results */
        for (i = 0; i < N_tb; i = i+1 ) begin
            in1_r_tb = input1_real_tb[i];
            in1_i_tb = input1_imag_tb[i];
            in2_r_tb = input2_real_tb[i];
            in2_i_tb = input2_imag_tb[i];
            address_line_tb = i;
            #5
            output1_real_tb[i] = out1_r_tb;    
            output2_real_tb[i] = out2_r_tb;   
            output1_imag_tb[i] = out1_i_tb;   
            output2_imag_tb[i] = out2_i_tb; 
            // we are shifting the values to overcome the error percentage happened due to the accuracy
            output1_real_err_tb = (output1_real_tb[i])>>error_bits - (output1_real_ref_tb[i])>>error_bits;
            output1_imag_err_tb = (output1_imag_tb[i])>>error_bits - (output1_real_ref_tb[i])>>error_bits;
            output2_real_err_tb = (output2_real_tb[i])>>error_bits - (output2_real_ref_tb[i])>>error_bits;
            output2_imag_err_tb = (output2_imag_tb[i])>>error_bits - (output2_real_ref_tb[i])>>error_bits;
            $display("output1[%d]_real: difference = %b_%b",i, output1_real_err_tb[DATA_WIDTH_tb-1:F_POINT_tb], output1_real_err_tb[F_POINT_tb-1:0]); 
            $display("output1[%d]_imag: difference = %b_%b",i, output1_imag_err_tb[DATA_WIDTH_tb-1:F_POINT_tb], output1_imag_err_tb[F_POINT_tb-1:0]); 
            $display("output2[%d]_real: difference = %b_%b",i, output2_real_err_tb[DATA_WIDTH_tb-1:F_POINT_tb], output2_real_err_tb[F_POINT_tb-1:0]); 
            $display("output2[%d]_imag: difference = %b_%b",i, output2_imag_err_tb[DATA_WIDTH_tb-1:F_POINT_tb], output2_real_err_tb[F_POINT_tb-1:0]); 
//            $display("output1[%d] in  matlab  = %b_%b",i, output1_real_ref_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output1_real_ref_tb[i][F_POINT_tb-1:0]);
//            $display("                      + j %b_%b\n", output1_imag_ref_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output1_imag_ref_tb[i][F_POINT_tb-1:0]);
//            $display("output1[%d] in  verilog = %b_%b",i, output1_real_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output1_real_tb[i][F_POINT_tb-1:0]);  
//            $display("                     + j %b_%b\n", output1_imag_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output1_imag_tb[i][F_POINT_tb-1:0]);
//            $display("output2[%d] in  matlab  = %b_%b",i, output2_real_ref_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output2_real_ref_tb[i][F_POINT_tb-1:0]);
//            $display("                     + j %b_%b\n", output2_imag_ref_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output2_imag_ref_tb[i][F_POINT_tb-1:0]);
//            $display("output2[%d] in  verilog = %b_%b",i, output2_real_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output2_real_tb[i][F_POINT_tb-1:0]);  
//            $display("                     + j %b_%b\n", output2_imag_tb[i][DATA_WIDTH_tb-1:F_POINT_tb], output2_imag_tb[i][F_POINT_tb-1:0]);
        end


end

butterfly #(.Q(F_POINT_tb), .DATA_WIDTH(DATA_WIDTH_tb)) DUT_butterfly 
(
.in1_r(in1_r_tb),
.in1_i(in1_i_tb),
.in2_r(in2_r_tb),
.in2_i(in2_i_tb),
.w_r(w_r_tb),
.w_i(w_i_tb),
.out1_r(out1_r_tb),
.out1_i(out1_i_tb),
.out2_r(out2_r_tb),
.out2_i(out2_i_tb)   
);

twiddle_rom #(.DATA_WIDTH(DATA_WIDTH_tb), .ADDR_WIDTH(ADDR_WIDTH_tb)) DUT_rom 
(
.address_line(address_line_tb),
.w_r(w_r_tb),
.w_i(w_i_tb)
);


endmodule