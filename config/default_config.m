function cfg = default_config()
%DEFAULT_CONFIG Reproducible defaults for leakage-aware audio denoising.
cfg.targetFs = 16000;
cfg.randomSeed = 20260719;
cfg.trainFiles = ["ses-1.flac","ses-2.flac","ses-3.flac","ses-4.flac"];
cfg.validationFiles = "ses-5.flac";
cfg.testFiles = "ses-6.flac";
cfg.trainingSnrDb = [-5 0 5 10];
cfg.testSnrDb = [-5 0 5 10];
cfg.windowLength = 256;
cfg.overlapLength = 192;
cfg.fftLength = 256;
cfg.contextFrames = 64;
cfg.segmentHopFrames = 32;
cfg.maxEpochs = 30;
cfg.miniBatchSize = 32;
cfg.initialLearnRate = 1e-3;
cfg.executionEnvironment = 'auto';
cfg.saveAudio = false;
cfg.saveFigures = true;
end
