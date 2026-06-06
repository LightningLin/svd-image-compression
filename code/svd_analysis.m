function [psnr_vals, ratio_vals, U, S, V, s] = svd_analysis(I_double)
% 对单通道图像矩阵进行 SVD，计算所有 k 的 PSNR 和压缩比
% 输入：I_double - m×n double，值域[0,1]
% 输出：
%   psnr_vals  - 1×256 向量，每个 k 对应的 PSNR (dB)
%   ratio_vals - 1×256 向量，每个 k 对应的压缩比
%   U, S, V    - SVD 分解结果
%   s          - 奇异值向量 (diag(S))

[m, n] = size(I_double);
[U, S, V] = svd(I_double);
s = diag(S);

k_max = min(m, n);  % 对于方阵是256
psnr_vals = zeros(1, k_max);
ratio_vals = zeros(1, k_max);

% 预计算压缩比的分母因子（与k无关的部分）
denom_factor = m + n + 1;
total_pixels = m * n;

for k = 1:k_max
    % 重建图像
    I_k = U(:,1:k) * S(1:k,1:k) * V(:,1:k)';
    % 计算 MSE
    diff = I_double - I_k;
    mse = mean(diff(:).^2);
    if mse == 0
        psnr = Inf;
    else
        psnr = 10 * log10(1 / mse);  % MAX=1
    end
    psnr_vals(k) = psnr;
    % 压缩比
    ratio_vals(k) = total_pixels / (k * denom_factor);
end
end