# CNN–STFT Audio Denoising

A leakage-aware MATLAB research framework for denoising speech and respiratory-sound recordings using short-time Fourier transforms (STFT), convolutional neural-network mask estimation, inverse STFT reconstruction, baseline comparison, and objective signal-quality metrics.

## Project background

I developed the predecessor experiment as paid freelance biomedical research and MATLAB work. The original prototype demonstrated CNN/STFT implementation, but used only three training recordings, reused a training recording for testing, and produced a negative reported output SNR. This V2 repository repairs that experimental design rather than promoting the old result.

## V2 improvements

- Recording-level train/validation/test separation
- No segment from a held-out recording enters training
- Fixed random seed and controlled input-SNR conditions
- Windowed spectrogram examples instead of one sample per recording
- Bounded ideal-ratio-mask target
- CNN mask estimation with noisy-phase reconstruction
- Spectral-subtraction baseline
- Input SNR, output SNR, SNR improvement, MSE, correlation, and log-spectral distance
- Waveform/spectrogram quality-control figures
- Explicit ownership, privacy, and limitations documentation

## Default split

| Split | Recordings |
|---|---|
| Training | ses-1, ses-2, ses-3, ses-4 |
| Validation | ses-5 |
| Test | ses-6 |

This split is configuration, not a performance claim. More recordings and source-level grouping are required for generalizable research.

## Quick start

```matlab
addpath('config','src');
cfg = default_config();
artifacts = run_experiment("data", "results", cfg);
```

Expected local files are `ses-1.flac` through `ses-6.flac`. They are deliberately excluded from GitHub.

## Requirements

- MATLAB R2022b or newer recommended
- Audio Toolbox
- Signal Processing Toolbox
- Deep Learning Toolbox

## Verification status

The V2 code has been statically reviewed, but it has not been executed here because MATLAB is unavailable. Run:

```matlab
results = runtests('tests');
table(results)
```

No numerical denoising result should be published until the current code is executed and its outputs are reviewed.

## Responsible use

Research and portfolio software only. It is not a medical device and must not be used for respiratory diagnosis, clinical monitoring, alarms, or treatment decisions.

## Author and contribution

**Aboubakr Ibrahim** — Freelance Biomedical Research & MATLAB Developer  
Contribution: MATLAB implementation, STFT/ISTFT workflow, CNN experimentation, signal analysis, evaluation, visualization, and documentation.

## License

[MIT](LICENSE)
