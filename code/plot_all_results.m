function plot_all_results(I_orig, U, S, V, psnr_vals, ratio_vals, s, m, n, channels, save_dir)
% 生成全部4张图表并保存到指定文件夹
    if nargin < 11 || isempty(save_dir)
        save_dir = '.';
    end
    if ~exist(save_dir, 'dir')
        mkdir(save_dir);
    end
    
    is_color = (channels == 3);
    
    %% 图1：奇异值曲线
    figure('Name', 'Singular Values');
    if ~is_color
        plot(s, 'o-', 'LineWidth', 1.5);
        legend('Grayscale');
    else
        hold on;
        colors = {'r','g','b'};
        for ch = 1:3
            plot(s{ch}, 'o-', 'LineWidth', 1.5, 'Color', colors{ch});
        end
        legend('Red', 'Green', 'Blue');
        hold off;
    end
    xlabel('Index i'); ylabel('\sigma_i');
    title('Singular Value Decay'); grid on;
    saveas(gcf, fullfile(save_dir, 'singular_values.png'));
    
    %% 图2：PSNR vs k（带30dB交点标注）
    figure('Name', 'PSNR vs k');
    set(gcf, 'Color', 'white');
    plot(1:256, psnr_vals, 'r-', 'LineWidth', 2);
    xlabel('Number of singular values k'); ylabel('PSNR (dB)');
    title('PSNR vs. k'); grid on;
    hold on;
    yline(30, 'k--', 'LineWidth', 1.5);
    % 找到第一个 PSNR >= 30 的 k 值
    k30 = find(psnr_vals >= 30, 1, 'first');
    if ~isempty(k30)
        psnr30 = psnr_vals(k30);
        plot(k30, psnr30, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
        text(k30-15, psnr30+10, sprintf('(k=%d, %.1f dB)', k30, psnr30), ...
            'FontSize', 9, 'BackgroundColor', 'w', 'EdgeColor', 'k');
    end
    % 标注30dB线文字
    text(180, 35, 'PSNR = 30 dB (visually lossless)', 'FontSize', 10);
    hold off;
    set(gca, 'Color', 'white', 'XColor', 'k', 'YColor', 'k');
    saveas(gcf, fullfile(save_dir, 'psnr_vs_k.png'));
        
    %% 图3：率失真曲线
    figure('Name', 'Rate-Distortion');
    plot(ratio_vals, psnr_vals, 'b-', 'LineWidth', 2);
    xlabel('Compression Ratio'); ylabel('PSNR (dB)');
    title('Rate-Distortion Curve'); grid on;
    hold on;
    k_markers = [5, 10, 20, 50, 100];
    for k = k_markers
        ratio_k = ratio_vals(k);
        psnr_k = psnr_vals(k);
        plot(ratio_k, psnr_k, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        text(ratio_k, psnr_k+5, sprintf('k=%d', k), 'FontSize', 10, 'HorizontalAlignment', 'center');
    end
    hold off;
    saveas(gcf, fullfile(save_dir, 'rate_distortion.png'));
    
    %% 图4：重建对比图
    figure('Name', 'Reconstruction Comparison');
    k_disp = [5, 10, 20, 50, 100];
    if is_color
        U_all = U; S_all = S; V_all = V;
        subplot(2,3,1); imshow(I_orig); title('Original');
        for idx = 1:5
            k = k_disp(idx);
            R_k = U_all{1}(:,1:k) * S_all{1}(1:k,1:k) * V_all{1}(:,1:k)';
            G_k = U_all{2}(:,1:k) * S_all{2}(1:k,1:k) * V_all{2}(:,1:k)';
            B_k = U_all{3}(:,1:k) * S_all{3}(1:k,1:k) * V_all{3}(:,1:k)';
            I_k = cat(3, R_k, G_k, B_k);
            I_k = max(0, min(1, I_k));
            subplot(2,3,idx+1); imshow(I_k); title(sprintf('k = %d', k));
        end
    else
        subplot(2,3,1); imshow(I_orig); title('Original');
        for idx = 1:5
            k = k_disp(idx);
            I_k = U(:,1:k) * S(1:k,1:k) * V(:,1:k)';
            subplot(2,3,idx+1); imshow(I_k); title(sprintf('k = %d', k));
        end
    end
    sgtitle('SVD Reconstruction Comparison');
    saveas(gcf, fullfile(save_dir, 'reconstruction_comparison.png'));
end