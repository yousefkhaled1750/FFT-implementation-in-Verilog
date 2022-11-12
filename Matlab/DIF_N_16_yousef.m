% Dummy implementation of a generalized 16-point DIF FFT algorithm using butterfly flow

clear all; clc;
N = 16;
n = (0:1:N-1);
%construct the input
x = [1,1,1,1,zeros(1,12)];
%construct the twiddle factor 
W = exp(-1i*2*pi*n/N);

%% stage 1
% perfrom stage 1 (same as perform stage 4 in DIT)
F_s1 = zeros(1,N);
for i = 0:N/2^4 - 1
    for j = 1 : 2^3
        F_s1(2^4*i + j)     = x(2^4*i + j) + x(2^4*i + j + 2^3);
        F_s1(2^4*i + j + 2^3) = x(2^4*i + j) - x(2^4*i + j + 2^3);
    end
end

%prepare for stage 2 (same as prepare for stage 4 in DIT)
for i = 0:N/2^4 - 1
    for j = 1 : 2^3
        F_s1(2^4*i + 2^3 + j)  = F_s1(2^4*i + 2^3 + j)*W((j-1)*N/2^4+1);
    end
end
%% stage 2
%perform stage 2 (same as perform stage 3 in DIT)
F_s2 = zeros(1,N);
for i = 0:N/2^3 - 1
    for j = 1 : 2^2
        F_s2(2^3*i + j)     = F_s1(2^3*i + j) + F_s1(2^3*i + j + 2^2);
        F_s2(2^3*i + j + 2^2) = F_s1(2^3*i + j) - F_s1(2^3*i + j + 2^2);
    end
end

%prepare for stage 3 (same as prepare for stage 3 in DIT)
for i = 0:N/2^3 - 1
    for j = 1 : 2^2
        F_s2(2^3*i + 2^2 + j)  = F_s2(2^3*i + 2^2 + j)*W((j-1)*N/2^3+1);
    end
end
%% stage 3
%perform stage 3 (same as stage 2 in DIT)
F_s3 = zeros(1,N);
for i = 0:N/2^2 - 1
    for j = 1 : 2^1
       F_s3(2^2*i + j)     =  F_s2(2^2*i + j) + F_s2(2^2*i+j + 2^1);
       F_s3(2^2*i + j + 2) =  F_s2(2^2*i + j) - F_s2(2^2*i+j + 2^1);
    end
end

%prepare for stage 4 (same as prepare for stage 2 in DIT)
for i = 0:N/2^2 - 1
   for j = 1 : 2^1
        F_s3(2^2*i + 2^1 + j)  = F_s3(2^2*i + 2^1 + j)*W((j-1)*N/2^2+1);
   end
end

%% stage 4
%perform stage 4 (same as stage 1 in DIT)
F_s4 = zeros(1,N);
for i = 0:N/2 -1
    F_s4(2*i + 1) = F_s3(2*i + 1) + F_s3(2*i + 2);
    F_s4(2*i + 2) = F_s3(2*i + 1) - F_s3(2*i + 2);
end

%reverse bit order
y = (1:1:N);
y = bitrevorder(y);
X = zeros(1,N);
for i = 1:N
    b = y(i);
    X(b) = F_s4(i);
end
%% comparing with built-in function
F = fft(x,N);
