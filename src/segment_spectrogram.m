function [inputs, targets] = segment_spectrogram(inputMap, targetMap, cfg)
%SEGMENT_SPECTROGRAM Split one recording into fixed context windows.
frames=size(inputMap,2); starts=1:cfg.segmentHopFrames:(frames-cfg.contextFrames+1);
inputs=zeros(size(inputMap,1),cfg.contextFrames,1,numel(starts),'single');
targets=zeros(size(targetMap,1),cfg.contextFrames,1,numel(starts),'single');
for i=1:numel(starts)
    index=starts(i):(starts(i)+cfg.contextFrames-1);
    inputs(:,:,1,i)=single(inputMap(:,index));
    targets(:,:,1,i)=single(targetMap(:,index));
end
end
