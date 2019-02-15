function [ Xw,Yw ] = CrossRatio( x1,x2,x3,X1,X2,X3,xc )
     Yw=X1(2);%平行坐标轴的情况下。如不是平行的，可以知道y=kx+b
if xc(2)==x2(2)
    Xw=X2(1);
    return
elseif xc(2)<x2(2)
    ac=PointDist(x1,x2);
    ad=PointDist(x1,x3);
    db=PointDist(xc,x3);
    cb=PointDist(xc,x2);
    r=ac*db/(cb*ad);
    AC=PointDist(X1,X2);
    AD=PointDist(X1,X3);
    const=r/AC*AD;
    XC=X2(1);
    XD=X3(1);
    XA=X1(1);
    a=1-const^2;
    b=-2*(XD-const^2*XC);
    c=XD^2-const^2*XC^2;
    XL=(-b-sqrt(b*b-4*a*c))/2/a;
    XH=(-b+sqrt(b*b-4*a*c))/2/a;
    if (XL-XA)*(XL-XC)<0
        Xw=XL;
    else
        Xw=XH;
    end
else
    ac=PointDist(x1,xc);
    ad=PointDist(x1,x3);
    db=PointDist(x2,x3);
    cb=PointDist(xc,x2);
    r=ac*db/(cb*ad);
    AD=PointDist(X1,X3);
    DB=PointDist(X3,X2);
    const=r*AD/DB;
    XB=X2(1);
    XD=X3(1);
    XA=X1(1);
    a=1-const^2;
    b=-2*(XA-const^2*XB);
    c=XA^2-const^2*XB^2;
    XL=(-b-sqrt(b*b-4*a*c))/2/a;
    XH=(-b+sqrt(b*b-4*a*c))/2/a;
    if (XL-XB)*(XL-XD)<0
        Xw=XL;
    else
        Xw=XH;
    end
end
end
function dist=PointDist(x1,x2)
dist=sqrt((x1(1)-x2(1))*(x1(1)-x2(1))+(x1(2)-x2(2))*(x1(2)-x2(2)));
end

