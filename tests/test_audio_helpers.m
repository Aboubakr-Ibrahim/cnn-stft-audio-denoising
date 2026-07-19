classdef test_audio_helpers < matlab.unittest.TestCase
    methods(Test)
        function exactNoiseSNR(testCase)
            addpath('src');
            stream = RandStream('Threefry','Seed',7);
            clean = sin(2*pi*(0:15999)'/100);
            [noisy,noise] = add_noise_at_snr(clean,5,stream);
            measured = 10*log10(sum(clean.^2)/sum(noise.^2));
            testCase.verifyEqual(measured,5,'AbsTol',1e-10)
            testCase.verifyEqual(noisy,clean+noise,'AbsTol',1e-12)
        end

        function perfectEstimateHasHighSNR(testCase)
            addpath('src');
            stream = RandStream('Threefry','Seed',9);
            clean = randn(stream,1000,1);
            noisy = clean+0.1*randn(stream,1000,1);
            metric = evaluate_denoising(clean,noisy,clean);
            testCase.verifyGreaterThan(metric.OutputSNR_dB,100)
            testCase.verifyEqual(metric.MSE,0,'AbsTol',1e-12)
            testCase.verifyEqual(metric.SampleCount,1000)
        end

        function splitFilesAreDisjoint(testCase)
            addpath('config','src');
            cfg = default_config();
            testCase.verifyWarningFree(@() validate_experiment_config(cfg))
            cfg.testFiles = cfg.trainFiles(1);
            testCase.verifyError(@() validate_experiment_config(cfg), ...
                'AudioDenoising:Leakage')
        end

        function evaluationRejectsLengthMismatch(testCase)
            addpath('src');
            testCase.verifyError(@() evaluate_denoising(ones(10,1), ...
                ones(9,1),ones(10,1)),'AudioDenoising:LengthMismatch')
        end

        function reconstructionLengthIsExact(testCase)
            addpath('src');
            testCase.verifySize(match_signal_length((1:7)',10),[10 1])
            testCase.verifyEqual(match_signal_length((1:12)',10),(1:10)')
        end

        function shortSpectrogramIsRejected(testCase)
            addpath('config','src');
            cfg = default_config();
            input = zeros(129,cfg.contextFrames-1);
            testCase.verifyError(@() segment_spectrogram(input,input,cfg), ...
                'AudioDenoising:RecordingTooShort')
        end
    end
end
