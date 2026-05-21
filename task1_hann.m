clc;
clear;
close all;

A = 0.9;
bits = 16;
fs = 16e6;
fin = 1e6;

N = 16;

LSB = 2/(2^(bits - 1));

n = 0:N-1;

x = A*sin(2*pi*fin*n/fs);

%% Without window

s = abs(fft(x));

s = s(1:N/2);

s = 20*log10(2*s/N);

f = (0:N/2-1)/N;

%% With Hann window

x1 = x .* hann(N)';

s1 = abs(fft(x1));

s1 = s1(1:N/2);

s1 = 20*log10(2*s1/N);

%% Plot

figure;

plot(f,s,'r','LineWidth',1.5);

hold on;

plot(f,s1,'g','LineWidth',1.5);

grid on;

xlabel('Normalized Frequency');

ylabel('Magnitude (dB)');

legend('Without Window','Hann Window');

title('FFT Spectrum Comparison');