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
  
 sizeof=searchwindow+1;
 %��ǰ��
 cur_block=imgpadG(curx-upleft:curx+downright,cury-upleft:cury+downright);
 cur_pic=repmat(cur_block,[sizeof,sizeof]);
 %������Χ�ڿ��ܵ�ƥ���
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
 %������С��SAD�Ͷ�Ӧ��ʸ��
 mm1=min(min(sumDiff1));
 [x1,y1]=find(sumDiff1==mm1);  
     
 sizeof=searchwindow;
 %��ǰ��
 cur_block=imgpadG(curx-upleft:curx+downright,cury-upleft:cury+downright);
 cur_pic=repmat(cur_block,[sizeof,sizeof]);
 %������Χ�ڿ��ܵ�ƥ���
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
 %������С��SAD�Ͷ�Ӧ��ʸ��
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
 