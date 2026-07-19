function audio = load_audio_record(path, targetFs)
%LOAD_AUDIO_RECORD Read, mono-convert, resample, center, and peak-normalize.
[x,fs]=audioread(path); x=double(x);
if size(x,2)>1, x=mean(x,2); end
if fs~=targetFs, x=resample(x,targetFs,fs); fs=targetFs; end
x=x-mean(x);
peak=max(abs(x));
if peak<=eps, error('AudioDenoising:SilentFile','Recording is silent.'); end
x=x/peak;
audio=struct('signal',x,'fs',fs,'path',string(path));
end
