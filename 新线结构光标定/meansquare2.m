function [ bk ] = meansquare2( xx)
 x=xx(1,:);
 y=xx(2,:);
 XX=[ones(1,size(xx,2));x];
 bk=( inv(XX*XX' ))*(XX*y');
end

