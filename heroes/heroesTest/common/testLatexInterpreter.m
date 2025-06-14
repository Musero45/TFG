function io = testLatexInterpreter
% This test tries to test latex interpreter generation
%

% logical check for saving figures
isave = 0;





close all
x   = linspace(0,2*pi,361);
y   = sin(x).*exp(-x);
matlabver = version;
matlabver(matlabver==' ')=[];

% This emulates setPlot
set(0,'defaulttextinterpreter','tex')
figure(1)
plot(x,y,'b-'); hold on;
xlabel('S_\beta [-]'); 
ylabel('\partial [\beta_{1C},\beta_{1S}] / \partial [\theta_{1C},\theta_{1S}]')
l=legend('\frac{\partial \beta_{1C}}{\partial \beta_{1S}}');
set(l,'interpreter','tex');
grid on;

if isave
filename1 = strcat(matlabver,'_tex.eps');
saveas(1,filename1,'epsc')
end

set(0,'defaulttextinterpreter','factory')
% This emulates unsetPlot


set(0,'defaulttextinterpreter','latex')
figure(2)
plot(x,y,'b-'); hold on;
xlabel('$$S_\beta$$ [-]'); 
ylabel('$$\partial [\beta_{1C},\beta_{1S}]$$ / $$\partial [\theta_{1C},\theta_{1S}]$$')
l=legend('$$\frac{\partial \beta_{1C}}{\partial \beta_{1S}}$$');
grid on;
set(l,'interpreter','latex')
if isave
   filename2 = strcat(matlabver,'_latex.eps');
   saveas(1,filename2,'epsc')
end

set(0,'defaulttextinterpreter','factory')


set(0,'defaulttextinterpreter','latex')
figure(3)
set(3,'defaulttextinterpreter','latex')
plot(x,y,'b-'); hold on;
xlabel('$S_\beta$ [-]'); 
ylabel('$\partial [\beta_{1C},\beta_{1S}]$ / $\partial [\theta_{1C},\theta_{1S}]$')
l=legend('$\frac{\partial \beta_{1C}}{\partial \beta_{1S}}$');
grid on;
set(l,'interpreter','latex')
if isave
   filename3 = strcat(matlabver,'_latex1.eps');
   saveas(1,filename3,'epsc')
end
set(0,'defaulttextinterpreter','factory')



io = 1;






