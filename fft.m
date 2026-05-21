clear; clc; close all;

Fs   = 1000;          
N    = 512;        
t    = (0:N-1)/Fs;  


f1 = 50;   A1 = 1.0;  
f2 = 120;  A2 = 0.5;  
f3 = 200;  A3 = 0.25;  

x = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);

x = x / max(abs(x));


X_ideal = fft(x, N);

freq      = (0:N/2-1) * Fs/N;
mag_ideal = (2/N) * abs(X_ideal(1:N/2));

B_demo = 8;  

x_q      = quantise_signal(x, B_demo);  
X_finite = fft(x_q, N);                  
mag_finite = (2/N) * abs(X_finite(1:N/2));


bit_range = 4:16;          
snr_vals  = zeros(size(bit_range));

for idx = 1:numel(bit_range)
    B         = bit_range(idx);
    x_q_i     = quantise_signal(x, B);
    X_q_i     = fft(x_q_i, N);
    
   
    noise       = X_ideal - X_q_i;
    signal_pwr  = sum(abs(X_ideal).^2);
    noise_pwr   = sum(abs(noise).^2);
    
    if noise_pwr == 0
        snr_vals(idx) = Inf;
    else
        snr_vals(idx) = 10 * log10(signal_pwr / noise_pwr);
    end
end

snr_theory = 6.02 * bit_range + 1.76;


figure('Name', 'FFT Precision Analysis', 'NumberTitle', 'off', ...
       'Position', [100 100 1100 750]);

subplot(3,2,1);
plot(t(1:100)*1000, x(1:100), 'Color', [0.2 0.4 0.8], 'LineWidth', 1.4);
hold on;
plot(t(1:100)*1000, quantise_signal(x(1:100), B_demo), '--', ...
     'Color', [0.85 0.33 0.10], 'LineWidth', 1.2);
xlabel('Time (ms)'); ylabel('Amplitude');
title('Time-domain signal (first 100 samples)');
legend('Ideal', sprintf('%d-bit quantised', B_demo), 'Location', 'northeast');
grid on; box on;

subplot(3,2,2);
q_error_td = x - quantise_signal(x, B_demo);
plot(t*1000, q_error_td, 'Color', [0.85 0.33 0.10], 'LineWidth', 1);
xlabel('Time (ms)'); ylabel('Error');
title(sprintf('Quantisation error (time domain) — %d bits', B_demo));
grid on; box on;


subplot(3,2,3);
plot(freq, log20safe(mag_ideal),  'Color', [0.2 0.4 0.8], 'LineWidth', 1.5);
hold on;
plot(freq, log20safe(mag_finite), '--', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.2);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('FFT magnitude spectrum');
legend('Ideal (64-bit)', sprintf('%d-bit finite precision', B_demo));
grid on; box on;

subplot(3,2,4);
spectral_error = (2/N) * abs(X_ideal(1:N/2) - X_finite(1:N/2));
plot(freq, log20safe(spectral_error), 'Color', [0.5 0.18 0.56], 'LineWidth', 1.2);
xlabel('Frequency (Hz)'); ylabel('Error magnitude (dB)');
title(sprintf('Spectral error (quantisation noise floor) — %d bits', B_demo));
grid on; box on;


subplot(3,2,5);
plot(bit_range, snr_vals,   'o-', 'Color', [0.2 0.4 0.8], ...
     'LineWidth', 2, 'MarkerSize', 7, 'MarkerFaceColor', [0.2 0.4 0.8]);
hold on;
plot(bit_range, snr_theory, '--', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
xline(B_demo, ':', 'Color', [0.5 0.18 0.56], 'LineWidth', 1.5, ...
      'Label', sprintf('B=%d', B_demo), 'LabelVerticalAlignment','bottom');
xlabel('Bit depth (B)'); ylabel('SNR (dB)');
title('SNR vs bit depth');
legend('Simulated SNR', 'Theory: 6.02B + 1.76 dB', 'Location', 'northwest');
grid on; box on;


subplot(3,2,6);
snr_diff = diff(snr_vals);
bar(bit_range(2:end), snr_diff, 'FaceColor', [0.2 0.63 0.47], 'EdgeColor', 'none');
hold on;
yline(6.02, '--r', 'LineWidth', 1.5, 'Label', '6.02 dB/bit (theory)');
xlabel('Bit depth (B)'); ylabel('\DeltaSNR (dB/bit)');
title('SNR gain per additional bit');
grid on; box on;

sgtitle('FFT Precision Analysis: Finite vs Infinite Word Length', ...
        'FontSize', 13, 'FontWeight', 'bold');


fprintf('\n=== SNR Summary ===\n');
fprintf('%-8s %-18s %-18s %-12s\n', 'Bits', 'Simulated SNR (dB)', 'Theoretical (dB)', 'Difference');
fprintf('%s\n', repmat('-', 1, 60));
for idx = 1:numel(bit_range)
    fprintf('%-8d %-18.2f %-18.2f %-12.2f\n', ...
        bit_range(idx), snr_vals(idx), snr_theory(idx), ...
        snr_vals(idx) - snr_theory(idx));
end


function xq = quantise_signal(x, B)
    
    levels  = 2^B;
    step    = 2 / levels;
    xq      = step * round(x / step);       
    xq      = max(-1, min(1 - step, xq));   
end

function y = log20safe(x)
    y = 20 * log10(max(x, 1e-6));
end