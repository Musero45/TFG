function plotOECwhatsComparation(heRank,n,prefix,ref,save)


Nperf = heRank{1}.OEC.NitemsOEC;

nWhatsValue = 0;
for i=1:Nperf
        
    itemOEC = strcat('itemOEC',num2str(i,'%2.0f'));
        
    tarjetVal = heRank{1}.OEC.(itemOEC).tarjetValue;
    name = heRank{1}.OEC.(itemOEC).legend;
    
    if isnumeric(tarjetVal);
        nWhatsValue = nWhatsValue + 1;
        items{nWhatsValue} = itemOEC;
        names{nWhatsValue} = name;
    end
    
end

Nhe = size(heRank,2);

What = zeros(nWhatsValue,Nhe);
N    = zeros(1,Nhe);

for k=1:Nhe
    
    N(k) = k;
    
    for j=1:nWhatsValue
        
    val = heRank{k}.OEC.(items{j}).value;
    tarjetVal = heRank{k}.OEC.(items{j}).tarjetValue;
    
    What(j,k) = val/tarjetVal;
    
    end
    
end

figure(n);hold on;
style = {'bo' 'ro' 'ko' 'go' 'yo' 'co' 'mo'} ;
face  = {'b' 'r' 'k' 'g' 'y' 'c' 'm'};
for i=1:nWhatsValue
    plot(N,What(i,:),style{i},'MarkerFaceColor',face{i});
end
legend(names{:}, 'FontSize', 16,'FontName','Times New Roman')

xlabel({'{\itN_{he}} [-]';'Ranking Helicópteros'}, 'FontSize', 16,'FontName','Times New Roman')
ylabel({'{\itWhat}/{\itWhat_{ref}} [-]'}, 'FontSize', 16,'FontName','Times New Roman')
title({'Comparativa Whats';ref},'FontSize',18,'FontName','Times New Roman');

if save==1
    name = strcat(prefix, 'WhatsComparison');
    saveas(gcf,strcat(name),'epsc')
    saveas(gcf,strcat(name),'pdf')
    saveas(gcf,strcat(name),'fig')
end

end