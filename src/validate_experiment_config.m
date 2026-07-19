function validate_experiment_config(cfg)
%VALIDATE_EXPERIMENT_CONFIG Validate parameters and disjoint recording splits.
required = ["targetFs","randomSeed","trainFiles","validationFiles","testFiles", ...
    "trainingSnrDb","testSnrDb","windowLength","overlapLength","fftLength", ...
    "contextFrames","segmentHopFrames"];
for name = required
    if ~isfield(cfg,name)
        error('AudioDenoising:MissingConfig','Missing configuration field: %s',name);
    end
end

trainFiles = string(cfg.trainFiles(:));
validationFiles = string(cfg.validationFiles(:));
testFiles = string(cfg.testFiles(:));
if any(strlength([trainFiles;validationFiles;testFiles]) == 0)
    error('AudioDenoising:EmptyFilename','Recording names must not be empty.');
end
if numel(unique(trainFiles)) ~= numel(trainFiles) || ...
        numel(unique(validationFiles)) ~= numel(validationFiles) || ...
        numel(unique(testFiles)) ~= numel(testFiles)
    error('AudioDenoising:DuplicateRecording','A split contains duplicate recordings.');
end
if ~isempty(intersect(trainFiles,validationFiles)) || ...
        ~isempty(intersect(trainFiles,testFiles)) || ...
        ~isempty(intersect(validationFiles,testFiles))
    error('AudioDenoising:Leakage','Train, validation, and test recordings must be disjoint.');
end

mustBePositive(cfg.targetFs);
mustBeInteger(cfg.targetFs);
mustBePositive(cfg.windowLength);
mustBeInteger(cfg.windowLength);
mustBeNonnegative(cfg.overlapLength);
mustBeInteger(cfg.overlapLength);
mustBePositive(cfg.fftLength);
mustBeInteger(cfg.fftLength);
mustBePositive(cfg.contextFrames);
mustBeInteger(cfg.contextFrames);
mustBePositive(cfg.segmentHopFrames);
mustBeInteger(cfg.segmentHopFrames);
if cfg.overlapLength >= cfg.windowLength
    error('AudioDenoising:InvalidOverlap','overlapLength must be smaller than windowLength.');
end
if cfg.fftLength < cfg.windowLength
    error('AudioDenoising:InvalidFFT','fftLength must be at least windowLength.');
end
if isempty(cfg.trainingSnrDb) || isempty(cfg.testSnrDb) || ...
        any(~isfinite([cfg.trainingSnrDb(:);cfg.testSnrDb(:)]))
    error('AudioDenoising:InvalidSNR','SNR levels must be finite and nonempty.');
end
end
