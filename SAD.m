function sum_dif=SAD(curx,cury,prex,prey)
 global upleft;
 global downright;
 global imgpadG;
 global imgprepadG;
 sum_dif=sum(sum(abs(imgpadG(curx-upleft:curx+downright,cury-upleft:cury+downright)-...
                    imgprepadG(prex-upleft:prex+downright,prey-upleft:prey+downright))));
end