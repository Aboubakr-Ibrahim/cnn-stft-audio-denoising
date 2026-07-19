function [noisy, noise] = add_noise_at_snr(clean, targetSnrDb, stream)
%ADD_NOISE_AT_SNR Add reproducible white Gaussian noise at an exact SNR.
arguments
    clean {mustBeNumeric,mustBeVector}
    targetSnrDb (1,1) double
    stream = RandStream.getGlobalStream
end
x=double(clean(:)); noise=randn(stream,size(x));
signalPower=mean(x.^2); noisePower=mean(noise.^2);
noise=noise*sqrt(signalPower/(noisePower*10^(targetSnrDb/10)));
noisy=x+noise;
end
