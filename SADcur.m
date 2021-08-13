function sum_dif=SADcur(curx,cury,prex,prey)
 global imgpadG;
 global windowSize;
 
 sum_dif=sum(sum(abs(imgpadG(curx:curx+windowSize-1,cury:cury+windowSize-1)-...
                    imgpadG(prex:prex+windowSize-1,prey:prey+windowSize-1))));
end