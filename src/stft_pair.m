function features = stft_pair(clean, noisy, fs, cfg)
%STFT_PAIR Create noisy log-magnitude input and ideal-ratio-mask target.
window=hann(cfg.windowLength,'periodic');
[cleanStft,f,t]=stft(clean,fs,'Window',window,...
    'OverlapLength',cfg.overlapLength,'FFTLength',cfg.fftLength);
noisyStft=stft(noisy,fs,'Window',window,...
    'OverlapLength',cfg.overlapLength,'FFTLength',cfg.fftLength);
cleanMagnitude=abs(cleanStft); noisyMagnitude=abs(noisyStft);
mask=cleanMagnitude./max(cleanMagnitude+abs(noisyStft-cleanStft),eps);
mask=min(max(mask,0),1);
features=struct('input',log1p(noisyMagnitude),'target',mask,...
    'noisyStft',noisyStft,'cleanStft',cleanStft,'frequencyHz',f,'timeSec',t);
end
