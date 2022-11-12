% Dummy implementation of an N-point DIF FFT algorithm using butterfly flow

clear all; clc;
N = 32;
n = (0:1:N-1);
%construct the input
x = [1,1,1,1,zeros(1,N-4)];
%construct the twiddle factor 
W = exp(-1i*2*pi*n/N);
%% stages
previous_stage = x;
current_stage  = zeros(1,N);
for s = log2(N):-1:2
    % perfrom stage s
    for i = 0:N/2^s - 1
        for j = 1 : 2^(s-1)
            current_stage(2^s*i + j)     = previous_stage(2^(s)*i + j) + previous_stage(2^(s)*i + j + 2^(s-1));
            current_stage(2^s*i + j + 2^(s-1)) = previous_stage(2^(s)*i + j) - previous_stage(2^(s)*i + j + 2^(s-1));
        end
    end  
    % prepare for stage s+1
    for i = 0:N/2^s - 1
        for j = 1 : 2^(s-1)
            current_stage(2^s*i + 2^(s-1) + j)  = current_stage(2^s*i + 2^(s-1) + j)*W((j-1)*N/2^s+1);
        end
    end
    previous_stage = current_stage;
end

%% last stage
%perform stage 4 (same as stage 1 in DIT)
for i = 0:N/2 -1
    current_stage(2*i + 1) = previous_stage(2*i + 1) + previous_stage(2*i + 2);
    current_stage(2*i + 2) = previous_stage(2*i + 1) - previous_stage(2*i + 2);
end

%reverse bit order
y = (1:1:N);
y = bitrevorder(y);
X = zeros(1,N);
for i = 1:N
    b = y(i);
    X(b) = current_stage(i);
end

%% comparing with built-in function
F = fft(x,N);


