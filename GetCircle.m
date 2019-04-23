function [A,B,R]=GetCircle(BW)
% close all
% clear
% path1=pwd;
% path_img=[path1,'\image\'];
% 
% cd(path_img)
% % I =imread([path_img,'gear4.bmp']);
% [filename,pathname]=uigetfile({'*.bmp';'*.jpg';'*.png';'*.tiff';'*.*'},'选择图像文件');
% cd(path1)
% %%%% 试图移动圆心到准确位置
% 
% I =imread([pathname,filename]);
% if ndims(I)==3
%     I=rgb2gray(I);
% end
% III=I;
% I=double(I/max(I(:)));

[M,N]=size(BW);

%%% auto-threshold
% I1=adapthisteq(I,'NumTiles',[16 16],'ClipLimit',0.007);
% BW=im2bw(I1);

[x,y,w,h]=GetRegion(BW);
c_x=x+w/2;
c_y=y+h/2;

max_x=floor(min([c_x+w/2*1.4,N]));
max_y=floor(min([c_y+w/2*1.4,M]));
min_x=floor(max([c_x-w/2*1.4,1]));
min_y=floor(max([c_y-w/2*1.4,1]));

%% 右下方圆弧
theta1=0:0.02:2*pi/4;
x1=floor(c_x+w/2*cos(theta1));
y1=floor(c_y+w/2*sin(theta1));
% imshow(I),title(filename),hold on
% plot(x1,y1,'r--','linewidth',1);


EdgePts=[];

for i=1:length(x1)
    xi=x1(i);
    yi=y1(i);
    x_pts=xi+find(BW(yi,xi:max_x)>0,1,'first');
    if ~isempty(x_pts)
        EdgePts=[EdgePts;x_pts,yi];
    end
    y_pts=yi+find(BW(yi:max_y,xi)>0,1,'first');
    if ~isempty(y_pts)
        EdgePts=[EdgePts;xi,y_pts];
    end
end
% plot(EdgePts(:,1),EdgePts(:,2),'r.','linewidth',1);
%%
%% 左下方圆弧
theta1=2*pi/4:0.02:2*pi/2;
x1=floor(c_x+w/2*cos(theta1));
y1=floor(c_y+w/2*sin(theta1));
% imshow(I),title(filename),hold on
% plot(x1,y1,'r--','linewidth',1);

for i=1:length(x1)
    xi=x1(i);
    yi=y1(i);
    x_pts=xi-find(BW(yi,xi:-1:min_x)>0,1,'first');
    if ~isempty(x_pts)
        EdgePts=[EdgePts;x_pts,yi];
    end
    y_pts=yi+find(BW(yi:max_y,xi)>0,1,'first');
    if ~isempty(y_pts)
        EdgePts=[EdgePts;xi,y_pts];
    end
end
%%
%% 左上方圆弧
theta1=2*pi/4*2:0.02:2*pi/4*3;
x1=floor(c_x+w/2*cos(theta1));
y1=floor(c_y+w/2*sin(theta1));
% imshow(I),title(filename),hold on
% plot(x1,y1,'r--','linewidth',1);

for i=1:length(x1)
    xi=x1(i);
    yi=y1(i);
    x_pts=xi-find(BW(yi,xi:-1:min_x)>0,1,'first');
    if ~isempty(x_pts)
        EdgePts=[EdgePts;x_pts,yi];
    end
    y_pts=yi-find(BW(yi:-1:min_y,xi)>0,1,'first');
    if ~isempty(y_pts)
        EdgePts=[EdgePts;xi,y_pts];
    end
end
%%
%% 右上方圆弧
theta1=2*pi/4*3:0.02:2*pi/4*4;
x1=floor(c_x+w/2*cos(theta1));
y1=floor(c_y+w/2*sin(theta1));
% imshow(I),title(filename),hold on
% plot(x1,y1,'r--','linewidth',1);

for i=1:length(x1)
    xi=x1(i);
    yi=y1(i);
    x_pts=xi+find(BW(yi,xi:max_x)>0,1,'first');
    if ~isempty(x_pts)
        EdgePts=[EdgePts;x_pts,yi];
    end
    y_pts=yi-find(BW(yi:-1:min_y,xi)>0,1,'first');
    if ~isempty(y_pts)
        EdgePts=[EdgePts;xi,y_pts];
    end
end

% plot(EdgePts(:,1),EdgePts(:,2),'r.','linewidth',1);
%%
[A,B,R]=CircleFitPts(EdgePts);
[A,B,R]=CircleFit(EdgePts,A,B,R);

% theta1=0:0.02:2*pi;
% x3=A+R*cos(theta1);
% y3=B+R*sin(theta1);
% plot(x3,y3,'g--','linewidth',1);
   

