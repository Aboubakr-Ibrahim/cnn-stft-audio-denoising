# Limitations

- Six recordings are insufficient to demonstrate clinical, speaker-independent, or population-level generalization.
- The configured single-recording test set supports engineering verification, not definitive benchmarking.
- File-level separation is only sufficient when files are independent. Recordings from the same speaker, patient, session, or source must be grouped together.
- White Gaussian noise does not represent all real acoustic or clinical environments.
- Peak normalization removes absolute-amplitude information and may not suit every respiratory-sound question.
- Training examples are not currently balanced by source duration, sound class, or speaker.
- Noisy-phase reconstruction limits achievable quality.
- SNR, MSE, correlation, and log-spectral distance do not replace perceptual or respiratory-domain expert review.
- Speech and respiratory sounds may have different spectral priorities and should be reported separately.
- The predecessor result of −9.3226 dB output SNR is documented as an unsuccessful prototype result, not promoted as evidence.
- The V2 implementation has been statically reviewed but still requires execution in the documented MATLAB environment.
- This repository is research and portfolio software, not a diagnostic, monitoring, or treatment device.
