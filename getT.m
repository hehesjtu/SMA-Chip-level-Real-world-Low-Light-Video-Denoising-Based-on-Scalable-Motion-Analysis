function [ t ] = Copy_of_rgbgetT4( imgpadG_f,imgprepadG_f,wind )
%Copy_of_rgbgetT4是用均值法设定阈值的函数
%   输入为两幅灰度级图像以及块的边长wind
%   输出为自动设定的阈值T(使用拐点法得到的阈值))

global height;%原图像的行数
global width;%原图像的列数

too_big=25*wind*wind;

row_counter_b=floor(height/wind);%总行数下能容纳的完整块数
col_counter_b=floor(width/wind);%总列数下能容纳的完整块数
SAD_storage=zeros(row_counter_b,col_counter_b);%用于记录所有对应块SAD的变量，初始化为0

%% 计算两帧图像间对应块的SAD
for outer=1:row_counter_b%遍历行块
    for inner=1:col_counter_b%遍历列块
        [row,col]=block_trans(outer,inner,wind);
        temp1=imgpadG_f(row,col);
        temp2=imgprepadG_f(row,col);
        SAD_storage(outer,inner)=SAD(temp1,temp2);
    end
end

% 将SAD矩阵排成一维数组
SAD_queue=SAD_storage(:);

% 删掉过大者
for loop=numel(SAD_queue):-1:1
    if SAD_queue(loop)>too_big;
        SAD_queue(loop)=[];
    end
end

pixel_queue=SAD_queue/wind/wind;
mean_value=mean(pixel_queue);
% std_value=std(pixel_queue);
t=mean_value;
end

%% 将块的下标转化为矩阵下标区域的函数。比如（1,1）块对应的矩阵下标区域即为（1:wind,1:wind）
function [row,col]=block_trans(block_row,block_col,wind)
row=wind*(block_row-1)+1:wind*block_row;
col=wind*(block_col-1)+1:wind*block_col;
end
%% 计算对应块的SAD值的函数
function [value]=SAD(former,latter)
result=max(former-latter,latter-former);
value=sum(sum(result));
end
%% nothing below this line