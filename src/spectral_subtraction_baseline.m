function denoised = spectral_subtraction_baseline(noisy, fs, cfg)
%SPECTRAL_SUBTRACTION_BASELINE Simple non-learning comparison method.
window=hann(cfg.windowLength,'periodic');
S=stft(noisy,fs,'Window',window,'OverlapLength',cfg.overlapLength,...
    'FFTLength',cfg.fftLength);
noiseMagnitude=median(abs(S),2);
estimatedMagnitude=max(abs(S)-noiseMagnitude,0.05*abs(S));
estimated=estimatedMagnitude.*exp(1i*angle(S));
denoised=istft(estimated,fs,'Window',window,...
    'OverlapLength',cfg.overlapLength,'FFTLength',cfg.fftLength);
denoised=denoised(1:min(numel(denoised),numel(noisy)));
end
