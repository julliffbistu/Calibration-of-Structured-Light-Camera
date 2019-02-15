function [ x,y ] = interSet(bk1,bk2 )
b1= bk1(1);
b2=bk2(1);
k1=bk1(2);
k2=bk2(2);
x=(b1-b2)/(k2-k1);
y=x*k1+b1;
end

