%两者不同点在于，xcen的获取方式
%最准确的交点位置获取？原图像局部直线（不畸校正）。更复杂的算法。验证？用同一组图片，测同样位置的标准块。

%由于基于较比不变性，保持标定板的纵向线段和光刀都在相交
clear;close all;clc
yoffset=200;
height=196;


addpath('./ZhangCalibToolbox');
load('Calib_Results.mat');
% load('Calib_Results_old1.mat');
if ~exist('fc')|~exist('cc')|~exist('kc')|~exist('alpha_c'),
    fprintf(1,'No intrinsic camera parameters available.\n');
    return;
end;
fu=fc(1);fv=fc(2);u0=cc(1);v0=cc(2);
Kc=[fu 0 u0 0;
    0 fv v0 0;
    0 0 1 0];

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%重要参数s
WorldReferenceimg='000.bmp';
srccols=782;srcrows=582;gridcols=19;gridrows=15;
Prefix1={'0';'2';'4';'6';'8'; '10'; '12' ;'14' };
Prefix2={'1';'3';'5';'7'; '9';'11'; '13' ;'15' };
%Prefix1={'0';'2';'4';'6';'8'; '10'; '12' ;'14' ;'16' ;'18'; '20'; '22'; '24'; '26'; '28'; '30'; '32'; '34'; '36';'38'};
%P%refix2={'1';'3';'5';'7'; '9';'11'; '13' ;'15' ;'17' ;'19'; '21'; '23'; '25'; '27'; '29'; '31'; '33'; '35'; '37';'39'};
st='gbmykgbmykgbmykgbmykgbmykgbmyk';
for im=1:1 :7   
    srcname=[Prefix1{im} '.bmp'];
    Rcname=['_rect' Prefix1{im} '.BMP'];
    Lname=[Prefix2{im} '.bmp'];
    I = imread(srcname);
    Idis=imread(Rcname);
    Iline=imread(Lname);
    Iline=rgb2gray(Iline);
    XwCen=eval(['X_' Prefix2{im}]);
    Ones=ones(1,size(XwCen,2));
    XwCen=[XwCen;Ones];
    R=eval( ['Rc_' Prefix2{im}] ) ;
    T=eval( ['Tc_' Prefix2{im}] ) ;
    M=[R,T];
    M(4,:)=[0 0 0 1];
    xcen=Kc*M*XwCen;
    Zc= xcen(3,:);
    
    xcenx=xcen(1 ,:)./Zc;
    xceny=xcen(2 ,:)./Zc;
    xcen=[  xcenx;  xceny];%%%%%%%%%%图像坐标系（其实是uv）无畸变情况下的
    
    Line1=xcen(:,0*gridrows+1:(0+1)*gridrows);
    Line2=xcen(:,(gridcols-1)*gridrows+1:(gridcols-1+1)*gridrows);
    [ bk1 ] = meansquare2( Line1);
    [ bk2 ] = meansquare2( Line2);%最左右的直线
    [src,Centerdis ] = LineExtract( Iline ,fc,cc,kc,bk1,bk2);%只在这中间取出点
    Centerdis=Centerdis';
    % plot(Centerdis (1,:)+1,Centerdis (2,:)+1,'b.');
    %%%%%%最小二乘法%%%%%%
    [ bk ] = meansquare2( Centerdis);
    [ bkRefine ] = meansquare2Refine( Centerdis,bk,10);
    startx=1;
    starty= [1 startx ]*bkRefine;
    endx=srccols;
    endy= [1 endx ]*bkRefine;
    %%%%%%%%%%%%%%%%%%%%%%
    figure(101)
    RR=Idis;
    GG=RR;
    BB=RR;
    for k=1:size(Centerdis,2)
        a=int32(cut(Centerdis(1,k),1,srccols));
        b=int32(cut(Centerdis(2,k),1,srcrows));
        GG(b,a)=255;
        RR(b,a)=0;
        BB(b,a)=255;
    end
    Idis(:,:,1)=RR;
    Idis(:,:,2)=GG;
    Idis(:,:,3)=BB;
    imshow(Idis);
    hold on

%     plot(xcen(1,:)+1,xcen(2,:)+1,'y*');
%  ;
    plot([startx+1,endx+1],[starty+1,endy+1],'r','LineWidth',1.5)
    
    for i=0:gridcols-1
        xcCur=xcen(:,i*gridrows+1:(i+1)*gridrows);
        plot([xcCur(1,1)+1,xcCur(1,gridrows)+1],[xcCur(2,1)+1,xcCur(2,gridrows)+1],'m','LineWidth',1.5)%网格线
        
        XcCur=XwCen(:,i*gridrows+1:(i+1)*gridrows);
        [ bk ] = meansquare2(xcCur);
        
        [ x,y ] = interSet(bk,bkRefine );
        %注意，由于y的关系更可靠，用y作start和end
        index=floor(gridrows/3)+1;
        [ Xw(1),Xw(2) ] = CrossRatio( xcCur(:,1),xcCur(:,index),xcCur(:,gridrows),XcCur(:,1),XcCur(:,index),XcCur(:,gridrows),[x,y] );
%         starty=xcCur(2,1);    注意是较比不变性！！！！！！
%         startx= (starty-bk(1))/bk(2);
%         endy=xcCur(2,end);
%         endx=(endy-bk(1))/bk(2) ;
%         
%         Invariant=(x- startx)/(endx- startx);
%         StartX=XcCur(1,1);
%         StartY=XcCur(2,1);
%         endX=XcCur(1,end);
%         %     endY=XcCur(2,end);
%         Xw(1)=StartX+(endX-StartX)*Invariant;
%         Xw(2)=StartY;
       
        Xw(3)=0;
        Xw(4)=1;
        Xc(i+1,:)=M*Xw';
        plot(x+1,y+1,'ro','LineWidth',1.5);%交点
        plot([startx+1,endx+1],[starty+1,endy+1],'r','LineWidth',1.5)%网格线
    end
    Xcross((im-1)*gridcols+1:im*gridcols,:)=Xc;
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%3d绘图%%%%%%%%%%%%%%%%%%
      figure(103)
%      plot3(Xc(:,1),Xc(:,2),Xc(:,3),'r','LineWidth',3.5)
     
      
     hold on
     for ix=1:gridcols
         plot3(Xc(ix,1),Xc(ix,2),Xc(ix,3),'or','LineWidth',1.5)
     end
        for i=0:gridcols-1
            Xws=[XwCen(:,i*gridrows+1)];
            Xwe=[XwCen(:,(i+1)*gridrows )];
            Xcs =M*Xws;
            Xce =M*Xwe;
            plot3([Xcs(1) Xce(1)],[  Xcs(2) Xce(2)] ,[Xcs(3) Xce(3)],st(im),'LineWidth',0.025)
        end
        for i=1:gridrows
            Xws=[XwCen(:,i)];
            Xwe=[XwCen(:,i+gridrows*gridcols-gridrows )];
            Xcs =M*Xws;
            Xce =M*Xwe;
            plot3([Xcs(1) Xce(1)],[  Xcs(2) Xce(2)] ,[Xcs(3) Xce(3)],st(im),'LineWidth',0.025)
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%3d绘图%%%%%%%%%%%%%%%%%%
    startx=1;
    starty= [1 startx ]*bkRefine;
    endx=srccols;
    endy= [1 endx ]*bkRefine;
    figure(102)
    imshow(src)
    hold on
    plot([startx+1,endx+1],[starty+1,endy+1],'r','LineWidth',1.5)
    figure(101)
    for ix=1:size(xcen,2)
        if mod(ix,gridrows)==1||mod(ix,gridrows)==4 || mod(ix,gridrows)==gridrows-1
        plot(xcen(1,ix)+1,xcen(2,ix)+1,'y+','LineWidth',1.5);
      
        end
    end
end
figure(103)
[alfa ] = MeanSquare3( Xcross )
[x y]=meshgrid(-40:1:40);
z=alfa(1)+alfa(2)*x+alfa(3)*y;
% mesh(x,y,z);
surf(x,y,z);
xlabel('Xc');
ylabel('Yc');
zlabel('Zc');
set(gca,'FontSize',14);shading interp
colormap(gray(1));
alpha(0.5)
maxdist=0;
A=alfa(2);
B=alfa(3);
D=alfa(1);
C=-1;
sumdist=0;
for i=1:size(Xcross,1)
    dist=abs(A* Xcross(i,1)+B* Xcross(i,2)+C* Xcross(i,3)+D)/sqrt(A*A+B*B+C*C);
    sumdist=sumdist+dist;
    if dist>maxdist
        maxdist=dist;
    end
end
maxdist
sumdist/size(Xcross,1)

 

I = double(imread(WorldReferenceimg));
  
if size(I,3)>1,
   I = I(:,:,2);
end;


%%% EXTRACT GRID CORNERS:

fprintf(1,'\nExtraction of the grid corners on the image\n');

disp('Window size for corner finder (wintx and winty):');
% wintx = input('wintx ([] = 5) = ');
% wintx=13; 
% if isempty(wintx), wintx = 5; end;
% wintx = round(wintx);
% % winty = input('winty ([] = 5) = ');
%  winty = 13;
% if isempty(winty), winty = 5; end;
% winty = round(winty);
wintx=5;
if isempty(wintx), wintx = 5; end;
wintx = round(wintx);
% winty = input('winty ([] = 5) = ');
winty = 5;
if isempty(winty), winty = 5; end;
winty = round(winty);


fprintf(1,'Window size = %dx%d\n',2*wintx+1,2*winty+1);


[x_ext,X_ext,n_sq_x,n_sq_y,ind_orig,ind_x,ind_y] = extract_grid(I,wintx,winty,fc,cc,kc);



%%% Computation of the Extrinsic Parameters attached to the grid:

[omc_ext,Tc_ext,Rc_ext,H_ext] = compute_extrinsic(x_ext,X_ext,fc,cc,kc,alpha_c);


%%% Reproject the points on the image:

[x_reproj] = project_points2(X_ext,omc_ext,Tc_ext,fc,cc,kc,alpha_c);

err_reproj = x_ext - x_reproj;

err_std2 = std(err_reproj')';


Basis = [X_ext(:,[ind_orig ind_x ind_orig ind_y ind_orig ])];

VX = Basis(:,2) - Basis(:,1);
VY = Basis(:,4) - Basis(:,1);

nX = norm(VX);
nY = norm(VY);

VZ = min(nX,nY) * cross(VX/nX,VY/nY);

Basis = [Basis VZ];

[x_basis] = project_points2(Basis,omc_ext,Tc_ext,fc,cc,kc,alpha_c);

dxpos = (x_basis(:,2) + x_basis(:,1))/2;
dypos = (x_basis(:,4) + x_basis(:,3))/2;
dzpos = (x_basis(:,6) + x_basis(:,5))/2;



figure(2);
image(I);
colormap(gray(256));
hold on;
plot(x_ext(1,:)+1,x_ext(2,:)+1,'r+');
plot(x_reproj(1,:)+1,x_reproj(2,:)+1,'yo');
h = text(x_ext(1,ind_orig)-25,x_ext(2,ind_orig)-25,'O');
set(h,'Color','g','FontSize',14);
h2 = text(dxpos(1)+1,dxpos(2)-30,'X');
set(h2,'Color','g','FontSize',14);
h3 = text(dypos(1)-30,dypos(2)+1,'Y');
set(h3,'Color','g','FontSize',14);
h4 = text(dzpos(1)-10,dzpos(2)-20,'Z');
set(h4,'Color','g','FontSize',14);
plot(x_basis(1,:)+1,x_basis(2,:)+1,'g-','linewidth',2);
title('Image points (+) and reprojected grid points (o)');
hold off;


fprintf(1,'\n\nExtrinsic parameters:\n\n');
fprintf(1,'Translation vector: Tc_ext = [ %3.6f \t %3.6f \t %3.6f ]\n',Tc_ext);
fprintf(1,'Rotation vector:   omc_ext = [ %3.6f \t %3.6f \t %3.6f ]\n',omc_ext);
fprintf(1,'Rotation matrix:    Rc_ext = [ %3.6f \t %3.6f \t %3.6f\n',Rc_ext(1,:)');
fprintf(1,'                               %3.6f \t %3.6f \t %3.6f\n',Rc_ext(2,:)');
fprintf(1,'                               %3.6f \t %3.6f \t %3.6f ]\n',Rc_ext(3,:)');
fprintf(1,'Pixel error:           err = [ %3.5f \t %3.5f ]\n\n',err_std2); 


k1 = kc(1);
k2 = kc(2);
k3 = kc(5);
p1 = kc(3);
p2 = kc(4);
fid1=fopen([ 'IntrinsicAndExtrinsic.dat'],'w');%
fprintf(fid1,'%c',['<fu>' num2str(fc(1),10),'</fu>' char(13,10)']);
fprintf(fid1,'%c',['<fv>' num2str(fc(2),10),'</fv>' char(13,10)']);
fprintf(fid1,'%c',['<u0>' num2str( cc(1),10),'</u0>' char(13,10)']);
fprintf(fid1,'%c',['<v0>' num2str(cc(2) ,10),'</v0>' char(13,10)']);
fprintf(fid1,'%c',['<k1>' num2str( k1,10),'</k1>' char(13,10)']); 
fprintf(fid1,'%c',['<k2>' num2str( k2,10),'</k2>' char(13,10)']);
fprintf(fid1,'%c',['<k3>' num2str( k3,10),'</k3>' char(13,10)']);
fprintf(fid1,'%c',['<p1>' num2str( p1,10),'</p1>' char(13,10)']);
fprintf(fid1,'%c',['<p2>' num2str( p2,10),'</p2>' char(13,10)']); 

M=[ Rc_ext,Tc_ext ];
M(4,:)=[0 0 0 1];
M2=inv(M)
M31=M2(3,1)
M32=M2(3,2)
M33=M2(3,3)
M34=M2(3,4)
 

fprintf(fid1,'%c',['<a1>' num2str( alfa(1),10),'</a1>' char(13,10)']);
fprintf(fid1,'%c',['<a2>' num2str(alfa(2) ,10),'</a2>' char(13,10)']);
fprintf(fid1,'%c',['<a3>' num2str(alfa(3) ,10),'</a3>' char(13,10)']);
 
M=M2;
fprintf(fid1,'%c',['<m11>' num2str(M(1,1) ,10),'</m11>' char(13,10)']);
fprintf(fid1,'%c',['<m12>' num2str(M(1,2) ,10),'</m12>' char(13,10)']);
fprintf(fid1,'%c',['<m13>' num2str(M(1,3) ,10),'</m13>' char(13,10)']);
fprintf(fid1,'%c',['<m14>' num2str(M(1,4) ,10),'</m14>' char(13,10)']); 
fprintf(fid1,'%c',['<m21>' num2str(M(2,1) ,10),'</m21>' char(13,10)']);
fprintf(fid1,'%c',['<m22>' num2str(M(2,2) ,10),'</m22>' char(13,10)']);
fprintf(fid1,'%c',['<m23>' num2str(M(2,3) ,10),'</m23>' char(13,10)']);
fprintf(fid1,'%c',['<m24>' num2str(M(2,4) ,10),'</m24>' char(13,10)']);
fprintf(fid1,'%c',['<m31>' num2str(M(3,1) ,10),'</m31>' char(13,10)']);
fprintf(fid1,'%c',['<m32>' num2str(M(3,2) ,10),'</m32>' char(13,10)']);
fprintf(fid1,'%c',['<m33>' num2str(M(3,3) ,10),'</m33>' char(13,10)']);
fprintf(fid1,'%c',['<m34>' num2str(M(3,4) ,10),'</m34>' char(13,10)']);

fprintf(fid1,'%c',['<yoffset>' num2str(yoffset),'</yoffset>' char(13,10)']);
fprintf(fid1,'%c',['<height>' num2str(height),'</height>' char(13,10)']);



fclose(fid1)
disp('标定结束，请将dat文件转到你的exe的文件夹中');


% fid1=fopen([ 'CalibResultsForVs.txt'],'w');%
% fprintf(fid1,'%c',['///////////////////////Replace 1 in ConsAndfun.cpp//////////////////////////////////'  char(13,10)']);
% fprintf(fid1,'%c',['double fu = ' num2str(fc(1),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double fv = ' num2str(fc(2),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double u0 = ' num2str(cc(1),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double v0 = ' num2str(cc(2),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double k1 = ' num2str((k1),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double k2 = ' num2str((k2),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double k3 = ' num2str((k3),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double p1 = ' num2str((p1),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double p2 = ' num2str((p2),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double a1 = ' num2str(alfa(1),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double a2 = ' num2str(alfa(2),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['double a3 = ' num2str(alfa(3),10),  ' ;'  char(13,10)']);
% fprintf(fid1,'%c',['///////////////////////Replace 1 in ConsAndfun.cpp//////////////////////////////////'  char(13,10)']);
% 
% fprintf(fid1,'%c',['///////////////////////Replace 2 in StcuctlineProcess.cpp threeD//////////////////////////////////'  char(13,10)']);
%  
% M=[ Rc_ext,Tc_ext ];
% M(4,:)=[0 0 0 1];
%  M2=inv(M)
% fprintf(fid1,'     	result[0]  =  %3.12f *Xc+ %3.12f*Yc+ %3.12f*Zc+ %3.12f ;\n',M2(1,:)');
% fprintf(fid1,'     	result[1]  =  %3.12f *Xc+ %3.12f*Yc+ %3.12f*Zc+ %3.12f ;\n',M2(2,:)');
% fprintf(fid1,'     	result[2]  =  %3.12f *Xc+ %3.12f*Yc+ %3.12f*Zc+ %3.12f ;\n',M2(3,:)');
% fprintf(fid1,'%c',['///////////////////////Replace 2 in StcuctlineProcess.cpp threeD//////////////////////////////////'  char(13,10)']);
% fclose(fid1)
% disp('标定结束，请打开CalibResultsForVs.txt并在VS中替换其中内容');





