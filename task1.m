clc;
clear;
close all;

%% Parameters
N = 16;              % FFT size
bits = 16;           % Fixed-point bits
A = 0.9;             % Amplitude
fs = 16e6;           % Sampling frequency = 16 MHz

n = 0:N-1;

%% Frequencies
f1 = 1e6;            % 1-period signal
f4 = 4e6;            % 4-period signal

%% ================== 1 MHz SIGNAL ==================

x1 = A*sin(2*pi*f1*n/fs);

% Floating-point FFT
X1_float = fft(x1);

% Fixed-point quantization
scale = 2^(bits-1);

x1_fixed = round(x1*scale)/scale;

% Fixed-point FFT
X1_fixed = fft(x1_fixed);

% Quantization noise
noise1 = X1_float - X1_fixed;

% Power calculations
Ps1 = sum(abs(X1_float).^2);
Pn1 = sum(abs(noise1).^2);

% SQNR
SQNR1 = 10*log10(Ps1/Pn1);

%% ================== 4 MHz SIGNAL ==================

x4 = A*sin(2*pi*f4*n/fs);

% Floating-point FFT
X4_float = fft(x4);

% Fixed-point quantization
x4_fixed = round(x4*scale)/scale;

% Fixed-point FFT
X4_fixed = fft(x4_fixed);

% Quantization noise
noise4 = X4_float - X4_fixed;

% Power calculations
Ps4 = sum(abs(X4_float).^2);
Pn4 = sum(abs(noise4).^2);

% SQNR
SQNR4 = 10*log10(Ps4/Pn4);

%% Display Results

fprintf('SQNR for 1 MHz signal = %.2f dB\n', SQNR1);
fprintf('SQNR for 4 MHz signal = %.2f dB\n', SQNR4);

%% Frequency Axis

f_axis = (0:N-1)*(fs/N)/1e6;   % MHz

%% ================== FFT PLOTS ==================

figure;

subplot(2,2,1);
stem(f_axis, abs(X1_float));
title('1 MHz Ideal FFT');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
grid on;

subplot(2,2,2);
stem(f_axis, abs(X1_fixed));
title('1 MHz Fixed FFT');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
grid on;

subplot(2,2,3);
stem(f_axis, abs(X4_float));
title('4 MHz Ideal FFT');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
grid on;

subplot(2,2,4);
stem(f_axis, abs(X4_fixed));
title('4 MHz Fixed FFT');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
grid on;

%% ================== SQNR COMPARISON ==================

figure;

sqnr_vals = [SQNR1 SQNR4];

bar(sqnr_vals);

xticklabels({'1 MHz Signal','4 MHz Signal'});

ylabel('SQNR (dB)');
title('SQNR Comparison');

grid on;

%% ================== SQNR VALUE PLOT ==================

figure;

plot([1 4], sqnr_vals, '-o','LineWidth',2);

xlabel('Signal Frequency (MHz)');
ylabel('SQNR (dB)');
title('SQNR vs Signal Frequency');

grid on;