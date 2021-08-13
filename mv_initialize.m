function    mv_f=mv_initialize(mv_f)
%运动矢量初始化，输入为运动矢量场，输出为运动矢量场
global cell_height;
global cell_width;
global windowSize;
global threshold;
global ref_block;

 for k=0:cell_height*cell_width-1
         i0=floor(k/cell_width)+1;j0=mod(k,cell_width)+1;
         i=i0+ref_block;j=j0+ref_block;
         curx=(i-1)*windowSize+1; cury=(j-1)*windowSize+1;
         %Y探测器模型
         sumDiff=SAD(curx,cury,curx,cury);
         sumL=SAD(curx,cury,curx+mv_f(i-1,j-1,1),cury+mv_f(i-1,j-1,2));
         sumR=SAD(curx,cury,curx+mv_f(i-1,j+1,1),cury+mv_f(i-1,j+1,2));
         sumD=SAD(curx,cury,curx+mv_f(i+2,j,1),cury+mv_f(i+2,j,2));
         %其他候选矢量，可选
         sum5=SAD(curx,cury,curx+mv_f(i,j-1,1),cury+mv_f(i,j-1,2));
         sum6=SAD(curx,cury,curx+mv_f(i,j+1,1),cury+mv_f(i,j+1,2));
         sum7=SAD(curx,cury,curx+mv_f(i+1,j-1,1),cury+mv_f(i+1,j-1,2));
         sum8=SAD(curx,cury,curx+mv_f(i+1,j+1,1),cury+mv_f(i+1,j+1,2));
         sum9=SAD(curx,cury,curx+mv_f(i-1,j,1),cury+mv_f(i-1,j,2));
         sum10=SAD(curx,cury,curx+mv_f(i+1,j,1),cury+mv_f(i+1,j,2));
         
         
         ss=[sumL,sumR,sumD,sumDiff,sum5,sum6,sum7,sum8,sum9,sum10];
         [min_sum,pos]=min(ss);
          if  min_sum<threshold    
            switch pos(1)
               case 1
                    mv_f(i,j,:)=mv_f(i-1,j-1,:);
                case 2
                    mv_f(i,j,:)=mv_f(i-1,j+1,:);  
                case 3
                    mv_f(i,j,:)=mv_f(i+2,j,:);
                case 4
                    mv_f(i,j,:)=[0 0]; 
                case 5
                    mv_f(i,j,:)=mv_f(i,j-1,:);
                case 6
                    mv_f(i,j,:)=mv_f(i,j+1,:);
                case 7
                    mv_f(i,j,:)=mv_f(i+1,j-1,:);             
                case 8
                    mv_f(i,j,:)=mv_f(i+1,j+1,:);
                case 9
                    mv_f(i,j,:)=mv_f(i-1,j,:);
                otherwise
                    mv_f(i,j,:)=mv_f(i+1,j,:);
            end
                
          else
              %未匹配情况进行全搜索
              mv_f(i,j,:)=search(curx,cury);
          end
 end
end
         
