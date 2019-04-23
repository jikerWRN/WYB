close all
clear
path1=pwd;
path_img=[path1,'\image\'];
% mydir = 'C:\Users\user\Desktop\data\';  
filelist=dir([path_img,'*.bmp']);
[hhf,llf]=size(filelist);
for i=1:hhf
    filename1=filelist(i).name
    I = imreadGrayDouble0to1([path_img,filename1]);
   
    [A,B,R,p,dx,dy]=GearRec(I);
%     ytt=B+p*R;
    ratio=(R+20)/sqrt(R^2+(p(1)*R)^2);
%     ytt=B+p(1)*R*ratio;

    theta1=0:0.02:2*pi;
    x1=A+R*cos(theta1);
    y1=B+R*sin(theta1);
    
    imshow(I,[]);title(filename1)
    hold on
%     plot(x1,y1,'r--','linewidth',1);
    plot(A,B,'r+','linewidth',2)
    
    plot([A,A+R*ratio*sign(dx)],[B,B+abs(p(1)*R*ratio)*sign(dy)],'g-','linewidth',5)
    plot(A+R*ratio*sign(dx),B+abs(p(1)*R*ratio)*sign(dy),'ro','linewidth',2)
    hold off
%     I1=getiRmage(gcf); % 获取坐标系中的图像文件数据
    drawnow;
    savefile=[path1,'\result\',filename1];
    [I1,map]=getframe(gcf);
    imwrite(I1,savefile,'bmp')%保存图像为文件
%     saveas(gcf,savefile,'bmp');
end