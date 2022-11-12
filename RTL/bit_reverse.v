module bit_reverse #(
    parameter DATA_WIDTH = 16,  //each number is represented in 16-bit data fixed point 
    parameter ADDR_WIDTH = 4    //2**ADDR_WIDTH = N (the number of inputs (N-point FFT))
) (
    input   wire    [ADDR_WIDTH - 1 : 0]    address_line,
    output  wire    [DATA_WIDTH - 1 : 0]    output_r_bit_rev,
    output  wire    [DATA_WIDTH - 1 : 0]    output_i_bit_rev
);

wire    [ADDR_WIDTH - 1 : 0]    address_line_rev;

genvar i;
generate 
    for (i = 0 ; i < ADDR_WIDTH ; i = i+1 ) begin
        assign address_line_rev[i] = address_line[ADDR_WIDTH-i-1];
    end

endgenerate

twiddle_rom #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) DUT_rom 
(
.address_line(address_line_rev),
.w_r(output_r_bit_rev),
.w_i(output_i_bit_rev)
);


    
endmodule