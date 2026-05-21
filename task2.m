clc; clear; close all;
A = 1;
N=2048;
bits = 11;
k=67;
fs = 1000;
fin=fs*k/N;
LSB=2/(2^(bits-1));
n=0:N-1;
x=A*cos(2*pi*fin/fs*n);
x=round(x/LSB)*LSB;
s=abs(fft(x));
s=s(1:end/2)/N*2;%this normalise will give the correct amplitude
sigbin=1+k;%1+cylce
noise=[s(1:sigbin-1),s(sigbin+1:end)];
snr=10*log10(s(sigbin)^2 / sum(noise.^2));
display(snr);
f=[0:N/2-1]/N*fs;
figure;
plot(f,s);
