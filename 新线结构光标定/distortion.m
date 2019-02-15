function [x]=distortion(x_kk,fc,cc,kc)
% kc = [ 0.04483   -0.11097   -0.00025   -0.00036  0.00000 ];
% fc = [ 570.29260   570.39782 ];
% cc = [ 343.43553   231.11604 ];
% alpha_c = [ 0.00000 ];

k1 = kc(1);
k2 = kc(2);
k3 = kc(5);
p1 = kc(3);
p2 = kc(4);


x_distort = [(x_kk(1,:) - cc(1))/fc(1);(x_kk(2,:) - cc(2))/fc(2)];

x=x_distort;
xd=x_distort;

%  for kk=1:20
    
    r_2 = sum(x.^2);
    k_radial =  1 + k1 * r_2 + k2 * r_2.^2 + k3 * r_2.^3;
    delta_x = [2*p1*x(1,:).*x(2,:) + p2*(r_2 + 2*x(1,:).^2);
        p1 * (r_2 + 2*x(2,:).^2)+2*p2*x(1,:).*x(2,:)];
    x = (xd - delta_x)./(ones(2,1)*k_radial);
    
%  end;
x_kk=[x(1,:)*fc(1)+cc(1);x(2,:)*fc(2)+cc(2)];
x=x_kk;
