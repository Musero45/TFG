function  plotHelicopterMission(missState)

setPlot

    for s = 1:length(missState.mSeg);
        
        figure (1)
        grid on
        plot(missState.mSeg{s}.T,missState.mSeg{s}.H,'o-');
        hold on
        xlabel('T [s]');
        ylabel('H [m]');
        
        figure (2)

        subplot(2,2,1)
        grid on
        plot(missState.mSeg{s}.R,missState.mSeg{s}.Mf,'o-');
        hold on
        xlabel('R [m]');
        ylabel('Mf [kg]');

        subplot(2,2,2)
        grid on
        plot(missState.mSeg{s}.T,missState.mSeg{s}.Mf,'o-');
        hold on
        xlabel('T [s]');
        ylabel('Mf [kg]');

        subplot(2,2,3)
        grid on
        plot(missState.mSeg{s}.R,missState.mSeg{s}.PL,'o-');
        hold on
        xlabel('R [m]');
        ylabel('PL [N]');

        subplot(2,2,4)
        grid on
        plot(missState.mSeg{s}.T,missState.mSeg{s}.PL,'o-');
        hold on
        xlabel('T [s]');
        ylabel('PL [N]');


        figure (3)

        subplot(2,2,1)
        grid on
        plot(missState.mSeg{s}.T,missState.mSeg{s}.V,'o-');
        hold on
        xlabel('T [s]');
        ylabel('V [m/s]');

        subplot(2,2,2)
        grid on
        x = missState.mSeg{s}.T;
        y = missState.mSeg{s}.R;
        plot(x,y,'o-');
        hold on
        ylabel('R [m]');
        xlabel('T [s]');

        subplot(2,2,3)
        grid on
        plot(missState.mSeg{s}.R,missState.mSeg{s}.H,'o-');
        hold on
        xlabel('R [m]');
        ylabel('H [m]');
        
        subplot(2,2,4)
        grid on
        plot(missState.mSeg{s}.T,missState.mSeg{s}.P/10^3,'o-');
        hold on
        xlabel('T [s]');
        ylabel('P [kW]');
        
     end



end 