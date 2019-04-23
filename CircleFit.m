function [A,B,R]=CircleFit(pts,A,B,R)
%     #  每次去掉一个异常点，再调用CircleFitPts，直到全部满足条件

    N = size(pts,1);
   
    N1=N;
    remove_flag=1;

    while  N1>N/2 && remove_flag
        N1=size(pts,1);
        x=pts(:,1);
        y=pts(:,2);

        deltaR=sqrt(abs((x-A).^2+(y-B).^2-R*R));
        avg_dR=sum(deltaR)/N1;
        std_dR=std(deltaR);

        dR1 = abs(deltaR - avg_dR);
        
        [max_dR,max_ind] = max(dR1);
        if max_dR>std_dR
           pts(max_ind,:)=[];           
            [A, B, R] = CircleFitPts(pts);
            N1=size(pts,1);
        else
            remove_flag=0;
        end
    end
   