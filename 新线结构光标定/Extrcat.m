th=140;
th2=th*0.75;
maxline=5;
epsilon=3;
srccols=1626;
srcrows=1236;
gray=imread('01.bmp');
R=gray;
G=R;
B=R;
gray=double(gray);

bw=gray>th;
% imshow(bw)
CenCoase=zeros(srccols,1);
CenRefine=CenCoase;
for k=1:srccols
    count=0;
    for j=1:srcrows
        if  bw(j,k)
            count=1+count;
            CenCoase(k)= CenCoase(k)+j;
        end
    end
    if count>=1
        CenCoase(k)  = CenCoase(k) /count;
        B(  int32(CenCoase(k)),k)=255;
        G(  int32(CenCoase(k)),k)=0;
        R( int32(CenCoase(k)),k)=0;
    end
    
end
for  k=2:srccols-1
    max = 0;
    maxj= 0;
    if CenCoase(k)   %To refine
        
        count = 0;
        Sum = 0;
        start = cut(int32(CenCoase(k)) - maxline, 1, srcrows-1);
        End = cut(int32(CenCoase(k)) + maxline, 1, srcrows);
        for j=start:End
            
            if gray(j,k) > th2
                
                Sum = Sum+gray(j,k);
                CenRefine(k)  = j*gray(j,k)+ CenRefine(k);
            end
        end
        if Sum
            CenRefine(k)= CenRefine(k)/ Sum;
        else
            CenRefine(k) = CenCoase(k);
        end%refine1
        R(int32(CenRefine(k)),k)=255;
        G(int32(CenRefine(k)),k)=0;
        B(int32(CenRefine(k)),k)=0;
    else
        
        for j=1:srcrows
            
            if (gray(j,k) > max)
                
                max = gray(j,k);
                maxj = j;
                if (max > th*2)
                    break;
                end
            end%max2
            %CenMax(k) = maxj;
            
        end
        if  abs(maxj - CenCoase(k - 1)) < epsilon || abs(maxj - CenCoase(k + 1)) < epsilon
            
            G(maxj,k)=255;
            R(maxj,k)=255;
            B(maxj,k)=0;
            CenRefine(k) = maxj;
        end
    end%else
end%refine
idx=1:srccols;
Centerdis=zeros(srccols,2);
Centerdis(:,1)=idx ;
Centerdis(:,2)= CenRefine(k) ;
Centerdis=distortion(Centerdis',[ 1385.39145   1390.46328 ],[ 825.51631   686.69502 ],[ -0.20882   0.19809   0.00076   0.00135  0.00000 ])';
for k=1:srccols
    a=int32(cut(Centerdis(k,1),1,srccols));
    b=int32(cut(Centerdis(k,2),1,srcrows));
    G(b,a)=55;
    R(b,a)=55;
    B(b,a)=155;
end

src(:,:,1)=R;
src(:,:,2)=G;
src(:,:,3)=B;
% imshow(src)



