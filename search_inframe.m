function [mv_in,ct]=search_inframe(x,y,thr)
global windowSize;
global average_level;
global imgpadG;

mv_in=[x;y];
range=16;
sumWin=zeros((range*2+1)*(range*2+1),1);
ct=0;
 for i=-range:range
     for j=-range:range
         ii=x+i;
         jj=y+j;
         ct=ct+1;
            sumWin(ct,1)=sum(sum(abs(imgpadG(x:x+windowSize-1,y:y+windowSize-1)...
                                                   -imgpadG(ii:ii+windowSize-1,jj:jj+windowSize-1))));
     end
 end
 [temp,q]=sort(sumWin,'ascend');

for k=1:average_level
    if temp(k,1)>thr
        ct=k-1;
        break;
    else
        ct=k;
        if mod(q(k),(range*2+1))==0
           mv_in(2,k)=y+range;
           mv_in(1,k)=floor(q(k)/(range*2+1)+x-range-1);
        else
           mv_in(2,k)=mod(q(k),(range*2+1))+y-range-1;
           mv_in(1,k)=floor(q(k)/(range*2+1)+x-range);
        end
    end
end

        
 
end
     