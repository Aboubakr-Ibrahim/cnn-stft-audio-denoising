# Methodology

## Experimental separation

V2 splits complete recordings before segmentation or noise augmentation. Training uses ses-1 through ses-4, validation uses ses-5, and ses-6 remains held out for final evaluation. Runtime validation rejects duplicate files or overlap among any of the three splits. Every training example retains its source-recording and target-SNR provenance.

This structure prevents fragments of one configured recording from appearing in multiple experimental splits. If several recordings come from the same speaker, patient, session, or original source, they must also be grouped at that higher level before publication.

## Signal preparation and augmentation

Clean signals are converted to mono, resampled to 16 kHz, centered, and peak-normalized. A seeded random stream generates white Gaussian noise that is scaled to each controlled input-SNR condition. Recordings too short to supply one complete context window are rejected with a clear error instead of silently producing an empty dataset.

## CNN/STFT workflow

The network input is noisy STFT log magnitude. The target is a bounded ideal ratio mask. A compact fully convolutional network predicts masks for overlapping context windows. Predictions are averaged where windows overlap, bounded to [0,1], and combined with noisy phase for inverse-STFT reconstruction.

Reconstructed signals are forced to the original sample count. Evaluation rejects empty, non-finite, or unequal-length signal pairs rather than silently truncating them.

## Evaluation

The CNN is compared with a non-learning spectral-subtraction baseline on the held-out recording. Per-condition output includes:

- achieved input and output SNR
- SNR improvement
- mean squared error
- waveform correlation
- log-spectral distance
- evaluated sample count

When enabled, the experiment also saves aligned audio examples and waveform/spectrogram quality-control figures. These artifacts support review; they do not establish clinical performance.
