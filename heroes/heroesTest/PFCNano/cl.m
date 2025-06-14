close all
clear all

d2r = pi/180;
alpha = linspace(-180,180,361)*d2r;
n = length(alpha);

[cl1, cd1, ~] = naca0012(alpha);
[cl2, ~, ~] = HTPBo105Padf(alpha);

cz1 = -cl1.*cos(alpha)-cd1.*sin(alpha);

setPlot
figure(1)
plot(alpha/d2r,-cz1,'k-');
xlabel('\alpha [º]')
ylabel('C_n [-]')
hold on
grid on
plot(alpha/d2r,cl2,'k--');
legend({'NACA 0012','Padfield'},'Location','B')
savePlot(gcf,'cn',{'pdf'});