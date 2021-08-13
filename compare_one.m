 function [sumDiff]=compare_one(mv_f,pointx,pointy,blkx,blky)
 %该函数在矢量细化函数中调用
  global imgprepadG;
  global imgpadG;
  global width;
  global height;
  global ref_pixel; 
  global SADsize;
  
 
  global cell_width;
  global cell_height;
  global  const1;
  global  const2;
  fun = @sumBlk;
  
  start_pointX=const1+pointx;
  start_pointY=const1+pointy;
  
  minuend=imgpadG(start_pointX+1:start_pointX+height,start_pointY+1:start_pointY+width); 
  axis_x=repmat([start_pointX+1:start_pointX+height]',1,width);
  axis_y=repmat(start_pointY+1:start_pointY+width,height,1); 
  
  start_blkX=const2+blkx;
  start_blkY=const2+blky;
  
  of_mv=mv_f(start_blkX:start_blkX+cell_height/2-1,start_blkY:start_blkY+cell_width/2-1,:);
  
  for i=1:SADsize
      for j=1:SADsize
          axis_x(i:SADsize:end,j:SADsize:end)=axis_x(i:SADsize:end,j:SADsize:end)+of_mv(:,:,1);
          axis_y(i:SADsize:end,j:SADsize:end)=axis_y(i:SADsize:end,j:SADsize:end)+of_mv(:,:,2);
      end
  end
  
  axis_y=(axis_y-1)*(height+ref_pixel*2);
  axis_x=uint32(axis_x+axis_y);
  subtracter_1=imgprepadG(axis_x);
  diffL=abs(minuend-subtracter_1);
  sumDiff= blkproc(diffL,[SADsize SADsize],fun);
 end