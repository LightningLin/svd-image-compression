function svd_compress(img_path, mode, save_dir)
% SVD 图像压缩主程序
% 输入：
%   img_path - 图片路径（可选，不提供则弹窗）
%   mode     - 'auto'（保留彩色）或 'gray'（强制灰度）
%   save_dir - 图片保存文件夹（可选，默认为 './figures'）

    if nargin < 1 || isempty(img_path)
        img_path = [];
    end
    if nargin < 2 || isempty(mode)
        mode = 'auto';
    end
    if nargin < 3 || isempty(save_dir)
        save_dir = './figures';
    end

    % 创建保存目录（如果不存在）
    if ~exist(save_dir, 'dir')
        mkdir(save_dir);
        fprintf('创建文件夹: %s\n', save_dir);
    end

    %% 1. 加载并预处理图像
    [I_orig, I_double, m, n, channels] = img_preprocess(img_path, mode);
    fprintf('图像尺寸: %d x %d, 通道数: %d\n', m, n, channels);
    
    %% 2. 分析（灰度或彩色）
    if channels == 1
        [psnr_vals, ratio_vals, U, S, V, s] = svd_analysis(I_double);
        plot_all_results(I_orig, U, S, V, psnr_vals, ratio_vals, s, m, n, channels, save_dir);
    else
        psnr_vals_all = zeros(3, 256);
        ratio_vals_all = zeros(3, 256);
        s_all = cell(3,1);
        U_all = cell(3,1); S_all = cell(3,1); V_all = cell(3,1);
        for ch = 1:3
            I_ch = I_double(:,:,ch);
            [psnr_vals, ratio_vals, U, S, V, s] = svd_analysis(I_ch);
            psnr_vals_all(ch,:) = psnr_vals;
            ratio_vals_all(ch,:) = ratio_vals;
            s_all{ch} = s;
            U_all{ch} = U; S_all{ch} = S; V_all{ch} = V;
        end
        psnr_vals_mean = mean(psnr_vals_all, 1);
        ratio_vals = ratio_vals_all(1,:);
        plot_all_results(I_orig, U_all, S_all, V_all, psnr_vals_mean, ratio_vals, s_all, m, n, channels, save_dir);
    end
    
    %% 3. 输出表格
    fprintf('\n====== Key results ======\n');
    fprintf('k\t压缩比\t\tPSNR (dB)\n');
    k_show = [5, 10, 20, 30, 50, 80, 100, 150, 200, 256];
    for k = k_show
        fprintf('%d\t%.2f\t\t%.2f\n', k, ratio_vals(k), psnr_vals_mean(k));
    end
    fprintf('==========================================\n');
    fprintf('图片已保存至: %s\n', save_dir);
end
