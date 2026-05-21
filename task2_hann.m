clc;
clear;
close all;
N = 2048;
k=67;
A = 1;
bits = 11;
fs = 1000;
fin = k*fs/N;


LSB = 2/(2^(bits - 1));

n = 0:N-1;

x = A*cos(2*pi*fin*n/fs);

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