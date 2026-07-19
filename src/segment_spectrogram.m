function [inputs, targets] = segment_spectrogram(inputMap, targetMap, cfg)
%SEGMENT_SPECTROGRAM Split one recording into fixed context windows.
if ~isequal(size(inputMap),size(targetMap))
    error('AudioDenoising:MapSizeMismatch', ...
        'Input and target spectrogram maps must have identical sizes.');
end
frames = size(inputMap,2);
if frames < cfg.contextFrames
    error('AudioDenoising:RecordingTooShort', ...
        'Recording has %d STFT frames; at least %d are required.', ...
        frames,cfg.contextFrames);
end
starts = 1:cfg.segmentHopFrames:(frames-cfg.contextFrames+1);
inputs = zeros(size(inputMap,1),cfg.contextFrames,1,numel(starts),'single');
targets = zeros(size(targetMap,1),cfg.contextFrames,1,numel(starts),'single');
for i = 1:numel(starts)
    index = starts(i):(starts(i)+cfg.contextFrames-1);
    inputs(:,:,1,i) = single(inputMap(:,index));
    targets(:,:,1,i) = single(targetMap(:,index));
end
end
