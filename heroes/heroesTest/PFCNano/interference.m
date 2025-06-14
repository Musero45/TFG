close all
clear all

S = linspace(0,1,101);
n = length(S);

f1 = stepInterf(S);
f2 = linearInterf(S);
f3 = cosInterf(S);

setPlot
figure(1)
plot(S,f1,'k-');
xlabel('S_{wet}/S')
ylabel('f')
hold on
grid on
plot(S,f2,'k--');
plot(S,f3,'k-.');
legend({'Heavyside','lineal','cosenoidal'},'Location','B')
savePlot(gcf,'interf',{'pdf'});