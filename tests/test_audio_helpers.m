classdef test_audio_helpers < matlab.unittest.TestCase
    methods(Test)
        function exactNoiseSNR(testCase)
            addpath('src'); stream=RandStream('Threefry','Seed',7);
            clean=sin(2*pi*(0:15999)'/100);
            [noisy,noise]=add_noise_at_snr(clean,5,stream);
            measured=10*log10(sum(clean.^2)/sum(noise.^2));
            testCase.verifyEqual(measured,5,'AbsTol',1e-10)
            testCase.verifyEqual(noisy,clean+noise,'AbsTol',1e-12)
        end
        function perfectEstimateHasHighSNR(testCase)
            addpath('src'); clean=randn(1000,1); noisy=clean+0.1*randn(1000,1);
            m=evaluate_denoising(clean,noisy,clean);
            testCase.verifyGreaterThan(m.OutputSNR_dB,100)
            testCase.verifyEqual(m.MSE,0,'AbsTol',1e-12)
        end
        function splitFilesAreDisjoint(testCase)
            addpath('config'); cfg=default_config();
            testCase.verifyEmpty(intersect(cfg.trainFiles,cfg.validationFiles))
            testCase.verifyEmpty(intersect(cfg.trainFiles,cfg.testFiles))
            testCase.verifyEmpty(intersect(cfg.validationFiles,cfg.testFiles))
        end
    end
end
