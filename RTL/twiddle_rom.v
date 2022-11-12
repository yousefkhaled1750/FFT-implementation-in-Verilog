module twiddle_rom #(
    parameter DATA_WIDTH = 16,  //each number is represented in 16-bit data fixed point 
    parameter ADDR_WIDTH = 4    //2**ADDR_WIDTH = N (the number of inputs (N-point FFT))
) (
    input   wire    [ADDR_WIDTH-1:0]    address_line,
    output  wire    [DATA_WIDTH-1:0]    w_r,w_i
);

//definition of the memory
reg [DATA_WIDTH - 1 : 0]  real_twiddle [2**ADDR_WIDTH - 1 : 0];
reg [DATA_WIDTH - 1 : 0]  imag_twiddle [2**ADDR_WIDTH - 1 : 0];

initial begin
    $readmemb("../Reference/twiddle_factor_8_real.txt",real_twiddle);
    $readmemb("../Reference/twiddle_factor_8_imag.txt",imag_twiddle);
end

assign w_r = real_twiddle[address_line];
assign w_i = imag_twiddle[address_line];



endmodule