function plotOECstate(heRank,nGraf,n,prefix,save)


nheRank = size(heRank,2);
if nGraf > nheRank
    disp('plotting all helicopters')
elseif nGraf < nheRank
    heRank = heRank(1,1:nGraf);
end

henum = size(heRank,2);
Nitems = heRank{1}.OEC.NitemsOEC;
legendcell = cell(1,Nitems);
datetick = cell(1,Nitems);

for i=1:henum
    
    figure(n+i)
    hold on
    
    for j=1:Nitems
        
        weightvector = zeros(1,Nitems);
        label = zeros(1,Nitems);        
        
        itemOEC = strcat('itemOEC',num2str(j,'%2.0f'));
        legendcell{j} = heRank{i}.OEC.(itemOEC).legend;
        weight = heRank{i}.OEC.(itemOEC).weight;
        mark = heRank{i}.OEC.(itemOEC).mark;
        weightvector(j) = weight;
        label(j) = mark*weight;
        value = heRank{i}.OEC.(itemOEC).value;
        tarjetvalue = heRank{i}.OEC.(itemOEC).tarjetValue;
        
        datetick = heRank{i}.Performances.dateticks;
        
        
        if strcmp(tarjetvalue,'none')
            color = 'c';
        else
        
            if value > tarjetvalue
                color = 'g';
            elseif value < tarjetvalue
                color = 'r';
            elseif value == tarjetvalue
                color = 'k';
            end
        
        end
        
        handle = bar(weightvector,'b');
        set(get(get(handle, 'Annotation'), 'LegendInformation'), ...
        'IconDisplayStyle', 'off')
        bar(label,color)
        
    end
    
    legend(legendcell,'Location','NorthEastOutside','FontSize',14,'FontName','Times New Roman');
    
    xlim([0 Nitems+1]);

    
    set(gca,'XTick',linspace(1,Nitems,Nitems))
    set(gca,'XTickLabel',datetick,'FontName','Times New Roman','FontSize',14)
    
    scale = heRank{i}.OEC.scale;
    OEC   = heRank{i}.OEC.OEC;
    Rank  = heRank{i}.Rank;
    
    title({['Notas del Helicóptero #',num2str(Rank)];...
        ['OEC = ',num2str(OEC,'%4.2f'),'/',num2str(scale)]},...
        'FontSize',18,'FontName','Times New Roman')
    
    hold off
    
    if save==1
        name = strcat(prefix,'Helicopter#',num2str(Rank));
        saveas(gcf,strcat(name),'epsc')
        saveas(gcf,strcat(name),'pdf')
        saveas(gcf,strcat(name),'fig')
    end

end
end