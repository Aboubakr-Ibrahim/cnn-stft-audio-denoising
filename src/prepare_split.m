function dataset = prepare_split(dataDir, files, snrLevels, cfg, seedOffset)
%PREPARE_SPLIT Build segments while preserving recording-level boundaries.
stream = RandStream('Threefry','Seed',cfg.randomSeed+seedOffset);
allInputs = [];
allTargets = [];
provenance = strings(0,1);
targetSnr = zeros(0,1);
for fileIndex = 1:numel(files)
    audio = load_audio_record(fullfile(dataDir,files(fileIndex)),cfg.targetFs);
    for snrIndex = 1:numel(snrLevels)
        [noisy,~] = add_noise_at_snr(audio.signal,snrLevels(snrIndex),stream);
        pair = stft_pair(audio.signal,noisy,audio.fs,cfg);
        [inputs,targets] = segment_spectrogram(pair.input,pair.target,cfg);
        if isempty(allInputs)
            allInputs = inputs;
            allTargets = targets;
        else
            allInputs = cat(4,allInputs,inputs);
            allTargets = cat(4,allTargets,targets);
        end
        segmentCount = size(inputs,4);
        provenance = [provenance;repmat(files(fileIndex),segmentCount,1)]; %#ok<AGROW>
        targetSnr = [targetSnr;repmat(snrLevels(snrIndex),segmentCount,1)]; %#ok<AGROW>
    end
end
dataset = struct('inputs',allInputs,'targets',allTargets, ...
    'recording',provenance,'targetSnrDb',targetSnr);
end
