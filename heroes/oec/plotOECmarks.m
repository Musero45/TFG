function plotOECmarks(heRank,Graf,prefix,save)


Nhe = size(Graf,2);

title1 = 'Comparativa de notas obtenidas';
% title2 = 'Comparing Weight*Marks';

henum = Nhe;
Nitems = heRank{1}.OEC.NitemsOEC;
legendcell = cell(Nitems,2);
legend = cell(1,Nhe);
marks = zeros(Nitems,henum);
% marksW = zeros(Nitems,henum);

for i=1:henum
    
    a = Graf(i);
  
    for j=1:Nitems        
        
        itemOEC = strcat('itemOEC',num2str(j,'%2.0f'));
        legendcell{j,1} = heRank{a}.OEC.(itemOEC).legend;
        legendcell{j,2} = '';
        
        mark = heRank{a}.OEC.(itemOEC).mark;
        % weightMark = heRank{a}.OEC.(itemOEC).weightMark;
        
        marks(j,i)  = mark;
        % marksW(j,i) = weightMark;
        
    end
    
     legend{i} = ['Helicóptero #',num2str(heRank{a}.Rank)]; 
    
end

spider(marks,title1,[[0:Nhe:0]' [1:Nhe:1]'],legendcell,legend);
% spider(marksW,title2,[[0:Nhe:0]' [1:Nhe:1]'],legendcell,legend);

if save==1
    name = strcat(prefix, 'WhatsSpider');
    saveas(gcf,strcat(name),'epsc')
    saveas(gcf,strcat(name),'pdf')
    saveas(gcf,strcat(name),'fig')
end

end