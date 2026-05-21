

A = 0.9;
bits = 16;
fs = 16e6;
fin=1e6;

scale = 2^(bits-1);

N1 = 16;

n1 = 0:N1-1;


x1 = A*sin(2*pi*fin*n1/fs);

% Floating FFT
X1_float = fft(x1);

% Fixed-point quantization
x1_fixed = round(x1*scale)/scale;

% Fixed FFT
X1_fixed = fft(x1_fixed);

% Noise
noise1 = X1_float - X1_fixed;

% Power
Ps1 = sum(abs(X1_float).^2);
Pn1 = sum(abs(noise1).^2);

% SQNR
SQNR1 = 10*log10(Ps1/Pn1);

%% ====================================================
%% CASE 2 : 64 Samples (4 Periods)
%% ====================================================

N2 = 64;

n2 = 0:N2-1;

% Same frequency, but 4 complete periods
x2 = A*sin(2*pi*fin*n2/fs);

% Floating FFT
X2_float = fft(x2);

% Fixed-point quantization
x2_fixed = round(x2*scale)/scale;

% Fixed FFT
X2_fixed = fft(x2_fixed);

% Noise
noise2 = X2_float - X2_fixed;

% Power
Ps2 = sum(abs(X2_float).^2);
Pn2 = sum(abs(noise2).^2);

% SQNR
SQNR2 = 10*log10(Ps2/Pn2);

%% ====================================================
%% DISPLAY RESULTS
%% ====================================================

fprintf('SQNR for 16 samples = %.2f dB\n', SQNR1);
fprintf('SQNR for 64 samples = %.2f dB\n', SQNR2);

%% ====================================================
%% FREQUENCY AXIS
%% ====================================================

f1 = (0:N1-1)*(fs/N1)/1e6;
f2 = (0:N2-1)*(fs/N2)/1e6;

%% ====================================================
%% FFT PLOTS
%% ====================================================

figure;

subplot(2,2,1);
stem(f1, abs(X1_float));
title('16-Sample Ideal FFT');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
grid on;

subplot(2,2,2);
stem(f1, abs(X1_fixed));
title('16-Sample Fixed FFT');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
grid on;

subplot(2,2,3);
stem(f2, abs(X2_float));
title('64-Sample Ideal FFT');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
grid on;

subplot(2,2,4);
stem(f2, abs(X2_fixed));
title('64-Sample Fixed FFT');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
grid on;

%% ====================================================
%% SQNR COMPARISON
%% ====================================================

figure;

bar([SQNR1 SQNR2]);

xticklabels({'16 Samples','64 Samples'});

ylabel('SQNR (dB)');
title('SQNR Comparison');

grid on;