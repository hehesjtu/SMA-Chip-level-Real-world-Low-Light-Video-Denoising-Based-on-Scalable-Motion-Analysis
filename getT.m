function [ t ] = Copy_of_rgbgetT4( imgpadG_f,imgprepadG_f,wind )
%Copy_of_rgbgetT4���þ�ֵ���趨��ֵ�ĺ���
%   ����Ϊ�����Ҷȼ�ͼ���Լ���ı߳�wind
%   ���Ϊ�Զ��趨����ֵT(ʹ�ùյ㷨�õ�����ֵ))

global height;%ԭͼ�������
global width;%ԭͼ�������

too_big=25*wind*wind;

row_counter_b=floor(height/wind);%�������������ɵ���������
col_counter_b=floor(width/wind);%�������������ɵ���������
SAD_storage=zeros(row_counter_b,col_counter_b);%���ڼ�¼���ж�Ӧ��SAD�ı�������ʼ��Ϊ0

%% ������֡ͼ����Ӧ���SAD
for outer=1:row_counter_b%�����п�
    for inner=1:col_counter_b%�����п�
        [row,col]=block_trans(outer,inner,wind);
        temp1=imgpadG_f(row,col);
        temp2=imgprepadG_f(row,col);
        SAD_storage(outer,inner)=SAD(temp1,temp2);
    end
end

% ��SAD�����ų�һά����
SAD_queue=SAD_storage(:);

% ɾ��������
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

%% ������±�ת��Ϊ�����±�����ĺ��������磨1,1�����Ӧ�ľ����±�����Ϊ��1:wind,1:wind��
function [row,col]=block_trans(block_row,block_col,wind)
row=wind*(block_row-1)+1:wind*block_row;
col=wind*(block_col-1)+1:wind*block_col;
end
%% �����Ӧ���SADֵ�ĺ���
function [value]=SAD(former,latter)
result=max(former-latter,latter-former);
value=sum(sum(result));
end
%% nothing below this line