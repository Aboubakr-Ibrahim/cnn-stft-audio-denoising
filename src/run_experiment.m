function artifacts = run_experiment(dataDir, outputDir, cfg)
%RUN_EXPERIMENT Leakage-safe training, testing, and baseline comparison.
if ~isfolder(outputDir),mkdir(outputDir);end
trainSet=prepare_split(dataDir,cfg.trainFiles,cfg.trainingSnrDb,cfg,0);
validationSet=prepare_split(dataDir,cfg.validationFiles,cfg.trainingSnrDb,cfg,1000);
assert(isempty(intersect(unique(trainSet.recording),unique(validationSet.recording))),...
    'AudioDenoising:Leakage','Train/validation overlap.');
net=train_denoising_model(trainSet,validationSet,cfg);
stream=RandStream('Threefry','Seed',cfg.randomSeed+2000);
rows=cell(numel(cfg.testFiles)*numel(cfg.testSnrDb)*2,1); rowIndex=0;
for fileIndex=1:numel(cfg.testFiles)
    audio=load_audio_record(fullfile(dataDir,cfg.testFiles(fileIndex)),cfg.targetFs);
    for snrIndex=1:numel(cfg.testSnrDb)
        [noisy,~]=add_noise_at_snr(audio.signal,cfg.testSnrDb(snrIndex),stream);
        cnn=denoise_with_model(net,noisy,audio.fs,cfg);
        baseline=spectral_subtraction_baseline(noisy,audio.fs,cfg);
        methods={{"CNN",cnn},{"Spectral subtraction",baseline}};
        for methodIndex=1:numel(methods)
            rowIndex=rowIndex+1; item=methods{methodIndex};
            metric=evaluate_denoising(audio.signal,noisy,item{2});
            metric.Record=cfg.testFiles(fileIndex);
            metric.Method=item{1}; metric.TargetInputSNR_dB=cfg.testSnrDb(snrIndex);
            rows{rowIndex}=metric;
        end
    end
end
summary=struct2table(vertcat(rows{:}));
writetable(summary,fullfile(outputDir,'denoising_metrics.csv'));
save(fullfile(outputDir,'trained_model.mat'),'net','cfg');
artifacts=struct('network',net,'summary',summary,...
    'trainRecordings',unique(trainSet.recording),...
    'validationRecordings',unique(validationSet.recording),...
    'testRecordings',cfg.testFiles);
end
