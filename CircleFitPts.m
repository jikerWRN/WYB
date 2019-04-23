function [A,B,R]=CircleFitPts(pts)
 
    N = size(pts,1);
    x=pts(:,1);
    y=pts(:,2);

    x1 = sum(x);
    x2 = sum(x.*x);
    x3 = sum(x.*x.* x);
    y1 = sum(y);
    y2 = sum(y.* y);
    y3 = sum(y.* y.* y);
    x1y1 = sum(x.* y);
    x1y2 = sum(x.* y.* y);
    x2y1 = sum(x.* x.* y);



    C = N * x2 - x1 * x1;
    D = N * x1y1 - x1 .* y1;
    E = N * x3 + N * x1y2 - (x2 + y2) .* x1;
    G = N * y2 - y1 .* y1;
    H = N * x2y1 + N * y3 - (x2 + y2) .* y1;
    a = (H * D - E * G) / (C * G - D * D);
    b = (H * C - E * D) / (D * D - G * C);
    c = -(a * x1 + b * y1 + x2 + y2) / N;
    A = a / (-2);
    B = b / (-2);
    R =sqrt(a * a + b * b - 4 * c) / 2;

    