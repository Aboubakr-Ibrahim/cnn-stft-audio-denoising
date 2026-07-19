function y = match_signal_length(y, targetLength)
%MATCH_SIGNAL_LENGTH Return a finite column vector with an exact length.
arguments
    y {mustBeNumeric,mustBeVector}
    targetLength (1,1) double {mustBeInteger,mustBeNonnegative}
end
y = double(y(:));
if any(~isfinite(y))
    error('AudioDenoising:NonfiniteReconstruction', ...
        'Reconstructed audio contains NaN or Inf values.');
end
if numel(y) >= targetLength
    y = y(1:targetLength);
else
    y(end+1:targetLength,1) = 0;
end
end
