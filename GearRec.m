function [A,B,R,p,dx,dy]=GearRec(I)

I1=adapthisteq(I,'NumTiles',[16 16],'ClipLimit',0.007);
BW=im2bw(I1); %将图像转换为二值图像

[A,B,R]=GetCircle(BW);

theta1=0:0.02:2*pi;
x1=A+(R-10)*cos(theta1);
y1=B+(R-10)*sin(theta1);

BW_roi=roipoly(BW,x1,y1).*BW;
BW_open=imopen(BW_roi,strel('disk',10));
BW_close=imclose(BW_roi,strel('disk',10));
% subplot(121),imshow(I),title([filename,',gray'])
% %     imshow(I),title(filename1);
% hold on
% %     theta1=0:0.02:2*pi;
% %     x3=A+R*cos(theta1);
% %     y3=B+R*sin(theta1);
% plot(x3,y3,'g--','linewidth',1);
% hold off
%
% subplot(122),imshow(BW_roi),title([filename,',original'])
% %     imshow(I),title(filename1);
% hold on
% theta1=0:0.02:2*pi;
% x1=A+R*cos(theta1);
% y1=B+R*sin(theta1);
% plot(x3,y3,'g--','linewidth',1);
% hold off


[L, num] = bwlabel(BW_close);
% 统计各标记区域的像素数量
max3_area=zeros(3,2);
for ind_area=1:num
    idx=find(L==ind_area);
    if numel(idx)>min(max3_area(1,1))
        max3_area(1,1)=numel(idx);
        max3_area(1,2)=ind_area;
        max3_area=sortrows(max3_area);
    end
end
% 只保留最大3者，其他区域变为背景
% for ii=1:3
ii=3;
max_idx=max3_area(ii,2);
idx=find(L~=max_idx);
L(idx)=0;

[rr,cc]=find(L==max_idx);
%% line fiting
% p=polyfit(cc,rr,1);
% ytt=polyval(p,[A,A+R]);
% ytt=B+p(1)*R;
% ratio=(R+20)/sqrt(R^2+(p(1)*R)^2);
% ytt=B+p(1)*R*ratio;
% theta1=0:0.02:2*pi;
% x1=A+R*cos(theta1);
% y1=B+R*sin(theta1);
%%
%% minimum Recrangle
[rectx,recty,area,perimeter] = minboundrect(cc,rr);
d12=sqrt((rectx(2)-rectx(1))^2+((recty(2)-recty(1))^2));
d23=sqrt((rectx(3)-rectx(2))^2+((recty(3)-recty(2))^2));
if d12>d23 %% 注意奇异情况
%     p=(recty(1)-recty(2))/(rectx(1)-rectx(2));
    dy=recty(2)-recty(1);
    dx=rectx(2)-rectx(1);
    ratio_h_w=d12/d23;
    d10=sqrt((rectx(1)-A)^2+(recty(1)-B)^2);
    d20=sqrt((rectx(2)-A)^2+(recty(2)-B)^2);
    if d20<d10
        dx=-dx;
        dy=-dy;
    end
    p=dy/dx;
else
%     p=(recty(3)-recty(2))/(rectx(3)-rectx(2));
    dy=recty(3)-recty(2);
    dx=rectx(3)-rectx(2);
    ratio_h_w=d23/d12;
    d20=sqrt((rectx(2)-A)^2+(recty(2)-B)^2);
    d30=sqrt((rectx(3)-A)^2+(recty(3)-B)^2);
    if d30<d20
        dx=-dx;
        dy=-dy;
    end
    p=dy/dx;
end

%% determin the orient
% xr=mean(rectx(1:4));
% yr=mean(recty(1:4));
% if ratio_h_w>10
%     dx=-dx;
%     dy=-dy;
% end
% sign(dx),sign(dy)
% ytt1=B+p(1)*R;
% ratio=(R+20)/sqrt(R^2+(p(1)*R)^2);
% ytt=B+p(1)*R*ratio*sign(dy);

%% display
% subplot(121),imshow(I,[]);title([filename,',',num2str(sign(dx)),',',num2str(sign(dy))])
% hold on
% plot(x1,y1,'r--','linewidth',1);
% plot(A,B,'r+')
% 
% plot([xr,xr+perimeter/2*sign(dx)],[yr,yr+abs(p*perimeter/2)*sign(dy)],'r-','linewidth',2)
% % plot(xr,yr,'g+')
if ratio_h_w>7
    dx=-dx;
    dy=-dy;
end
% plot([A,A+R*ratio*sign(dx)],[B,B+abs(p(1)*R*ratio)*sign(dy)],'g-','linewidth',5)
% 
% plot(rectx,recty,'m--','linewidth',1)
% plot(rectx(1),recty(1),'r+','linewidth',2)
% plot(rectx(2),recty(2),'g+','linewidth',2)
% plot(rectx(3),recty(3),'b+','linewidth',2)
% hold off

% subplot(122),imshow(L),title('L')
% hold on
% plot(x1,y1,'r--','linewidth',1);
% plot(A,B,'r+')
% plot(xr,yr,'g+')
% plot([A,A+R*ratio],[B,ytt1],'g-','linewidth',5)
% plot(rectx,recty,'m--','linewidth',1)
% hold off