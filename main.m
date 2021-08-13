clc;clear all;close all;
warning('off','all');

%% ����ȫ�ֱ���
global width;           global height;          %ͼ���ȸ߶�
global cell_width;      global cell_height;      %ͼ���Ⱥ͸߶ȷ��������ɵĿ����
global windowSize;      global SADsize;         %��߳��ͼ���SADʱ�ı߳�
global ref_pixel;       global ref_block;       %���ص�Ϳ��λ�ò���
global searchwindow;    global not_found;       %��������С���޷�ƥ����mv=��not_found not_found��
global average_level;                           %Ȩ��ϵ��
global threshold;                               %��������
global upleft;          global downright;       %�����������SAD��λ�ù�ϵ�ı���
global imgpadG;         global imgprepadG;      %��ǰͼ���ǰһ֡ͼ��ĻҶ�ͼ
global  const1;         global  const2;         

%% �����µ���Ƶ���У����ڴ��ȥ����ͼ��
aviobj = avifile('near_noisy_result.avi');
aviobj.Quality = 100;
aviobj.Fps=5;
aviobj.compression='None';

%% ��ȡ��Ƶ 
mov=VideoReader('near_result.avi');
n=mov.NumberOfFrames;
%% �����µ��ļ��У����ڴ�ŵ�֡��ͼ������
dirname='near_result';
directory=[cd,['\' dirname '\']];
mkdir([cd,['\' dirname]]);
ori_pic='ori_near.jpg';         %ԭʼͼƬ����
denos_pic='result_near.jpg';    %ȥ���ͼƬ����

%% ������ʼ��
average_level=5;  
searchwindow=48;
windowSize=16;  scale=4;

ref_pixel=ceil(searchwindow/windowSize+1)*windowSize;
not_found=searchwindow+1;
filter=[1 4 7 4 1;4 16 26 16 4;7 26 41 26 7;4 16 26 16 4;1 4 7 4 1];
filter=filter/sum(sum(filter));     %�˲�����Ҫ���ڼ�Ȩϵ����ƽ��

%% ������
for outer_loop=2:n
    
    fprintf('��ǰ�����ѭ������ֵΪ  %d  \n',outer_loop);

    windowSize=16;
    SADsize=windowSize*2;
    upleft=(SADsize-windowSize)/2;    
    downright=windowSize+upleft-1; 
    ref_block=ref_pixel/windowSize; 
    %��ȡǰһ֡ͼ����Ϣ��ͬʱ��ʼ����ȸ߶ȵȱ���
    if outer_loop==2
        imgpre=read(mov,outer_loop-1);
        [height,width,~]=size(imgpre);
        
%        cutw=2;cuth=1;
%        width=width/cutw;    
%        height=height/cuth;
         
        cell_height=floor(height/windowSize);
        cell_width=floor(width/windowSize);
        height=windowSize*cell_height;
        width=windowSize*cell_width;
        imgpre=imgpre(1:height,1:width,:);
        
        imgprepad=padarray(imgpre,[ref_pixel,ref_pixel],'symmetric','both');
        clear imgpre;
        imgprepadG=double(rgb2gray(imgprepad));
        
        store=uint8(zeros(cell_height*scale,cell_width*scale)); %���û����ķ�ʽ�����Ƿ��ҵ�ƥ����״̬�����ڼ����Ȩϵ��
        output=cell(cell_height*scale,cell_width*scale);        %���ڴ�������ȥ��ͼƬ
        mv=zeros(cell_height+ref_pixel/windowSize*2,cell_width+ref_pixel/windowSize*2,2);%��ʼ�˶�ʸ��
        
    else
        cell_height=height/windowSize;
        cell_width=width/windowSize;
        imgpre=outputD;
        imgprepad=padarray(imgpre,[ref_pixel,ref_pixel],'symmetric','both'); 
        clear imgpre;
        imgprepadG=imgpadG;    
       
    end
    %��ȡ��ǰ֡ͼ��
    
    img=read(mov,outer_loop);
    img=img(1:height,1:width,:); 
    imgpad=padarray(img,[ref_pixel,ref_pixel],'symmetric','both');
    clear img;
    imgpadG=double(rgb2gray(imgpad));

    %д�µ�ǰͼ��     
    name0=[directory num2str(outer_loop)  ori_pic];
    imwrite(imgpad(ref_pixel+1:ref_pixel+height,ref_pixel+1:ref_pixel+width,1:3),name0);
    
    thresh=getT(imgpadG,imgprepadG,SADsize)*1.5
    %thresh=25.7;
    threshold=thresh*SADsize*SADsize;
    %��һ���� �˶�����
    tic
    mv=mv_initialize(mv);

    %�ڶ����� �˶�ʸ��ϸ��
    cell_height=cell_height*2;
    cell_width=cell_width*2;
    windowSize=windowSize/2;
    SADsize=windowSize*2;
    upleft=(SADsize-windowSize)/2;   
    downright=windowSize+upleft-1;
    ref_block=ref_pixel/windowSize;
    threshold=thresh*SADsize*SADsize;
    mv_2=mv_refine(mv);
    
   %ƥ��ʧ�ܵĵط�����ȫ����
     for k0=0:cell_height*cell_width-1
           i0=floor(k0/cell_width)+1;j0=mod(k0,cell_width)+1;
                i=i0+ref_block;j=j0+ref_block;
                flag1=(mv_2(i,j,1)==not_found);
                 if flag1
                     threshold=thresh*SADsize*SADsize;
                     curx=uint16((i-1)*windowSize+1);cury=uint16((j-1)*windowSize+1);
                     mv_2(i,j,:)=search_T(curx,cury);
                 end
     end    
      
     
    %�������� �˶�ʸ����ϸ��
    cell_height=cell_height*2;
    cell_width=cell_width*2;
    windowSize=windowSize/2;
    SADsize=windowSize*2;
    upleft=(SADsize-windowSize)/2;   
    downright=windowSize+upleft-1;
    ref_block=ref_pixel/windowSize;
    threshold=thresh*SADsize*SADsize;
    mv_3=mv_refine(mv_2);
    
    
    %���Ĳ��֣���Ȩƽ��ϵ��
    count_match=zeros(cell_height,cell_width);
    flag2=(mv_3(ref_block+1:ref_block+cell_height,ref_block+1:ref_block+cell_width,1)~=not_found);
    store=bitset(store,mod((outer_loop-1),average_level)+1,flag2); 
    for i=1:average_level
         tmp=double(bitget(store,i));
         count_match=count_match+tmp;
    end 
    count_match=imfilter(count_match,filter,'corr','symmetric','same');
    count_match(count_match<1)=1;
            
    threshold=thresh*SADsize*SADsize;

   %������ 
  for k0=0:cell_height*cell_width-1
        i0=floor(k0/cell_width)+1;j0=mod(k0,cell_width)+1;
        i=i0+ref_block;j=j0+ref_block;
        curx=(i-1)*windowSize+1;cury=(j-1)*windowSize+1;
         flag3=(mv_3(i,j,1)~=not_found);
         if flag3
             
            cur_block=imgpad(curx:curx+windowSize-1,cury:cury+windowSize-1,:);          
            mv_block=imgprepad(curx+mv_3(i,j,1):curx+mv_3(i,j,1)+windowSize-1,...
                                cury+mv_3(i,j,2):cury+mv_3(i,j,2)+windowSize-1,:);  
            output{i0,j0}=double(cur_block)./count_match(i0,j0)+...
                        double(mv_block).*(count_match(i0,j0)-1)./count_match(i0,j0);
         else
                     sum_inframe=zeros(windowSize,windowSize,3);
                    [mv_out2,ct]=search_inframe(curx,cury,thresh*windowSize*windowSize);
                    mv_out=(mv_out2-1);
                    for k=1:ct
                        sum_inframe=sum_inframe+double(imgpad(mv_out(1,k):mv_out(1,k)+windowSize-1,mv_out(2,k):mv_out(2,k)+windowSize-1,:));
                    end
           output{i0,j0}=sum_inframe./ct;
         end
  end

    clear mv_3;clear mv_2;
    outputD=uint8(cell2mat(output));
    name=[directory num2str(outer_loop) denos_pic];
    imwrite(outputD,name);
    if outer_loop~=2
        aviobj=addframe(aviobj,outputD);
    end
toc 
end
warning('on','all');
aviobj=close(aviobj);




















