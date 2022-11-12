% Dummy implementation of an N-point DIT FFT algorithm using butterfly flow

clear all; clc;
N = 32;
n = (0:1:N-1);
%construct the input
x = 0:N-1;
%construct the twiddle factor 
W = exp(-1i*2*pi*n/N);

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
%% performing the subsequent stages
previous_stage = F_s1;
current_stage  = zeros(1,N);
for s = 2:log2(N)
    %preparing for the stage
    for i = 0:N/2^s - 1
        for j = 1 : 2^(s-1)
            previous_stage(2^s*i + 2^(s-1) + j) = previous_stage(2^s*i + 2^(s-1) + j)*W((j-1)*N/2^s + 1);
        end
    end  
    %performing the stage operations
    for i = 0:N/2^s - 1
        for j = 1 : 2^(s-1)
            current_stage(2^s*i + j)           =  previous_stage(2^s*i + j) + previous_stage(2^s*i+j + 2^(s-1));
            current_stage(2^s*i + j + 2^(s-1)) =  previous_stage(2^s*i + j) - previous_stage(2^s*i+j + 2^(s-1));
        end
    end
    previous_stage = current_stage;
end
X = current_stage;
F = fft(x,N);



