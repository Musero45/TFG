close all
clear all

plotOpt = setHeroesPlotOptions;
mark = plotOpt.lines;

setPlot

load modes.mat

for k = 2:9
    figure(k+9)
    hold on
    plot(ndV,real(d(k,:)),mark{1})
    plot(ndV,imag(d(k,:)),mark{2})    
    grid on
    xlabel('V/(\Omega R) [-]')
    ylabel('s [1/s]')
    legend('Re(s)','Im(s)')
    name = strcat('autov',num2str(k));
    savePlot(gcf,name,{'pdf'});
    
    figure(k+18)
    for j = 1:length(ndV)
        long(1,j) = norm(eigV(1:4,k,j),2);
        lat (1,j) = norm(eigV(5:9,k,j),2);
    end
    hold on
    legend('long','lat')
    plot(ndV,long,mark{2})
    plot(ndV,lat,mark{3}) 
    grid on
    xlabel('V/(\Omega R) [-]')
    ylabel('|w_i| [-]')
    legend('long','lat')
    name = strcat('longlat',num2str(k));
    savePlot(gcf,name,{'pdf'});
end

figure(2)
hold on
for i = 1:9
    b(1,:) = eigV(i,2,:);
    plot(ndV,-cos(angle(b(1,1))).*abs(b),mark{i})
end
grid on
xlabel('V/(\Omega R) [-]')
ylabel('X_i [-]')
legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
savePlot(gcf,'mode2',{'pdf'});

figure(3)
hold on
for i = 1:9
    b(1,:) = eigV(i,3,:);
    plot(ndV,cos(angle(b(1,1))).*abs(b),mark{i})
end
grid on
xlabel('V/(\Omega R) [-]')
ylabel('X_i [-]')
legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
savePlot(gcf,'mode3',{'pdf'});

figure(4)
hold on
for i = 1:9
    b(1,:) = real(eigV(i,4,:));
    plot(ndV,abs(b),mark{i})
end
grid on
xlabel('V/(\Omega R) [-]')
ylabel('|X_i| [-]')
legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
savePlot(gcf,'mode4',{'pdf'});

figure(6)
hold on
for i = 1:9
    b(1,:) = real(eigV(i,6,:));
    plot(ndV,abs(b),mark{i})
end
grid on
xlabel('V/(\Omega R) [-]')
ylabel('|X_i| [-]')
legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
savePlot(gcf,'mode6',{'pdf'});

figure(8)
hold on
for i = 1:9
    b(1,:) = eigV(i,8,:);
    plot(ndV,-cos(angle(b(1,1))).*abs(b),mark{i})
end
grid on
xlabel('V/(\Omega R) [-]')
ylabel('X_i [-]')
legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
savePlot(gcf,'mode8',{'pdf'});

figure(9)
hold on
for i = 1:9
    b(1,:) = eigV(i,9,:);
    plot(ndV,-cos(angle(b(1,1))).*abs(b),mark{i})
end
grid on
xlabel('V/(\Omega R) [-]')
ylabel('X_i [-]')
legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
savePlot(gcf,'mode9',{'pdf'});


