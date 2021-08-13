 function mv_output=search(curx,cury)
 %全搜索，输入为要进行全搜索的块的左上角坐标值，输出为该块的运动矢量
 global not_found;
 global searchwindow;  
 global threshold;
 global upleft;
 global downright;
 global imgpadG;
 global imgprepadG;
 global SADsize;
 fun = @sumBlk;
  
 sizeof=searchwindow+1;
 %当前块
 cur_block=imgpadG(curx-upleft:curx+downright,cury-upleft:cury+downright);
 cur_pic=repmat(cur_block,[sizeof,sizeof]);
 %搜索范围内可能的匹配块
 maybe=cell(sizeof,sizeof);
 for i=-searchwindow:1:0
     for j=-searchwindow:1:0
         maybe{i+searchwindow+1,j+searchwindow+1}=imgprepadG...
                       (curx-upleft+i:curx+i+downright,cury+j-upleft:cury+j+downright);
     end
 end
 maybe=cell2mat(maybe);
 cur_pic=abs(cur_pic-maybe);
 clear maybe;
 sumDiff1= blkproc(cur_pic,[SADsize SADsize],fun);
 clear cur_pic;
 %查找最小的SAD和对应的矢量
 mm1=min(min(sumDiff1));
 [x1,y1]=find(sumDiff1==mm1);  
     
 sizeof=searchwindow;
 %当前块
 cur_block=imgpadG(curx-upleft:curx+downright,cury-upleft:cury+downright);
 cur_pic=repmat(cur_block,[sizeof,sizeof]);
 %搜索范围内可能的匹配块
 maybe=cell(sizeof,sizeof);
 for i=1:1:searchwindow;
     for j=1:1:searchwindow
         maybe{i+searchwindow+1,j+searchwindow+1}=imgprepadG...
                       (curx-upleft+i:curx+i+downright,cury+j-upleft:cury+j+downright);
     end
 end
 maybe=cell2mat(maybe);
 cur_pic=abs(cur_pic-maybe);
 clear maybe;
 sumDiff2= blkproc(cur_pic,[SADsize SADsize],fun);
 clear cur_pic;
 %查找最小的SAD和对应的矢量
 mm2=min(min(sumDiff2));
 [x2,y2]=find(sumDiff2==mm2);
 mm=min(mm1,mm2);
     if mm<=threshold
         if mm==mm1
            mv_output=[x1(1)-searchwindow-1 y1(1)-searchwindow-1];
         else
             mv_output=[x2(1)-searchwindow-1 y2(1)-searchwindow-1];
         end
     else
         mv_output=[not_found not_found];
     end
     
     
     
     
 end
 