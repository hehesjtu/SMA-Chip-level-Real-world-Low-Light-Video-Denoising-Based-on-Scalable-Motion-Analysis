function [mv_f_out]=mv_refine(mv_f)
%矢量细化，输入为上一层的矢量场，输出为细化的矢量场
%算法详见说明文档里矢量细化部分
  global ref_block;
  global cell_width;
  global cell_height;
  global  const1;
  global  const2;
  global windowSize;
  global ref_pixel;
  global upleft;
  global not_found;
  global threshold;
 
  mv_f_out=zeros(cell_height+ref_block*2,cell_width+ref_block*2,2);
  const1=ref_pixel-upleft;
  const2=ref_block/2;
 %one 
  sumD(:,:,1)=compare_one(mv_f,0,0,0,0);
  sumD(:,:,2)=compare_one(mv_f,0,0,0,1);
  sumD(:,:,3)=compare_one(mv_f,0,0,1,0);
  sumD(:,:,4)=compare_one(mv_f,0,0,1,1);
  
  min_sum=min(sumD,[],3);
  Flag0(:,:,2)=(min_sum>threshold);Flag0(:,:,1)=Flag0(:,:,2);
  flg1(:,:,2)=(~(sumD(:,:,1)-min_sum))&(~Flag0(:,:,2));      flg1(:,:,1)=flg1(:,:,2);    Flag=Flag0(:,:,2)+flg1(:,:,1);
  flg2(:,:,2)=(~(sumD(:,:,2)-min_sum))&(~Flag);       flg2(:,:,1)=flg2(:,:,2);    Flag=Flag+flg2(:,:,2);
  flg3(:,:,2)=(~(sumD(:,:,3)-min_sum))&(~Flag);       flg3(:,:,1)=flg3(:,:,2);     Flag=Flag+flg3(:,:,2);
  flg4(:,:,2)=(~(sumD(:,:,4)-min_sum))&(~Flag);       flg4(:,:,1)=flg4(:,:,2);     Flag=Flag+flg4(:,:,2);
  mv_f_out(ref_block+1:2:end-ref_block,ref_block+1:2:end-ref_block,:)=...
                            flg1.*mv_f(const2:const2+cell_height/2-1,           const2:const2+cell_width/2-1,:)+...
                            flg2.*mv_f(const2:const2+cell_height/2-1,           const2+1:const2+1+cell_width/2-1,:)+...
                            flg3.*mv_f(const2+1:const2+1+cell_height/2-1,       const2:const2+cell_width/2-1,:)+...
                            flg4.*mv_f(const2+1:const2+1+cell_height/2-1,       const2+1:const2+1+cell_width/2-1,:)+...
                            Flag0*not_found;
                            
                        
  %two                     
  sumD(:,:,1)=compare_one(mv_f,0,windowSize,0,1);
  sumD(:,:,2)=compare_one(mv_f,0,windowSize,0,2);
  sumD(:,:,3)=compare_one(mv_f,0,windowSize,1,1);
  sumD(:,:,4)=compare_one(mv_f,0,windowSize,1,2);
  
  min_sum=min(sumD,[],3);
Flag0(:,:,2)=(min_sum>threshold);Flag0(:,:,1)=Flag0(:,:,2);
  flg1(:,:,2)=(~(sumD(:,:,1)-min_sum))&(~Flag0(:,:,2));      flg1(:,:,1)=flg1(:,:,2);    Flag=Flag0(:,:,2)+flg1(:,:,1);
  flg2(:,:,2)=(~(sumD(:,:,2)-min_sum))&(~Flag);       flg2(:,:,1)=flg2(:,:,2);    Flag=Flag+flg2(:,:,2);
  flg3(:,:,2)=(~(sumD(:,:,3)-min_sum))&(~Flag);       flg3(:,:,1)=flg3(:,:,2);     Flag=Flag+flg3(:,:,2);
  flg4(:,:,2)=(~(sumD(:,:,4)-min_sum))&(~Flag);       flg4(:,:,1)=flg4(:,:,2);     Flag=Flag+flg4(:,:,2);
  mv_f_out(ref_block+1:2:end-ref_block,ref_block+2:2:end-ref_block,:)=...
                            flg1.*mv_f(const2:const2+cell_height/2-1,      const2+1:const2+1+cell_width/2-1,:)+...
                            flg2.*mv_f(const2:const2+cell_height/2-1,      const2+2:const2+2+cell_width/2-1,:)+...
                            flg3.*mv_f(const2+1:const2+1+cell_height/2-1,  const2+1:const2+1+cell_width/2-1,:)+...
                            flg4.*mv_f(const2+1:const2+1+cell_height/2-1,  const2+2:const2+2+cell_width/2-1,:)+...
                            Flag0*not_found;
  
 %three                       
  sumD(:,:,1)=compare_one(mv_f,windowSize,0,1,0);
  sumD(:,:,2)=compare_one(mv_f,windowSize,0,1,1);
  sumD(:,:,3)=compare_one(mv_f,windowSize,0,2,0);
  sumD(:,:,4)=compare_one(mv_f,windowSize,0,2,1);
  
  min_sum=min(sumD,[],3);
 Flag0(:,:,2)=(min_sum>threshold);Flag0(:,:,1)=Flag0(:,:,2);
  flg1(:,:,2)=(~(sumD(:,:,1)-min_sum))&(~Flag0(:,:,2));      flg1(:,:,1)=flg1(:,:,2);    Flag=Flag0(:,:,2)+flg1(:,:,1);
  flg2(:,:,2)=(~(sumD(:,:,2)-min_sum))&(~Flag);       flg2(:,:,1)=flg2(:,:,2);    Flag=Flag+flg2(:,:,2);
  flg3(:,:,2)=(~(sumD(:,:,3)-min_sum))&(~Flag);       flg3(:,:,1)=flg3(:,:,2);     Flag=Flag+flg3(:,:,2);
  flg4(:,:,2)=(~(sumD(:,:,4)-min_sum))&(~Flag);       flg4(:,:,1)=flg4(:,:,2);     Flag=Flag+flg4(:,:,2);
  mv_f_out(ref_block+2:2:end-ref_block,ref_block+1:2:end-ref_block,:)=...
                            flg1.*mv_f(const2+1:const2+1+cell_height/2-1,     const2:const2+cell_width/2-1,:)+...
                            flg2.*mv_f(const2+1:const2+1+cell_height/2-1,     const2+1:const2+1+cell_width/2-1,:)+...
                            flg3.*mv_f(const2+2:const2+2+cell_height/2-1,     const2:const2+cell_width/2-1,:)+...
                            flg4.*mv_f(const2+2:const2+2+cell_height/2-1,     const2+1:const2+1+cell_width/2-1,:)+...
                            Flag0*not_found;
  
 %four                      
  sumD(:,:,1)=compare_one(mv_f,windowSize,windowSize,1,1);
  sumD(:,:,2)=compare_one(mv_f,windowSize,windowSize,1,2);
  sumD(:,:,3)=compare_one(mv_f,windowSize,windowSize,2,1);
  sumD(:,:,4)=compare_one(mv_f,windowSize,windowSize,2,2);
  
  min_sum=min(sumD,[],3);
 Flag0(:,:,2)=(min_sum>threshold);Flag0(:,:,1)=Flag0(:,:,2);
  flg1(:,:,2)=(~(sumD(:,:,1)-min_sum))&(~Flag0(:,:,2));      flg1(:,:,1)=flg1(:,:,2);    Flag=Flag0(:,:,2)+flg1(:,:,1);
  flg2(:,:,2)=(~(sumD(:,:,2)-min_sum))&(~Flag);       flg2(:,:,1)=flg2(:,:,2);    Flag=Flag+flg2(:,:,2);
  flg3(:,:,2)=(~(sumD(:,:,3)-min_sum))&(~Flag);       flg3(:,:,1)=flg3(:,:,2);     Flag=Flag+flg3(:,:,2);
  flg4(:,:,2)=(~(sumD(:,:,4)-min_sum))&(~Flag);       flg4(:,:,1)=flg4(:,:,2);     Flag=Flag+flg4(:,:,2);
  mv_f_out(ref_block+2:2:end-ref_block,ref_block+2:2:end-ref_block,:)=...
                            flg1.*mv_f(const2+1:const2+1+cell_height/2-1,     const2+1:const2+1+cell_width/2-1,:)+...
                            flg2.*mv_f(const2+1:const2+1+cell_height/2-1,     const2+2:const2+2+cell_width/2-1,:)+...
                            flg3.*mv_f(const2+2:const2+2+cell_height/2-1,     const2+1:const2+1+cell_width/2-1,:)+...
                            flg4.*mv_f(const2+2:const2+2+cell_height/2-1,     const2+2:const2+2+cell_width/2-1,:)+...
                            Flag0*not_found;
                        
end


