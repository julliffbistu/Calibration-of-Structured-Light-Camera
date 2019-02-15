x1=[6.883 6.790 6.880 6.883 6.862 6.853 6.885 6.879 6.798 6.858 6.866];
x2=[10.866 10.796 10.785 10.813 10.830 10.803 10.830 10.833 10.813 10.828 10.772 ];
x3=[13.780 13.852 13.883 13.802 13.828 13.748 13.848 13.825 13.825 13.858 13.840 ];
x1mean=0;
for i=1:size(x1,2)
    x1mean=x1mean+x1(i);
end
x1mean=x1mean/size(x1,2)
x1var=0;
x1max=0;
for i=1:size(x1,2)
    x1var=x1var+(x1(i)-x1mean)*(x1(i)-x1mean);
    if abs(x1(i)-x1mean)>x1max
        x1max=abs(x1(i)-x1mean);
    end
end
x1max
x1var=x1var/(size(x1,2)-1)
 x2mean=0;
for i=1:size(x2,2)
    x2mean=x2mean+x2(i);
end
x2mean=x2mean/size(x2,2);
x2var=0;
x2max=0;
for i=1:size(x2,2)
    x2var=x2var+(x2(i)-x2mean)*(x2(i)-x2mean);
    if abs(x2(i)-x2mean)>x2max
        x2max=abs(x2(i)-x2mean);
    end
end
x2max
x2var=x2var/(size(x2,2)-1)
 x3mean=0;
for i=1:size(x3,2)
    x3mean=x3mean+x3(i);
end
x3mean=x3mean/size(x3,2);
x3var=0;
x3max=0;
for i=1:size(x3,2)
    x3var=x3var+(x3(i)-x3mean)*(x3(i)-x3mean);
    if abs(x3(i)-x3mean)>x3max
        x3max=abs(x3(i)-x3mean);
    end
end
x3max
x3var=x3var/(size(x3,2)-1)
x1mean-x2mean
x1mean-x3mean
