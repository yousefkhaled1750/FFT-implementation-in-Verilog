% Dummy implementation of an N-point DIT FFT algorithm using butterfly flow

clear all; clc;
N = 16;
n = (0:1:N-1);
%construct the twiddle factor 
W = exp(-1i*2*pi*n/N);
%construct the input
x = [1,1,1,1,zeros(1,12)];
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
%% comparing with the built-in function
X = F_s4;
F = fft(x,N);







