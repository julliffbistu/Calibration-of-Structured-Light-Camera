function [ bkrefine ] = meansquare2Refine( xx2,bk,maxErr)
xx=xx2;
count=0;
A=bk(2);
C=bk(1);
B=-1;
maxdist=0;
for i=1:size(xx2,2)
    x0=xx2(1,i );
    y0=xx2(2,i );
    dist=Point2lindist (A,B,C,x0,y0) ;
    if dist<maxErr
        count=count+1;
        xx(:,count)=xx2(:,i);
        
    elseif dist>maxdist
        maxdist=dist;
        
    end
    
end
maxdist
count
xx=xx(:,1:count);
x=xx(1,:);
y=xx(2,:);
XX=[ones(1,size(xx,2));x];
bkrefine=( inv(XX*XX' ))*(XX*y');
end
function dist=Point2lindist (A,B,C,x,y);
dist=(abs(A*x+B*y+C))/(sqrt(A*A+B*B));
end

