module fft_16_DIT #(
    parameter DATA_WIDTH = 16,
    parameter F_POINT = 8
) (
    input   wire [DATA_WIDTH-1:0] x0_r,x1_r,x2_r,x3_r,x4_r,x5_r,x6_r,x7_r,
    input   wire [DATA_WIDTH-1:0] x8_r,x9_r,x10_r,x11_r,x12_r,x13_r,x14_r,x15_r,
    input   wire [DATA_WIDTH-1:0] x0_i,x1_i,x2_i,x3_i,x4_i,x5_i,x6_i,x7_i,
    input   wire [DATA_WIDTH-1:0] x8_i,x9_i,x10_i,x11_i,x12_i,x13_i,x14_i,x15_i,
    output  reg  [DATA_WIDTH-1:0] y0_r,y1_r,y2_r,y3_r,y4_r,y5_r,y6_r,y7_r,
    output  reg  [DATA_WIDTH-1:0] y8_r,y9_r,y10_r,y11_r,y12_r,y13_r,y14_r,y15_r,
    output  reg  [DATA_WIDTH-1:0] y0_i,y1_i,y2_i,y3_i,y4_i,y5_i,y6_i,y7_i,
    output  reg  [DATA_WIDTH-1:0] y8_i,y9_i,y10_i,y11_i,y12_i,y13_i,y14_i,y15_i
);
    
    localparam STAGES = 4 ;
    localparam ADDR_WIDTH = STAGES;
    localparam N = 2**STAGES;

    genvar i,j ;
/*implementation of twiddle rom (temporarily)*/
reg [DATA_WIDTH - 1 : 0]  real_twiddle [2**ADDR_WIDTH - 1 : 0];
reg [DATA_WIDTH - 1 : 0]  imag_twiddle [2**ADDR_WIDTH - 1 : 0];

initial begin
    $readmemb("../Reference/twiddle_factor_16_real.txt",real_twiddle);
    $readmemb("../Reference/twiddle_factor_16_imag.txt",imag_twiddle);
end
/*********************************************/
/* reg [DATA_WIDTH - 1 : 0]  stage_s [STAGES*(2**ADDR_WIDTH) - 1 : 0];  */
wire [DATA_WIDTH - 1 : 0]  data_in_r [2**ADDR_WIDTH - 1 : 0];
wire [DATA_WIDTH - 1 : 0]  data_in_i [2**ADDR_WIDTH - 1 : 0];
/* implementation of a register array containing the inputs */
wire [DATA_WIDTH - 1 : 0]  stage_0_r [2**ADDR_WIDTH - 1 : 0];
wire [DATA_WIDTH - 1 : 0]  stage_0_i [2**ADDR_WIDTH - 1 : 0];
/* implementation of a register array containing the output results */
wire [DATA_WIDTH - 1 : 0]  stage_4_r [2**ADDR_WIDTH - 1 : 0];
wire [DATA_WIDTH - 1 : 0]  stage_4_i [2**ADDR_WIDTH - 1 : 0];
/* implementation of a register array containing the results of 1st stage*/
wire [DATA_WIDTH - 1 : 0]  stage_1_r [2**ADDR_WIDTH - 1 : 0];
wire [DATA_WIDTH - 1 : 0]  stage_1_i [2**ADDR_WIDTH - 1 : 0];
/* implementation of a register array containing the results of 2nd stage*/
wire [DATA_WIDTH - 1 : 0]  stage_2_r [2**ADDR_WIDTH - 1 : 0];
wire [DATA_WIDTH - 1 : 0]  stage_2_i [2**ADDR_WIDTH - 1 : 0];
/* implementation of a register array containing the results of 3rd stage*/
wire [DATA_WIDTH - 1 : 0]  stage_3_r [2**ADDR_WIDTH - 1 : 0];
wire [DATA_WIDTH - 1 : 0]  stage_3_i [2**ADDR_WIDTH - 1 : 0];


assign    data_in_r[0] = x0_r;     assign data_in_r[1] = x1_r;   assign data_in_r[2] = x2_r;
assign    data_in_r[3] = x3_r;     assign data_in_r[4] = x4_r;   assign data_in_r[5] = x5_r;
assign    data_in_r[6] = x6_r;     assign data_in_r[7] = x7_r;   assign data_in_r[8] = x8_r;
assign    data_in_r[9] = x9_r;     assign data_in_r[10] = x10_r; assign data_in_r[11] = x11_r;
assign    data_in_r[12] = x12_r;   assign data_in_r[13] = x13_r; assign data_in_r[14] = x14_r;
assign    data_in_r[15] = x15_r; 
assign    data_in_i[0] = x0_i;     assign data_in_i[1] = x1_i;   assign data_in_i[2] = x2_i;
assign    data_in_i[3] = x3_i;     assign data_in_i[4] = x4_i;   assign data_in_i[5] = x5_i;
assign    data_in_i[6] = x6_i;     assign data_in_i[7] = x7_i;   assign data_in_i[8] = x8_i;
assign    data_in_i[9] = x9_i;     assign data_in_i[10] = x10_i; assign data_in_i[11] = x11_i;
assign    data_in_i[12] = x12_i;   assign data_in_i[13] = x13_i; assign data_in_i[14] = x14_i;
assign    data_in_i[15] = x15_i;


//bit reverse order (will be done dynamically in the next assignment )
assign    stage_0_r[0]  = data_in_r[0];  assign stage_0_r[1]  = data_in_r[8];  assign stage_0_r[2]  = data_in_r[4];
assign    stage_0_r[3]  = data_in_r[12]; assign stage_0_r[4]  = data_in_r[2];  assign stage_0_r[5]  = data_in_r[10];
assign    stage_0_r[6]  = data_in_r[6];  assign stage_0_r[7]  = data_in_r[14]; assign stage_0_r[8]  = data_in_r[1];
assign    stage_0_r[9]  = data_in_r[9];  assign stage_0_r[10] = data_in_r[5];  assign stage_0_r[11] = data_in_r[13];
assign    stage_0_r[12] = data_in_r[3];  assign stage_0_r[13] = data_in_r[11]; assign stage_0_r[14] = data_in_r[7];
assign    stage_0_r[15] = data_in_r[15];
assign    stage_0_i[0]  = data_in_i[0];  assign stage_0_i[1]  = data_in_i[8];  assign stage_0_i[2]  = data_in_i[4];
assign    stage_0_i[3]  = data_in_i[12]; assign stage_0_i[4]  = data_in_i[2];  assign stage_0_i[5]  = data_in_i[10];
assign    stage_0_i[6]  = data_in_i[6];  assign stage_0_i[7]  = data_in_i[14]; assign stage_0_i[8]  = data_in_i[1];
assign    stage_0_i[9]  = data_in_i[9];  assign stage_0_i[10] = data_in_i[5];  assign stage_0_i[11] = data_in_i[13];
assign    stage_0_i[12] = data_in_i[3];  assign stage_0_i[13] = data_in_i[11]; assign stage_0_i[14] = data_in_i[7];
assign    stage_0_i[15] = data_in_i[15];



//stage 1
generate
    for (i = 0; i < N>>1; i = i + 1)
    begin
       butterfly #(.Q(F_POINT), .DATA_WIDTH(DATA_WIDTH)) instance_name 
       (
        .in1_r(stage_0_r[2*i]),     .in1_i(stage_0_i[2*i]),
        .in2_r(stage_0_r[2*i+1]),   .in2_i(stage_0_i[2*i+1]),
        .w_r(real_twiddle[0]),      .w_i(imag_twiddle[0]),
        .out1_r(stage_1_r[2*i]),    .out1_i(stage_1_i[2*i]),
        .out2_r(stage_1_r[2*i+1]),  .out2_i(stage_1_i[2*i+1])
       );
    end    
endgenerate

//stage 2
generate
    for (i = 0; i < (N>>2); i = i+1)
    begin
        for (j = 0;j<2 ; j = j+1 ) begin
           butterfly #(.Q(F_POINT), .DATA_WIDTH(DATA_WIDTH)) instance_name 
            (
             .in1_r(stage_1_r[4*i+j]),     .in1_i(stage_1_i[4*i+j]),
             .in2_r(stage_1_r[4*i+j+2]),   .in2_i(stage_1_i[4*i+j+2]),
             .w_r(real_twiddle[4*j]),      .w_i(imag_twiddle[4*j]),
             .out1_r(stage_2_r[4*i+j]),    .out1_i(stage_2_i[4*i+j]),
             .out2_r(stage_2_r[4*i+j+2]),  .out2_i(stage_2_i[4*i+j+2])
            );  
        end
    end
endgenerate

//stage 3
generate
    for (i = 0; i < (N>>3); i = i+1)
    begin
        for (j = 0;j<4 ; j = j+1 ) begin
           butterfly #(.Q(F_POINT), .DATA_WIDTH(DATA_WIDTH)) instance_name 
            (
             .in1_r(stage_2_r[8*i+j]),     .in1_i(stage_2_i[8*i+j]),
             .in2_r(stage_2_r[8*i+j+4]),   .in2_i(stage_2_i[8*i+j+4]),
             .w_r(real_twiddle[2*j]),      .w_i(imag_twiddle[2*j]),
             .out1_r(stage_3_r[8*i+j]),    .out1_i(stage_3_i[8*i+j]),
             .out2_r(stage_3_r[8*i+j+4]),  .out2_i(stage_3_i[8*i+j+4])
            );  
        end
    end
endgenerate

//stage 4
generate
    for (i = 0; i < (N>>4); i = i+1)
    begin
        for (j = 0;j<8 ; j = j+1 ) begin
           butterfly #(.Q(F_POINT), .DATA_WIDTH(DATA_WIDTH)) instance_name 
            (
             .in1_r(stage_3_r[16*i+j]),     .in1_i(stage_3_i[16*i+j]),
             .in2_r(stage_3_r[16*i+j+8]),   .in2_i(stage_3_i[16*i+j+8]),
             .w_r(real_twiddle[j]),      .w_i(imag_twiddle[j]),
             .out1_r(stage_4_r[16*i+j]),    .out1_i(stage_4_i[16*i+j]),
             .out2_r(stage_4_r[16*i+j+8]),  .out2_i(stage_4_i[16*i+j+8])
            );  
        end
    end
endgenerate

//module butterfly #(
//    parameter Q = 7,
//    parameter DATA_WIDTH = 16
//) (
//    input   wire    [DATA_WIDTH-1:0] in1_r,in1_i,
//    input   wire    [DATA_WIDTH-1:0] in2_r,in2_i,
//    input   wire    [DATA_WIDTH-1:0] w_r,w_i,
//    output  reg     [DATA_WIDTH-1:0] out1_r,out1_i,
//    output  reg     [DATA_WIDTH-1:0] out2_r,out2_i
//);




always @(*) begin
    y0_r = stage_4_r[0];    y1_r = stage_4_r[1];   y2_r = stage_4_r[2];
    y3_r = stage_4_r[3];    y4_r = stage_4_r[4];   y5_r = stage_4_r[5];
    y6_r = stage_4_r[6];    y7_r = stage_4_r[7];   y8_r = stage_4_r[8];
    y9_r = stage_4_r[9];    y10_r = stage_4_r[10]; y11_r = stage_4_r[11];
    y12_r = stage_4_r[12];  y13_r = stage_4_r[13]; y14_r = stage_4_r[14];
    y15_r = stage_4_r[15];
    y0_i = stage_4_i[0];    y1_i = stage_4_i[1];   y2_i = stage_4_i[2];
    y3_i = stage_4_i[3];    y4_i = stage_4_i[4];   y5_i = stage_4_i[5];
    y6_i = stage_4_i[6];    y7_i = stage_4_i[7];   y8_i = stage_4_i[8];
    y9_i = stage_4_i[9];    y10_i = stage_4_i[10]; y11_i = stage_4_i[11];
    y12_i = stage_4_i[12];  y13_i = stage_4_i[13]; y14_i = stage_4_i[14];
    y15_i = stage_4_i[15];
   
end






endmodule