function save_quality_control(outputDir, recordName, targetSnrDb, fs, clean, noisy, estimate, method, cfg)
%SAVE_QUALITY_CONTROL Save optional audio and waveform/spectrogram figures.
safeRecord = regexprep(char(recordName),'[^A-Za-z0-9_-]','_');
safeMethod = regexprep(char(method),'[^A-Za-z0-9_-]','_');
tag = sprintf('%s_%s_snr_%+g',safeRecord,safeMethod,targetSnrDb);

if isfield(cfg,'saveAudio') && cfg.saveAudio
    audioDir = fullfile(outputDir,'audio');
    if ~isfolder(audioDir), mkdir(audioDir); end
    signals = [clean(:),noisy(:),estimate(:)];
    scale = max(1,max(abs(signals),[],'all'));
    audiowrite(fullfile(audioDir,[tag '_clean.wav']),signals(:,1)/scale,fs);
    audiowrite(fullfile(audioDir,[tag '_noisy.wav']),signals(:,2)/scale,fs);
    audiowrite(fullfile(audioDir,[tag '_estimate.wav']),signals(:,3)/scale,fs);
end

if isfield(cfg,'saveFigures') && cfg.saveFigures
    figureDir = fullfile(outputDir,'figures');
    if ~isfolder(figureDir), mkdir(figureDir); end
    fig = figure('Visible','off','Color','w');
    cleanup = onCleanup(@() close(fig));
    layout = tiledlayout(fig,2,2,'Padding','compact','TileSpacing','compact');
    time = (0:numel(clean)-1)'/fs;
    nexttile(layout); plot(time,clean); title('Clean'); xlabel('Time (s)');
    nexttile(layout); plot(time,noisy); title('Noisy'); xlabel('Time (s)');
    nexttile(layout); plot(time,estimate); title(char(method)); xlabel('Time (s)');
    nexttile(layout);
    spectrogram(estimate,hann(cfg.windowLength,'periodic'),cfg.overlapLength, ...
        cfg.fftLength,fs,'yaxis');
    title([char(method) ' spectrogram']);
    title(layout,sprintf('%s | target input SNR %+g dB',char(recordName),targetSnrDb));
    exportgraphics(fig,fullfile(figureDir,[tag '.png']),'Resolution',160);
end
end
