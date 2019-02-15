function   output   = cut( input,minx,maxx)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if input<minx
 
output =minx;
 
elseif input>maxx
    output =maxx;
else
   output=input ;
end

end

