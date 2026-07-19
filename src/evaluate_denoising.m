function metrics = evaluate_denoising(clean, noisy, denoised)
%EVALUATE_DENOISING Objective paired-signal metrics.
n=min([numel(clean),numel(noisy),numel(denoised)]);
clean=double(clean(1:n)); noisy=double(noisy(1:n)); denoised=double(denoised(1:n));
inputSnr=signal_snr(clean,noisy-clean); outputSnr=signal_snr(clean,denoised-clean);
cleanSpectrum=abs(fft(clean)); denoisedSpectrum=abs(fft(denoised));
logDistance=sqrt(mean((20*log10(cleanSpectrum+eps)-...
    20*log10(denoisedSpectrum+eps)).^2));
corrMatrix=corrcoef(clean,denoised);
metrics=struct('InputSNR_dB',inputSnr,'OutputSNR_dB',outputSnr,...
    'SNRImprovement_dB',outputSnr-inputSnr,'MSE',mean((clean-denoised).^2),...
    'Correlation',corrMatrix(1,2),'LogSpectralDistance_dB',logDistance);
end

function value=signal_snr(signal,noise)
value=10*log10(sum(signal.^2)/max(sum(noise.^2),eps));
end
