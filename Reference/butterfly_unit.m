%matlab script used as a golden reference for the butterfly unit
%implementation in verilog. The function is to generate random inputs and
%perform 8 butterly operations using 8-pt twiddle factor and quantize the
%inputs and outputs in 16-bit fixed point represenetation and export the
%data in text files will be used in testbenches of verilog
clear all; clc;
%% parameters
int_bits = 8;   %number of bits for integer part
frac_bits = 8;  %number of bits for fractional part
N = 8; %number of inputs
n = (0:1:N-1);
%% constructing input
%construct the input from random complex number from 4:-4
input1 = 8*(rand([1,N])-0.5) + 1i*8*(rand([1,N])-0.5); 
input2 = 8*(rand([1,N])-0.5) + 1i*8*(rand([1,N])-0.5); 
input1_real = real(input1);
input1_imag = imag(input1);
input2_real = real(input2);
input2_imag = imag(input2);
%% construct the twiddle factor 
W = exp(-1i*2*pi*n/N);
W_real = real(W);
W_imag = imag(W);
%% implementation of the butterfly 
output1 = zeros(1,N);
output2 = zeros(1,N);
for i = 1:N
    output1(i) = input1(i) + input2(i)*W(i);
    output2(i) = input1(i) - input2(i)*W(i);
end
output1_real = real(output1);
output2_real = real(output2);
output1_imag = imag(output1);
output2_imag = imag(output2);

%% quantizing the floating variables to fixed points
q = quantizer('DataMode', 'fixed', 'Format', [int_bits+frac_bits frac_bits]);
W_real_Q = quantizer(q,W_real);
% quantizing the twiddle factors
twiddle_real = num2bin(q, W_real);
twiddle_imag = num2bin(q, W_imag);
% quantizing the input
input1_real = num2bin(q, input1_real);
input1_imag = num2bin(q, input1_imag);
input2_real = num2bin(q, input2_real);
input2_imag = num2bin(q, input2_imag);
% quantizing the output
output1_real = num2bin(q, output1_real);
output1_imag = num2bin(q, output1_imag);
output2_real = num2bin(q, output2_real);
output2_imag = num2bin(q, output2_imag);

%% generating text files containing the twiddle factors
fileID1 = fopen('twiddle_factor_8_real.txt','w+');
fileID2 = fopen('twiddle_factor_8_imag.txt','w+');
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
fileID1 = fopen('input1_8_real.txt','w+');
fileID2 = fopen('input1_8_imag.txt','w+');
fileID3 = fopen('input2_8_real.txt','w+');
fileID4 = fopen('input2_8_imag.txt','w+');
for i = 1 : N
    if i == N
      fprintf(fileID1, '%s', input1_real(i, :));
      fprintf(fileID2, '%s', input1_imag(i, :));
      fprintf(fileID3, '%s', input2_real(i, :));
      fprintf(fileID4, '%s', input2_imag(i, :));
    else
      fprintf(fileID1, '%s\n', input1_real(i, :));
      fprintf(fileID2, '%s\n', input1_imag(i, :));
      fprintf(fileID3, '%s\n', input2_real(i, :));
      fprintf(fileID4, '%s\n', input2_imag(i, :));
    end
end
fclose(fileID1);
fclose(fileID2);
fclose(fileID3);
fclose(fileID4);
%% generating text file containing the output vectors
fileID1 = fopen('output1_8_real.txt','w+');
fileID2 = fopen('output1_8_imag.txt','w+');
fileID3 = fopen('output2_8_real.txt','w+');
fileID4 = fopen('output2_8_imag.txt','w+');
for i = 1 : N
    if i == N
      fprintf(fileID1, '%s', output1_real(i, :));
      fprintf(fileID2, '%s', output1_imag(i, :));
      fprintf(fileID3, '%s', output2_real(i, :));
      fprintf(fileID4, '%s', output2_imag(i, :));
    else
      fprintf(fileID1, '%s\n', output1_real(i, :));
      fprintf(fileID2, '%s\n', output1_imag(i, :));
      fprintf(fileID3, '%s\n', output2_real(i, :));
      fprintf(fileID4, '%s\n', output2_imag(i, :));
    end
end
fclose(fileID1);
fclose(fileID2);
fclose(fileID3);
fclose(fileID4);