function [ax,lx] = plotStabilityEigenvalues(swmf,AXDS,AYDS,varargin)
%PLOTSTABILITYMAP  Plots map of linear stability (root locus)
%
%   PLOTSTABILITYMAP(X,LEG) plots the linear stability map defined
%   by cell of structures, X, using the cell of legends, LEG. X should be 
%   a cell of valid stability maps and LEG should be of the same
%   length that X. In case that LEG is equal to '' or [] then 
%   the set of plots does not show any legend. PLOTSTABILITYMAP plots 
%   every field of the structure X{i} according to the field type 
%   of the structure X{i}. The cell of stability maps X should be a valid
%   stabiliyt map as being output by getStabilityMap. PLOTSTABILITYMAP
%   plots several kind of plots which are output or not by setting several
%   options, see below. The plots which are output by default are the
%   following:
%   - root locus of eigenvalues of the auto vectors of the linear stability
%   state for several values of the flight condition parameter, usually the
%   forward speed of the helicopter
%   - eigen vectors as function of the flight condition parameter
%   - Characteristic time to double or half the initial perturbation and mode damping as
%   function of the flight condition parameter. 
%   - norm of the longitudinal and lateral components of the eigen vector
%   as function of the flight condition parameter. W^{xz}_i and W^{yz}_i 
%   denote the longitudinal (x-z plane)  and lateral (y-z plane) norm of  
%   the eigen vector i.
%
%   PLOTBLADESTATE(X,LEG,OPTIONS) plots as above with default options 
%   replaced by values set in OPTIONS. OPTIONS should be input in the form 
%   of sets of property value pairs. Default OPTIONS is a structure with 
%   the following fields and values:
% 
%                defaultVars: 'yes'
%                       mode: 'thin'
%                       mark: {1x13 cell}
%                      lines: {1x90 cell}
%                     format: {'epsc'  'pdf'  'fig'}
%                     prefix: 'no'
%                  closePlot: 'no'
%                  titleplot: []
%                mode8marker: {1x8 cell}
%               rootLociLabs: 'yes'
%            rootLociLabsFmt: 'all'
%                  rootLocus: 'yes'
%        plotReimEigenValues: 'yes'
%     plotLongLatEigenValues: 'yes'
%            plotEigenValues: 'yes'
%
%   AX = PLOTBLADESTATE(X,LEG,OPTIONS) plots as above and returns AX 
%   a column vector of handles to the axis of the plots.
%
%   [AX,L] = PLOTBLADESTATE(X,LEG,OPTIONS) plots as above and returns AX
%   and L a column vector of handles to the axis and legends of the plots.
%
%   See also getStabilityMap, setHeroesPlotOptions
%
%   Examples of usage:
%   atm      = getISA;
%   he       = PadfieldBo105(atm);
%   ndHe     = rigidHe2ndHe(he,atm,0);
%   muWT     = [0; 0; 0];
%   ndV      = linspace(.2, .3, 4);
%   n        = length(ndV);
%   fCT      = zeros(6,n);
%   fCT(1,:) = ndV(:);
%   ts       = getTrimState(fCT,muWT,ndHe);
%   ss       = getLinearStabilityState(ts,fCT,muWT,ndHe);
%   sm       = getStabilityMap(ss,he.mainRotor.Omega,he.mainRotor.R);
%   plotStabilityMap(sm,{'PadfieldBo105'});
% 




if length(varargin)==1 
   while iscell(varargin) && length(varargin)==1
      varargin = varargin{1};
   end
end
% swmf    = output2cellOfStructures(swmf);


% FIXME this function is so particular that it deserves its own plotOptions
plotOptions            = parseOptions(varargin,@setStabilityPlotOptions);
mark                   = plotOptions.mark;

nsm = 1;
% % % % Set the number of stability maps to be plot
% % % nsm              = length(swmf);
% % % 
% Allocate axis and legend handle output
ax               = zeros(100,nsm); %FIXME

% color = {'b','r','g','k'};
% marker= {'s','o','d','v'};

% Number of equations
neq              = 9;% FIXME 

% Get x - axis
% xdata  = swmf.(char(AXDS.var));


eigenLabs= plotOptions.eigenLabs;
[nx,ny]  = size(swmf.(char(AXDS.var)));

if ny == 1 || nx == 1
    si_matrix = zeros(max([nx,ny]),8);
    % this is just one root locus si(nx,1) or si(1,ny)
    % and it means that the si fieldname is a row or a column vector
    % Set the current number of figure
    hgcf             = getCurrentFigureNumber;
    figure(hgcf + 1)
    hold on;
    set(gcf,'Name',strcat('Root Locus'));
    for j = 1:8
        % Get eigenvalues: si
        si                 = swmf.(eigenLabs{j});
        si_matrix(:,j)     = si(:);
    end
    ax     = plotRootLocus(si_matrix,plotOptions);

else
    if strcmp(plotOptions.plot2dMode,'oneFigure')
       % we plot one and only one root locus with each eigenvalue curve
       % with parameter xvar, and from one eigenvalue curve to another
       % one with parameter yvar
       si_matrix = zeros(nx,8);
       hgcf             = getCurrentFigureNumber;
       figure(hgcf + 1)
       hold on;
       set(gcf,'Name',strcat('Root Locus'));
       for i = 1:ny
           for j = 1:8
               % Get eigenvalues: si
               si                 = swmf.(eigenLabs{j});
               si_matrix(:,j)     = si(:,i);
           end
           ax     = plotRootLocus(si_matrix,plotOptions); hold on;
       end
    elseif strcmp(plotOptions.plot2dMode,'nFigures')
       % we plot 8 root loci with each eigenvalue curve
       % with parameter xvar, and from one eigenvalue curve to another
       % one with parameter yvar
       si_matrix = zeros(nx,8);
       rootLociLabs     = plotOptions.rootLociLabs;
       rootLociLabsFmt  = plotOptions.rootLociLabsFmt;

       for j = 1:8
           modemark  = plotOptions.mode8marker{j};
           modecolor = plotOptions.mode8color{j};
           si               = swmf.(eigenLabs{j});
           % Get eigenvalues: si
           hgcf             = getCurrentFigureNumber;
           figure(hgcf + 1)
           hold on;
           set(gcf,'Name',strcat('Root Locus Mode ',num2str(j)));
           for i = 1:ny
               plot(real(si(:,i)),imag(si(:,i)),...
                    strcat(plotOptions.lines{i},modemark)); hold on;
            if strcmp(rootLociLabs,'yes')
               rootLociLabText = getRootLociLabText(rootLociLabsFmt,ny,j);

               text(real(si(:,j)),imag(si(:,j)),rootLociLabText,...
                                 'VerticalAlignment','bottom', ...
                                 'HorizontalAlignment','right',...
                                 'Color',modecolor{j} ...
                    );
            end






           end
       end

    else
       error('plotStabilityMap: wrong plot2dMode option');
    end

end


% %==========================================================================
% % Plot eigen vector variation with parameter
% % it does make sense only when the number of stability maps is one since
% % every stability map figure corresponds to 8/9 autovector series.
% if strcmp(plotOptions.plotEigenValues,'yes')
% if nsm == 1  
%     % Get eigenmodes
%     eigW   = swmf.eigW;
% 
%     for k = 2:ssv
%     kfig = k-1;
%     figure(hgcf + 1 + kfig)
%     hold on
%     for i = 1:neq
%         b(1,:) = eigW(i,k,:);
%         if imag(si(k,:))== 0
%             plot(ndV,-sign(b(1,1)).*abs(b),mark{i})
%             ylabel('X_i [1/s]')
%         else
%             plot(ndV,abs(b),mark{i})
%             ylabel('|X_i| [1/s]')
%         end
%     end
% 
%     grid on
%     xlabel('V/(\Omega R) [-]')    
%     legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
%     if ~strcmp(plotOptions.prefix,'no')
%        name = strcat('modeAx',num2str(k));
%        savePlot(gcf,name,{'pdf'});
%     end
%     end
% end
% end
% %==========================================================================
% 
% % Plot time to double/half the initial amplitude perturbation and frequency
% % of mode oscillations
% if strcmp(plotOptions.plotReimEigenValues,'yes');
% plotReimEigenValues(swmf,leg,plotOptions);
% end
% % Plot 
% if strcmp(plotOptions.plotLongLatEigenValues,'yes');
% plotLongLatEigenValues(swmf,leg,plotOptions);
% end
% 
% 
% 
% function plotReimEigenValues(sM,legend,plotOpt)
% 
% 
% % if length(varargin)==1 
% %    while iscell(varargin) && length(varargin)==1
% %       varargin = varargin{1};
% %    end
% % ends      = size(coswmf);
% % sM  = output2cellOfStructures(sM);
% % 
% % plotOpt = parseOptions(varargin,@setStabilityMapPlotOptions);
% 
% 
% axesData.xvar = 'mux';
% axesData.xlab = 'V/(\Omega R) [-]';
% axesData.xunit = 1;
% axesData.yvars = {...
%                   't12_1' 't12_2' 't12_3' 't12_4' ...
%                   't12_5' 't12_6' 't12_7' 't12_8' 't12_9' ...
%                   'omega_1' 'omega_2' 'omega_3' 'omega_4' ...
%                   'omega_5' 'omega_6' 'omega_7' 'omega_8' 'omega_9' ...
% };
% axesData.ylabs = {...
%                   't_c(s_1) [s]' 't_{c,2} [s]' 't_{c,3} [s]' 't_{c,4} [s]' ...
%                   't_{c,5} [s]' 't_{c,6} [s]' 't_{c,7} [s]' 't_{c,8} [s]' 't_{c,9} [s]' ...
%                   '\omega_1 [rad/s]' '\omega_2 [rad/s]' '\omega_3 [rad/s]' '\omega_4 [rad/s]' ...
%                   '\omega_5 [rad/s]' '\omega_6 [rad/s]' '\omega_7 [rad/s]' '\omega_8 [rad/s]' '\omega_9 [rad/s]' ...
%                   };
%               
% axesData.yunits = [...
%                    1 1 1 1   ...
%                    1 1 1 1 1 ...
%                    1 1 1 1   ...
%                    1 1 1 1 1 ...
%                    ];
%          
% 
% plotCellOfStructures(sM,axesData,legend,plotOpt);
% 
% 
% 
% function plotLongLatEigenValues(sM,legend,plotOpt)
% 
% 
% % if length(varargin)==1 
% %    while iscell(varargin) && length(varargin)==1
% %       varargin = varargin{1};
% %    end
% % end
% % sM  = output2cellOfStructures(sM);
% % 
% % plotOpt = parseOptions(varargin,@setStabilityMapPlotOptions);
% 
% 
% axesData.xvar = 'mux';
% axesData.xlab = 'V/(\Omega R) [-]';
% axesData.xunit = 1;
% axesData.yvars = {...
%                   'eigW_long1' 'eigW_long2' 'eigW_long3' 'eigW_long4' ...
%                   'eigW_long5' 'eigW_long6' 'eigW_long7' 'eigW_long8' 'eigW_long9'...                  
%                   'eigW_lat1' 'eigW_lat2' 'eigW_lat3' 'eigW_lat4' ...
%                   'eigW_lat5' 'eigW_lat6' 'eigW_lat7' 'eigW_lat8' 'eigW_lat9'...                  
% 
% };
% axesData.ylabs = {...
%                   'W_1^{xz} [?]' 'W_2^{xz} [?]' 'W_3^{xz} [?]' 'W_4^{xz} [?]]' ...
%                   'W_5^{xz} [?]' 'W_6^{xz} [?]' 'W_7^{xz} [?]' 'W_8^{xz} [?]]' 'W_9^{xz} [?]]'...
%                   'W_1^{yz} [?]' 'W_2^{yz} [?]' 'W_3^{yz} [?]' 'W_4^{yz} [?]]' ...
%                   'W_5^{yz} [?]' 'W_6^{yz} [?]' 'W_7^{yz} [?]' 'W_8^{yz} [?]]' 'W_9^{yz} [?]]'...
%                   };
%               
% axesData.yunits = [...
%                    1 1 1 1   ...
%                    1 1 1 1 1 ...
%                    1 1 1 1   ...
%                    1 1 1 1 1 ...
%                    ];
%          
% 
% plotCellOfStructures(sM,axesData,legend,plotOpt);


function rootLociLabText = getRootLociLabText(rootLociLabsFmt,n,nMode)



%==========================================================================
% Root loci figure
% FIXME: use cell2fun to improve this nightmare of defining rootLociLabs

rootLociLabText = cell(n,1);

if strcmp(rootLociLabsFmt,'all')
    for i = 1:n
            rootLociLabText{i} = strcat('$$',num2str(nMode),'_{',num2str(i),'}$$');
    end
elseif strcmp(rootLociLabsFmt,'ini2end')
    for i = 1:n
             if i == 1 || i == n
               rootLociLabText{i} = strcat('$$',num2str(nMode),'_{',num2str(i),'}$$');
            else
               rootLociLabText{i} = '';
            end
    end

else
   error('plotStabilityMap: wrong rootLociLabsFmt value')
end


function ax = plotRootLocus(si,plotOptions)
% si is a matrix of eigenvalues of size size(si) = [np,8] where np is the
% number of points of the parameter
rootLociLabs           = plotOptions.rootLociLabs;
rootLociLabsFmt        = plotOptions.rootLociLabsFmt;

np                     = size(si,1);
for j = 1:8

    modemark  = plotOptions.mode8marker{j};
    modecolor = plotOptions.mode8color{j};
    ax(:,j) = plot(real(si(:,j)),imag(si(:,j)),strcat(modecolor,'-',modemark)); hold on;
    if strcmp(rootLociLabs,'yes')
       rootLociLabText = getRootLociLabText(rootLociLabsFmt,np,j);
       for k = 1:np
       text(real(si(k,j)),imag(si(k,j)),rootLociLabText{k},...
                         'VerticalAlignment','bottom', ...
                         'HorizontalAlignment','right',...
                         'Color',modecolor ...
            );
       end
    end
end
grid on
xlabel('Re ($$s_i$$) [1/s]')
ylabel('Im ($$s_i$$) [1/s]')
% legend(plotOptions.eigenText,'Location','Best');
