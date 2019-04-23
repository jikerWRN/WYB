function [x,y,w,h]=GetRegion(BW)
% 得到表盘内圆范围
% 以上下表姐检测为基准
% 估计得到左右边界
% 返回：做上角顶点坐标，宽，高：x,y,w,h

%%% Project analysis
RATIO=10;
[row,col]=size(BW);
center_x=floor(col/2);
center_y=floor(row/2);
height_half=floor(row/RATIO/2);
width_half=floor(col/RATIO/2);

project_x=sum(BW(:,center_x-width_half:center_x+width_half,:),2);
[~,locs_y]=findpeaks(project_x,'sortstr','descend','npeaks',2,'minpeakdistance',width_half);

c_y=floor(mean(locs_y));
% locs_x=sort(locs_x);
locs_y=sort(locs_y);

h=locs_y(2)-locs_y(1);
center_y=floor(mean(locs_y));
% center_x=floor(size(I,2)/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
BW=imopen(BW,strel('disk',10));
BW1=ones(size(BW));
BW1(:,2:end)=BW(:,1:end-1);
BW2=BW-BW1;
BW3=BW2;
BW3(BW3<0)=0;
[rr1,cc1]=LongestCurve(BW3);
%%
BW3=-BW2;
BW3(BW3<0)=0;
[rr2,cc2]=LongestCurve(BW3);

%%
rc1=sortrows([rr1,cc1]);
rc2=sortrows([rr2,cc2]);

begin_r1=1;
begin_r2=1;
if rc1(begin_r1,1)>rc2(begin_r2,1)
    begin_r2=find(rc2(:,1)==rc1(1,1));
else
    begin_r1=find(rc1(:,1)==rc2(1,1));
end

end_r1=size(rc1,1);
end_r2=size(rc2,1);
if rc1(end_r1,1)<rc2(end_r2,1)
    end_r2=find(rc2(:,1)==rc1(end_r1,1),1,'first');
else
    end_r1=find(rc1(:,1)==rc2(end_r2,1),1,'first');
end

mid_x=floor((rc1(begin_r1:end_r1,2)+rc2(begin_r2:end_r2,2))/2);
center_x=floor(mean(mid_x));
%%

h=floor(h*0.8);
w=h;
x=floor(center_x-w/2);
y=floor(center_y-h/2);

return
 
function [rr,cc]=LongestCurve(BW3)
[L, num] = bwlabel(BW3);
% 统计各标记区域的像素数量
max_area=0;max_idx=0;
for area=1:num
    idx=find(L==area);
    if numel(idx)>max_area
        max_area=numel(idx);
        max_idx=area;
    end
end
[rr,cc]=find(L==max_idx);
