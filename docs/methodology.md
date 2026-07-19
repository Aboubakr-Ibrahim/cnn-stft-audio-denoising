# Methodology

V2 splits complete recordings before any segmentation or noise augmentation. Training uses ses-1 through ses-4, validation uses ses-5, and ses-6 remains held out for final evaluation. This prevents fragments of one recording from appearing in multiple experimental splits.

Clean signals are mono-converted, resampled to 16 kHz, centered, and peak-normalized. Reproducible Gaussian noise is scaled to controlled SNR conditions. STFT log magnitude is the network input. The target is a bounded ideal ratio mask. Overlapping mask predictions are averaged and combined with noisy phase for ISTFT reconstruction.

The CNN is compared with a non-learning spectral-subtraction baseline. Evaluation reports input/output SNR, improvement, MSE, correlation, and log-spectral distance for every held-out condition.
