 function mv_output=search_T(curx,cury)
 %全搜索，输入为要进行全搜索的块的左上角坐标值，输出为该块的运动矢量
 %该函数与search函数的不同在于进行了阈值的调整
 global not_found;
 global searchwindow;  
 global threshold;
 global upleft;
 global downright;
 global imgpadG;
 global imgprepadG;
 global SADsize;
 global windowSize;
 fun = @sumBlk;
 
 temp=threshold;
 sizeof=2*searchwindow+1;
 cur_block=imgpadG(curx-upleft:curx+downright,cury-upleft:cury+downright);
 cur_pic=repmat(cur_block,[sizeof,sizeof]);
 maybe=cell(sizeof,sizeof);
 for i=-searchwindow:searchwindow;
     for j=-searchwindow:searchwindow
         maybe{i+searchwindow+1,j+searchwindow+1}=imgprepadG...
                       (curx+i-upleft:curx+i+downright,cury+j-upleft:cury+j+downright);
     end
 end
 maybe=cell2mat(maybe);
 cur_pic=abs(cur_pic-maybe);
 clear maybe;
 sumDiff= blkproc(cur_pic,[SADsize SADsize],fun);
 mm=min(min(sumDiff));
 
 %阈值调整
 %根据当前帧周围块的噪声水平调整阈值，使其有自适应性
         sum_cur1=SADcur(curx,cury,curx,cury-windowSize);
         sum_cur2=SADcur(curx,cury,curx-windowSize,cury);
         sum_cur3=SADcur(curx,cury,curx,cury+windowSize);
         sum_cur4=SADcur(curx,cury,curx+windowSize,cury);
         
         sc_4=[sum_cur1,sum_cur2,sum_cur3,sum_cur4];
         sc=min(sc_4);
         %这个4=（SADsize/windowSize）×（SADsize/windowSize）
         sc=sc*4;
         
         threshold=min(temp,sc);
 
 
     if mm<=threshold
         [x,y]=find(sumDiff==mm);
         mv_output=[x(1)-searchwindow-1 y(1)-searchwindow-1];
     else
         mv_output=[not_found not_found];
     end
     
 end
 