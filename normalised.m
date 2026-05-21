clc;
%normalised frequency spectrum
N=16;
fin=1e6;
fs=16e6;
bit=16;
n=0:N-1;
A=1;
x=A*sin(2*pi*fin*n/fs);
s=abs(fft(x));
s=s(1:end/2);
s=20*log10(2*s/N/fs); 
f=[0:N/2-1]/N; % f/fs=k/N
plot(f,s);
xlabel("Frequency");
ylabel("dbFS");

