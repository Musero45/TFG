function plotQFD(QFDcat,saveoption)
%plotQFD plots the QFD cathegories matrix

disp('Plotting QFD matrix;')

figure(1000)
h = bar3(QFDcat);
%colorbar; %plot colorbar

for k = 1:length(h)
    zdata = get(h(k),'ZData');
    zdata=repmat(max(zdata,[],2),1,4);
    set(h(k),'CData',zdata)
end


%colormap(jet(6)) %discrete colorbar with selectable number of tones
axis off
grid off
%set(gca,'XAxisLocation','top'); % if axis = on this set the Xaxis on top
%location
view(2);

if saveoption==1
    saveas(gcf,'QFDMatrix','fig');
    saveas(gcf,'QFDMatrix','pdf');
    saveas(gcf,'QFDMatrix','epsc');
end

end

