close all
clear all

d2r = pi/180;
alpha = linspace(-180,180,37)*d2r;
beta  = linspace(-180,180,37)*d2r;

n = length(alpha);
m = length(beta);
K = zeros(n,m,6);

tic;
for i = 1:n
    for j = 1:m
        K(i,j,:) = generalFus(alpha(i), beta(j), 0);
        K2(i,j,:)= PadPumaFus(alpha(i),beta(j), 0);
    end
end
toc

vars = {'K_{x} [-]' 'K_{y} [-]' 'K_{z} [-]' ...
        'K_{Mx} [-]' 'K_{My} [-]' 'K_{Mz} [-]'};

names = {'Kx' 'Ky' 'Kz' ...
        'KMx' 'KMy' 'KMz'};
    
setPlot

for i = 1:3
    figure(2*i-1)
    title(names{2*i-1})
    plot(alpha,K(:,19,2*i-1),'k')
    grid on
    hold on
    plot(alpha,K2(:,19,2*i-1),'b')
    figure(2*i)
    title(names{2*i})
    plot(alpha,K(19,:,2*i),'k')
    grid on
    hold on
    plot(alpha,K2(19,:,2*i),'b')
end
    
% for i = 1:6
%     figure(i)
%     [C,h] = contour(beta./d2r,alpha./d2r,K(:,:,i));
%     clabel(C,h)
%     xlabel('\beta [º]');ylabel('\alpha [º]'); zlabel(vars{i});
%     title(names{i})
%     figure(i+6)
%     h = surfc(beta./d2r,alpha./d2r,K(:,:,i),'EdgeColor','none');
%     xlabel('\beta [º]');ylabel('\alpha [º]'); zlabel(vars{i});
% end
