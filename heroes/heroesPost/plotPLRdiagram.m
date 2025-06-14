function plotPLRdiagram(n,PL,R,style,leg)
%MISSIONWEIGHTOPTIMIZATION Summary of this function goes here
%   Detailed explanation goes here


nplot = size(PL,2);

for i=1:nplot
    R{i}  = R{i}/1e3; % R in km
    PL{i} = PL{i}/9.81; % PL in kg
end

figure(n)
hold on;
grid on;
for i=1:nplot
    plot(R{i},PL{i},style{i},'LineWidth',2); 
end

xlabel('{\itR_{max}} [km]', 'FontSize', 16,'FontName','Times New Roman');
ylabel('{\itPL} [kg]', 'FontSize', 16,'FontName','Times New Roman');

%set(gca,'FontName','Times New Roman','FontSize',16)
%legend(leg, 'FontSize', 16,'FontName','Times New Roman')

legend(leg)


end

