% implement 16-pt DIT FFT used as a golden reference for a verilog
% implementation
% matlab script used to generate text files of input and outputs of fft to
% use them in testbench

clear all; clc;
%% parameters
int_bits = 8;   %number of bits for integer part
frac_bits = 8;  %number of bits for fractional part
N = 16; %number of inputs
n = (0:1:N-1);
%% constructing input
%construct the input from random complex number from 4:-4
x = 8*(rand([1,N])-0.5) + 1i*8*(rand([1,N])-0.5); 
x_real = real(x);
x_imag = imag(x);
%% construct the twiddle factor 
W = exp(-1i*2*pi*n/N);
W_real = real(W);
W_imag = imag(W);



%% prepare for stage 1
%reverse bit order
y = (1:1:N);
y = bitrevorder(y);
for i = 1:N
    b = y(i);
    a(b) = x(i);
end

%perform stage 1;
F_s1 = zeros(1,N);
for i = 0:N/2 -1
    F_s1(2*i + 1) = a(2*i + 1) + a(2*i + 2);
    F_s1(2*i + 2) = a(2*i + 1) - a(2*i + 2);
end

%% preparing for stage 2
% here we divide the set into groups of 4 and take the second 2 elements
% of the 4-element group and multiply W0 and W(N/4)
for i = 0:N/4 - 1
   F_s1(4*i + 3) = F_s1(4*i + 3)*W(1);
   F_s1(4*i + 4) = F_s1(4*i + 4)*W(N/4 +1); 
end

%perform stage 2
% here we also divide the set into groups of 4 and make summation between
% 1&3 and 2&4 of each group
F_s2 = zeros(1,N);
for i = 0:N/4 - 1
    for j = 1 : 2
       F_s2(4*i + j)     =  F_s1(4*i + j) + F_s1(4*i+j + 2);
       F_s2(4*i + j + 2) =  F_s1(4*i + j) - F_s1(4*i+j + 2);
    end
end

%% preparing for stage 3
% here we divide the set into groups of 8 and take the second 4 elements
% of the 8-element group and multiply W0, W(N/8), W(2*N/8), W(3*N/8)
for i = 0:N/8 - 1
   F_s2(8*i + 5) = F_s2(8*i + 5)*W(0+1);
   F_s2(8*i + 6) = F_s2(8*i + 6)*W(N/8+1);
   F_s2(8*i + 7) = F_s2(8*i + 7)*W(2*N/8+1);
   F_s2(8*i + 8) = F_s2(8*i + 8)*W(3*N/8+1);
end

%perform stage 3
F_s3 = zeros(1,N);
for i = 0:N/8 - 1
    for j = 1 : 4
        F_s3(8*i + j)     = F_s2(8*i + j) + F_s2(8*i + j + 4);
        F_s3(8*i + j + 4) = F_s2(8*i + j) - F_s2(8*i + j + 4);
    end
end

%% prepare for stage 4
% here we divide the set into groups of 16 and take the second 8 elements
% of the 16-element group and multiply W0, W(N/16), W(2*N/16), W(3*N/16),..
for i = 0:N/16 - 1
   F_s3(16*i + 9)  = F_s3(8*i + 9)*W(0+1);
   F_s3(16*i + 10) = F_s3(8*i +10)*W(N/16+1);
   F_s3(16*i + 11) = F_s3(8*i +11)*W(2*N/16+1);
   F_s3(16*i + 12) = F_s3(8*i +12)*W(3*N/16+1);
   F_s3(16*i + 13) = F_s3(8*i +13)*W(4*N/16+1);
   F_s3(16*i + 14) = F_s3(8*i +14)*W(5*N/16+1);
   F_s3(16*i + 15) = F_s3(8*i +15)*W(6*N/16+1);
   F_s3(16*i + 16) = F_s3(8*i +16)*W(7*N/16+1);
end

%perform stage 4
F_s4 = zeros(1,N);
for i = 0:N/16 - 1
    for j = 1 : 8
        F_s4(16*i + j)     = F_s3(8*i + j) + F_s3(8*i + j + 8);
        F_s4(16*i + j + 8) = F_s3(8*i + j) - F_s3(8*i + j + 8);
    end
end
F = F_s4;
F_real = real(F);
F_imag = imag(F);
%% perform built-in fft
%F = fft(x,N);
%F_real = real(F);
%F_imag = imag(F);

%% Fixed-Point Representation Object
q = quantizer('DataMode', 'fixed', 'Format', [int_bits+frac_bits frac_bits]);

%% Fixed-Point Representation of Twiddle Factors
twiddle_real = num2bin(q, W_real);
twiddle_imag = num2bin(q, W_imag);

%% Fixed-Point Representation of Inputs
input_real = num2bin(q, x_real);
input_imag = num2bin(q, x_imag);


%% Fixed-Point Representation of Outputs
output_real = num2bin(q, F_real);
output_imag = num2bin(q, F_imag);

%% generating text file containing the twiddle factors vectors
fileID1 = fopen('twiddle_factor_16_real.txt','w+');
fileID2 = fopen('twiddle_factor_16_imag.txt','w+');
for i = 1 : N
    if i == N
      fprintf(fileID1, '%s', twiddle_real(i, :));
      fprintf(fileID2, '%s', twiddle_imag(i, :));
    else
      fprintf(fileID1, '%s\n', twiddle_real(i, :));
      fprintf(fileID2, '%s\n', twiddle_imag(i, :));
    end
end
fclose(fileID1);
fclose(fileID2);
%% generating text file containing the input vectors
fileID1 = fopen('input_16_real.txt','w+');
fileID2 = fopen('input_16_imag.txt','w+');
for i = 1 : N
    if i == N
      fprintf(fileID1, '%s', input_real(i, :));
      fprintf(fileID2, '%s', input_imag(i, :));
    else
      fprintf(fileID1, '%s\n', input_real(i, :));
      fprintf(fileID2, '%s\n', input_imag(i, :));
    end
end
fclose(fileID1);
fclose(fileID2);
%% generating text file containing the output vectors
fileID1 = fopen('output_16_real.txt','w+');
fileID2 = fopen('output_16_imag.txt','w+');
for i = 1 : N
    if i == N
      fprintf(fileID1, '%s', output_real(i, :));
      fprintf(fileID2, '%s', output_imag(i, :));
    else
      fprintf(fileID1, '%s\n', output_real(i, :));
      fprintf(fileID2, '%s\n', output_imag(i, :));
    end
end
fclose(fileID1);
fclose(fileID2);