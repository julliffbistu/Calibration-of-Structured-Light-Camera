function [ alfa ] = MeanSquare3( Xcross )
 X=Xcross(:,1);
 Y=Xcross(:,2);
 Z=Xcross(:,3);
 XX=[ones( size(X,1),1) X Y];
 alfa=( inv(XX'*XX ))*(XX'*Z);
end

