# CNN–STFT Audio Denoising

A leakage-aware MATLAB research framework for denoising speech and respiratory-sound recordings using short-time Fourier transforms (STFT), convolutional neural-network mask estimation, inverse-STFT reconstruction, baseline comparison, and objective signal-quality metrics.

## Project background

I developed the predecessor experiment as paid freelance biomedical research and MATLAB work. The original prototype demonstrated CNN/STFT implementation, but used only three training recordings, reused a training recording for testing, and produced a negative reported output SNR. This V2 repository preserves that history while repairing the experimental design instead of presenting the old result as evidence.

## What V2 adds

- Recording-level train, validation, and test separation
- Runtime rejection of duplicate or overlapping split files
- Source-recording and target-SNR provenance for every training segment
- Seeded noise generation and controlled SNR conditions
- Windowed spectrogram examples instead of one sample per recording
- Bounded ideal-ratio-mask target
- CNN mask estimation with overlapping inference windows
- Exact-length inverse-STFT reconstruction
- Spectral-subtraction baseline
- Strict aligned-signal evaluation without silent truncation
- Input/output SNR, SNR improvement, MSE, correlation, log-spectral distance, and sample count
- Optional held-out audio examples and waveform/spectrogram QC figures
- Tests for leakage, exact noise SNR, reconstruction length, alignment, and short recordings
- Explicit ownership, privacy, methodology, and limitations documentation

## Default experimental split

| Split | Recordings |
|---|---|
| Training | ses-1, ses-2, ses-3, ses-4 |
| Validation | ses-5 |
| Test | ses-6 |

This split is configuration, not a performance claim. Files from the same speaker, patient, session, or original source must be grouped together. More independent recordings are required for generalizable research.

## Repository structure

| Path | Purpose |
|---|---|
| config | Reproducible experiment settings |
| src | Loading, augmentation, STFT, CNN, reconstruction, evaluation, and QC |
| tests | MATLAB unit tests for critical safeguards |
| docs | Methodology, limitations, ownership, and privacy |
| data | Local-data instructions; recordings are excluded |
| results | Instructions for reviewed V2 outputs |
| models | Local-model instructions; trained weights are excluded |

## Quick start

~~~matlab
addpath('config','src');
cfg = default_config();
results = runtests('tests');
table(results)
artifacts = run_experiment("data","results",cfg);
~~~

Expected local files are ses-1.flac through ses-6.flac. They are deliberately excluded from GitHub. By default, metrics, a model checkpoint, and QC figures are generated. Set cfg.saveAudio to true only when the recordings may be shared safely.

## Requirements

- MATLAB R2022b or newer recommended
- Audio Toolbox
- Signal Processing Toolbox
- Deep Learning Toolbox

## Verification status

V2 has been statically reviewed but has not been executed in this environment because MATLAB is unavailable. No V2 numerical result is claimed. Metrics should be published only after the tests pass, the current experiment completes, split independence is confirmed, and every held-out condition is reviewed.

## Responsible use

Research and portfolio software only. It is not a medical device and must not be used for respiratory diagnosis, clinical monitoring, alarms, or treatment decisions.

## Author and contribution

**Aboubakr Ibrahim** — Freelance Biomedical Research & MATLAB Developer

Contribution: MATLAB implementation, STFT/ISTFT workflow, CNN experimentation, signal analysis, evaluation, visualization, and documentation.

## License

[MIT](LICENSE)
