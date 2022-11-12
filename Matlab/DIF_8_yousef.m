% Dummy implementation of an 8-point DIF FFT algorithm using butterfly flow

clear all; clc;
N = 8;
n = (0:1:N-1);
%construct the input
x = [0,1,2,3,4,5,6,7];
%construct the twiddle factor 
W = exp(-1i*2*pi*n/N);

% perfrom stage 1
F_s1 = zeros(1,N);
for i = 1:N/2
    F_s1(i)     = x(i) + x(i+N/2);
    F_s1(i+N/2) = x(i) - x(i+N/2);
end

%prepare for stage 2
F_s1(5) = F_s1(5)*W(1);
F_s1(6) = F_s1(6)*W(2);
F_s1(7) = F_s1(7)*W(3);
F_s1(8) = F_s1(8)*W(4);

%perform stage 2
j = 1;
F_s2 = zeros(1,N);
for i = 1:2
    F_s2(j) = F_s1(j) + F_s1(j+2);
    F_s2(j+2)= F_s1(j) - F_s1(j+2);
    F_s2(j+N/2) = F_s1(j+N/2) + F_s1(j+N/2+2);
    F_s2(j+N/2+2)= F_s1(j+N/2) - F_s1(j+N/2+2);
    j = j + 1;
end

%prepare for stage 3
F_s2(3) = F_s2(3)*W(1);
F_s2(4) = F_s2(4)*W(3);
F_s2(7) = F_s2(7)*W(1);
F_s2(8) = F_s2(8)*W(3);

%perform stage 3
F_s3 = zeros(1,N);
for i = 0:N/2 -1
    F_s3(2*i + 1) = F_s2(2*i + 1) + F_s2(2*i + 2);
    F_s3(2*i + 2) = F_s2(2*i + 1) - F_s2(2*i + 2);
end
% reverse bit order
y = (1:1:N);
y = bitrevorder(y);
X = zeros(1,N);
for i = 1:N
    b = y(i);
    X(b) = F_s3(i);
end

F = fft(x,N);
