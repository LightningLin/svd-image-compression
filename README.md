# SVD Image Compression

This repository contains MATLAB code for compressing colour images using low‑rank approximation via Singular Value Decomposition (SVD). The project was also developed as part of the linear algebra course.

## Features
- Supports both grayscale and colour images (RGB channels processed independently).
- Computes compression ratio and PSNR for every k = 1..256.
- Generates publication‑ready figures: singular value decay, PSNR vs k, rate‑distortion curve, and reconstruction comparison.
- Modular code – easy to extend.

## Requirements
- MATLAB R2026a or later. (I'm not sure if earlier version can also work. But you can have a try!)
- Image Processing Toolbox (for `imread`, `imresize`, `rgb2gray`, etc.).

## Usage
1. Clone this repository.
2. Open MATLAB and navigate to the `code/` folder.
3. Run `svd_compress` – a file selection dialog will appear.
4. Choose an image (recommended size: 256×256). The program will compute all results and save figures to `../code/figures/`.

## Example pictures info
Pics 1 & 2 are from [pexels](https://www.pexels.com/).
Pic3 is a furry I drew. Pics 4 & 5 are photos I took.

## License
MIT

## Citation
If you use this code, please cite the project repository: [https://github.com/LightningLin/svd-image-compression](https://github.com/LightningLin/svd-image-compression)  
If you like this project, please consider giving it a star ⭐. Your support is much appreciated:)
