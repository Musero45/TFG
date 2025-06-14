function plotOECevolution(heRank,prefix,save)


N = size(heRank,2);

OEC = zeros(1,N);
Nhe = zeros(1,N);

for k=1:N
    OEC(k) = heRank{k}.OEC.OEC;
    Nhe(k) = k;
end

figure(1050)
plot(Nhe,OEC,'b-','LineWidth',2);

xlabel({'{\itN_{he}} [-]';'Ranking Helicópteros'}, 'FontSize', 16,'FontName','Times New Roman')
ylabel({'{\itOEC} [-]'}, 'FontSize', 16,'FontName','Times New Roman')
%title({'Evolución puntuaciones OEC'},'FontSize',18,'FontName','Times New Roman');

if save==1
    name = strcat(prefix, 'HelicopterEvolution');
    saveas(gcf,strcat(name),'epsc')
    saveas(gcf,strcat(name),'pdf')
    saveas(gcf,strcat(name),'fig')
end

end