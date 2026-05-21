A = 1;
bits = 16;
fs = 16e6;
fin=1e6;
N=16;
N1=64
k1=fin*N1/fs;
k=fin*N/fs;
LSB=2/(2^(bits-1));
n=0:N-1;
n1=0:N1-1;
x=A*sin(2*pi*fin*n/fs);
x1=A*sin(2*pi*fin*n/fs);
x=round(x/LSB)*LSB;
x1=round(x1/LSB)*LSB;
s=abs(fft(x));
s1=abs(fft(x1));
s=s(1:end/2)/N*2;%this normalise will give the correct amplitude
s1=s1(1:end/2)/N1*2;
sigbin=1+k;%1+cylce
sigbin1=1+k1;
noise=[s(1:sigbin-1),s(sigbin+1:end)];
noise1=[s1(1:sigbin1),s1(sigbin1+1:end)];
snr=10*log10(s(sigbin)^2 / sum(noise.^2));
snr1=10*log10(s(sigbin1)^2 / sum(noise1.^2));
bar([snr,snr1]);
display(snr);
display(snr1);
f=[0:N/2-1]/N*fs;
f1=[0:N1/2-1]/N1*fs;
figure;
subplot(2,1,1);
plot(f,s);
subplot(2,1,2);
plot(f1,s1);