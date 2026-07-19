function artifacts = run_experiment(dataDir, outputDir, cfg)
%RUN_EXPERIMENT Leakage-safe training, held-out testing, and comparison.
validate_experiment_config(cfg);
if ~isfolder(dataDir)
    error('AudioDenoising:MissingDataDirectory','Data directory not found: %s',dataDir);
end
if ~isfolder(outputDir), mkdir(outputDir); end

trainSet = prepare_split(dataDir,cfg.trainFiles,cfg.trainingSnrDb,cfg,0);
validationSet = prepare_split(dataDir,cfg.validationFiles,cfg.trainingSnrDb,cfg,1000);
net = train_denoising_model(trainSet,validationSet,cfg);

stream = RandStream('Threefry','Seed',cfg.randomSeed+2000);
rows = cell(numel(cfg.testFiles)*numel(cfg.testSnrDb)*2,1);
rowIndex = 0;
for fileIndex = 1:numel(cfg.testFiles)
    audio = load_audio_record(fullfile(dataDir,cfg.testFiles(fileIndex)),cfg.targetFs);
    for snrIndex = 1:numel(cfg.testSnrDb)
        targetSnrDb = cfg.testSnrDb(snrIndex);
        [noisy,~] = add_noise_at_snr(audio.signal,targetSnrDb,stream);
        estimates = { ...
            "CNN",denoise_with_model(net,noisy,audio.fs,cfg); ...
            "Spectral subtraction",spectral_subtraction_baseline(noisy,audio.fs,cfg)};
        for methodIndex = 1:size(estimates,1)
            method = estimates{methodIndex,1};
            estimate = estimates{methodIndex,2};
            metric = evaluate_denoising(audio.signal,noisy,estimate);
            metric.Record = cfg.testFiles(fileIndex);
            metric.Method = method;
            metric.TargetInputSNR_dB = targetSnrDb;
            rowIndex = rowIndex+1;
            rows{rowIndex} = metric;
            save_quality_control(outputDir,cfg.testFiles(fileIndex),targetSnrDb, ...
                audio.fs,audio.signal,noisy,estimate,method,cfg);
        end
    end
end

summary = struct2table(vertcat(rows{:}));
summary = movevars(summary,{'Record','Method','TargetInputSNR_dB'},'Before',1);
writetable(summary,fullfile(outputDir,'denoising_metrics.csv'));
save(fullfile(outputDir,'trained_model.mat'),'net','cfg','-v7.3');
artifacts = struct('network',net,'summary',summary, ...
    'trainRecordings',unique(trainSet.recording), ...
    'validationRecordings',unique(validationSet.recording), ...
    'testRecordings',string(cfg.testFiles(:)));
end
