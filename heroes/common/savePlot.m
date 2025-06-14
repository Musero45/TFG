function  savePlot(gcf,name,fmt)

nfmt = length(fmt);

for i=1:nfmt
    if strcmp(fmt{i},'pdf')==1 && isunix==1
        saveaspdf(gcf,name);
    else
        saveas(gcf,name,fmt{i});
    end
end
