function metrics = evaluate_denoising(clean, noisy, denoised)
%EVALUATE_DENOISING Objective metrics for aligned, paired signals.
clean = double(clean(:));
noisy = double(noisy(:));
denoised = double(denoised(:));
if isempty(clean)
    error('AudioDenoising:EmptyEvaluation','Evaluation signals must not be empty.');
end
if numel(clean) ~= numel(noisy) || numel(clean) ~= numel(denoised)
    error('AudioDenoising:LengthMismatch', ...
        'Clean, noisy, and denoised signals must have identical lengths.');
end
if any(~isfinite([clean;noisy;denoised]))
    error('AudioDenoising:NonfiniteEvaluation', ...
        'Evaluation signals contain NaN or Inf values.');
end

inputSnr = signal_snr(clean,noisy-clean);
outputSnr = signal_snr(clean,denoised-clean);
cleanSpectrum = abs(fft(clean));
denoisedSpectrum = abs(fft(denoised));
logDistance = sqrt(mean((20*log10(cleanSpectrum+eps)- ...
    20*log10(denoisedSpectrum+eps)).^2));
if std(clean) <= eps || std(denoised) <= eps
    correlation = NaN;
else
    corrMatrix = corrcoef(clean,denoised);
    correlation = corrMatrix(1,2);
end
metrics = struct('InputSNR_dB',inputSnr,'OutputSNR_dB',outputSnr, ...
    'SNRImprovement_dB',outputSnr-inputSnr,'MSE',mean((clean-denoised).^2), ...
    'Correlation',correlation,'LogSpectralDistance_dB',logDistance, ...
    'SampleCount',numel(clean));
end

function value = signal_snr(signal,noise)
value = 10*log10(sum(signal.^2)/max(sum(noise.^2),eps));
end
