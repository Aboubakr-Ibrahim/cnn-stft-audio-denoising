function denoised = denoise_with_model(net, noisy, fs, cfg)
%DENOISE_WITH_MODEL Predict overlapping masks and reconstruct with noisy phase.
noisy = double(noisy(:));
window = hann(cfg.windowLength,'periodic');
S = stft(noisy,fs,'Window',window,'OverlapLength',cfg.overlapLength, ...
    'FFTLength',cfg.fftLength);
inputMap = log1p(abs(S));
frames = size(inputMap,2);
starts = unique([1:cfg.segmentHopFrames:max(1,frames-cfg.contextFrames+1), ...
    max(1,frames-cfg.contextFrames+1)]);
maskSum = zeros(size(inputMap));
weight = zeros(size(inputMap));
for i = 1:numel(starts)
    index = starts(i):min(frames,starts(i)+cfg.contextFrames-1);
    block = zeros(size(inputMap,1),cfg.contextFrames,1,'single');
    block(:,1:numel(index),1) = single(inputMap(:,index));
    prediction = predict(net,block);
    maskSum(:,index) = maskSum(:,index) + double(prediction(:,1:numel(index),1));
    weight(:,index) = weight(:,index) + 1;
end
if any(weight == 0,'all')
    error('AudioDenoising:UncoveredFrames','Mask inference left STFT frames uncovered.');
end
mask = min(max(maskSum./weight,0),1);
estimated = mask.*S;
reconstructed = istft(estimated,fs,'Window',window, ...
    'OverlapLength',cfg.overlapLength,'FFTLength',cfg.fftLength);
denoised = match_signal_length(reconstructed,numel(noisy));
end
