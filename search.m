 function mv_output=search(curx,cury)
 %ȫ����������ΪҪ����ȫ�����Ŀ�����Ͻ�����ֵ�����Ϊ�ÿ���˶�ʸ��
 global not_found;
 global searchwindow;  
 global threshold;
 global upleft;
 global downright;
 global imgpadG;
 global imgprepadG;
 global SADsize;
 fun = @sumBlk;
  
 sizeof=2*searchwindow+1;
 %��ǰ��
 cur_block=imgpadG(curx-upleft:curx+downright,cury-upleft:cury+downright);
 cur_pic=repmat(cur_block,[sizeof,sizeof]);
 clear cur_block;
 %������Χ�ڿ��ܵ�ƥ���
 maybe=cell(sizeof,sizeof);
 for i=-searchwindow:1:searchwindow;
     for j=-searchwindow:1:searchwindow
         maybe{i+searchwindow+1,j+searchwindow+1}=imgprepadG...
                       (curx-upleft+i:curx+i+downright,cury+j-upleft:cury+j+downright);
     end
 end
 maybe=cell2mat(maybe);
 cur_pic=abs(cur_pic-maybe);
 clear maybe;
 sumDiff= blkproc(cur_pic,[SADsize SADsize],fun);
 clear cur_pic;
 %������С��SAD�Ͷ�Ӧ��ʸ��
 mm=min(min(sumDiff));
     if mm<=threshold
         [x,y]=find(sumDiff==mm);
         mv_output=[x(1)-searchwindow-1 y(1)-searchwindow-1];
     else
         mv_output=[not_found not_found];
     end
     
 end
 