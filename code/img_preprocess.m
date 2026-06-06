function [I_orig, I_double, m, n, channels] = img_preprocess(img_path, mode)
% 图像预处理：读图、缩放至256×256、归一化到[0,1]
% 输入：
%   img_path - 图片路径（若为空或未提供则弹窗）
%   mode     - 'auto'（保留原色彩，彩色输出3通道），'gray'（强制转灰度）
% 输出：
%   I_orig   - 原始图像（uint8，尺寸256×256，若彩色则为3通道）
%   I_double - 归一化后的双精度矩阵（值域[0,1]）
%   m,n      - 尺寸（均为256）
%   channels - 通道数（1或3）

if nargin < 1 || isempty(img_path)
    [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, '请选择图片');
    if isequal(filename, 0)
        error('未选择图片，程序终止');
    end
    img_path = fullfile(pathname, filename);
end
if nargin < 2
    mode = 'auto';
end

I = imread(img_path);

% 根据 mode 决定是否转灰度
if strcmp(mode, 'gray')
    if size(I,3) == 3
        I = rgb2gray(I);
    end
else  % auto: 保留原始类型
    % 不做转换
end

% 缩放至256×256（直接缩放，因为后续矩阵尺寸固定）
I_resized = imresize(I, [256, 256]);

% 获取通道数
if ndims(I_resized) == 2
    channels = 1;
else
    channels = size(I_resized, 3);
end

% 归一化
I_double = double(I_resized) / 255;

% 输出原图（uint8）
I_orig = I_resized;
m = 256; n = 256;
end
