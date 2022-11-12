% Dummy implementation of an 16-point DIF FFT algorithm using butterfly flow

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
for i = 0:N/16 - 1
    for j = 1 : 8
        F_s1(16*i + j)     = x(8*i + j) + x(8*i + j + 8);
        F_s1(16*i + j + 8) = x(8*i + j) - x(8*i + j + 8);
    end
end

%prepare for stage 2 (same as prepare for stage 4 in DIT)
for i = 0:N/16 - 1
   F_s1(16*i + 9)  = F_s1(8*i + 9)*W(0+1);
   F_s1(16*i + 10) = F_s1(8*i +10)*W(N/16+1);
   F_s1(16*i + 11) = F_s1(8*i +11)*W(2*N/16+1);
   F_s1(16*i + 12) = F_s1(8*i +12)*W(3*N/16+1);
   F_s1(16*i + 13) = F_s1(8*i +13)*W(4*N/16+1);
   F_s1(16*i + 14) = F_s1(8*i +14)*W(5*N/16+1);
   F_s1(16*i + 15) = F_s1(8*i +15)*W(6*N/16+1);
   F_s1(16*i + 16) = F_s1(8*i +16)*W(7*N/16+1);
end
%% stage 2
%perform stage 2 (same as perform stage 3 in DIT)
F_s2 = zeros(1,N);
for i = 0:N/8 - 1
    for j = 1 : 4
        F_s2(8*i + j)     = F_s1(8*i + j) + F_s1(8*i + j + 4);
        F_s2(8*i + j + 4) = F_s1(8*i + j) - F_s1(8*i + j + 4);
    end
end

%prepare for stage 3 (same as prepare for stage 3 in DIT)
for i = 0:N/8 - 1
   F_s2(8*i + 5) = F_s2(8*i + 5)*W(0+1);
   F_s2(8*i + 6) = F_s2(8*i + 6)*W(N/8+1);
   F_s2(8*i + 7) = F_s2(8*i + 7)*W(2*N/8+1);
   F_s2(8*i + 8) = F_s2(8*i + 8)*W(3*N/8+1);
end
%% stage 3
%perform stage 3 (same as stage 2 in DIT)
F_s3 = zeros(1,N);
for i = 0:N/4 - 1
    for j = 1 : 2
       F_s3(4*i + j)     =  F_s2(4*i + j) + F_s2(4*i+j + 2);
       F_s3(4*i + j + 2) =  F_s2(4*i + j) - F_s2(4*i+j + 2);
    end
end

%prepare for stage 4 (same as prepare for stage 2 in DIT)
for i = 0:N/4 - 1
   F_s3(4*i + 3) = F_s3(4*i + 3)*W(1);
   F_s3(4*i + 4) = F_s3(4*i + 4)*W(N/4 +1); 
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
