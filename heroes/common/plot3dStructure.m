function varargout = plot3dStructure(Z,xAxes,yAxes,Vars,options)


fmt       = options.format;
titletext = options.titleplot;

if strcmp(options.mode,'thick')
   setPlot
end



naxes  = length(xAxes);

for a = 1:naxes

xvar   = char(xAxes.var);
xlab   = xAxes.lab;
xunit  = xAxes.unit;

yvar   = char(yAxes.var);
ylab   = yAxes.lab;
yunit  = yAxes.unit;

zvars  = Vars.var;
zlabs  = Vars.lab;
zunits = Vars.unit;

hgcf   = getCurrentFigureNumber;
ax     = cell(length(zvars),2);

    if iscell(options.contourLevelList)
        levelList = options.contourLevelList;
    else
        levelList = cell(length(zvars),1);
        for i =1:length(zvars)
            levelList{i} = options.contourLevelList;
        end
    end
    
for i=1:length(zvars)
    var  = char(zvars{i});
    lab  = zlabs{i};
    unit = zunits(i);
    figure(hgcf + i)
    set(gcf,'Name',var);
    % debug dimensions with squeeze (it comes from getNdHeTrimState)
    % we did not use squeeze to solve this until octuber 2020
    xx   = squeeze(Z.(xvar)*xunit);
    yy   = squeeze(Z.(yvar)*yunit);
    f    = squeeze(Z.(var)*unit);
    strf = func2str(options.plot3dMethod);
    


    if strcmp(options.plot3dMode,'parametric')
       [nx,ny] = size(xx);

       % Get number of series
       nSeries   = ny;
       % Define markers
       if nSeries <= length(options.mark)
          mark      = options.mark;
       else
          ol      = options.lines;
          nLines  = length(ol);
          nl      = nLines*ceil(nSeries/nLines);
          mark    = cell(1,nl);
          for k=1:ceil(nSeries/nLines)

%              mark(1+(k-1)*nLines:i*nLines) = ol;
              mark(1+(k-1)*nLines:k*nLines) = ol;
          end
       end
       for j = 1:ny
           plot(xx(:,j),f(:,j),mark{j}); hold on;
       end
       xlabel(xlab); ylabel(lab);
       if strcmp(options.gridOn,'yes')
          grid on;
       end
       % Avoid legends when nSeries is greater than 20
       if nSeries < 20
          leg     = cell(1,ny);
          for j = 1:nSeries
              % Check for [] on the ylabel to define units
              ylab     = char(ylab);
              iBracket = regexp(ylab,'\[');
              jBracket = regexp(ylab,'\]');
              yleg     = ylab(1:iBracket-1);
              unit     = ylab(iBracket+1:jBracket-1);
              leg{j}   = strcat(yleg,'=',num2str(yy(1,j)),unit,'$');
          end
          gcl = legend(leg,'Location','Best');
          set(gcl,'interpreter','latex');
       end

    elseif strcmp(options.plot3dMode,'bidimensional')
       % For the bidimensional case we require as title the label of the
       % variable as title because if titletext is not defined nothing in
       % the graphic denotes the variable to be plotted
       % oscar fix 20/12/2017 before was
       % if isempty(titletext)
       %   titletext = lab;          
       % end
       if isempty(options.titleplot)
          titletext = lab;          
       end

       % This piece of code is only required if the data is in polar coordinates
       if strcmp(options.polarPlot,'yes')==1
%           [theta,rho] = meshgrid(y,x);
          rho   = xx;
          theta = yy/yunit;
          xx    = rho.*sin(theta);
          yy    = rho.*cos(theta);
          xlab  = 'x [-]';
          ylab  = 'y [-]';
% oscar: the next two lines broke most of demos using 3d plotting features
% These two lines were introduced to deal with 3d polar plots and are used
% in the Danny's 3D rotor state features
%        else
%           [yy,xx] = meshgrid(y,x);
       end

        if strcmp(strf,'contour') || ...
           strcmp(strf,'contourf')

            % This piece of code is only required if the data 
            % is in polar coordinates
            if strcmp(options.polarPlot,'yes')==1
               if strcmp(options.clockwisePolar,'no')==1
%                   h = polar([0 2*pi], [0 1]);
                  h = polar(yy,xx);
               elseif strcmp(options.clockwisePolar,'yes')==1
%                   h = polarclockwise([0 2*pi], [0 1]);
                  h = polarclockwise(yy,xx);
               end
               delete(h)
               hold on
            end
%             [Crt,Hrt] = options.plot3dMethod(xx,yy,f,options.nlevels);% FIXME
            if isempty(levelList{i})
            [Crt,Hrt] = options.plot3dMethod(xx,yy,f);
            else
            [Crt,Hrt] = options.plot3dMethod(xx,yy,f,...
                        options.nlevels,...
                        'LevelList',levelList{i});
            end
            % This piece of code depends on polar
            if strcmp(options.polarPlot,'yes')==1
               xlabel(lab); grid on;
            else
               xlabel(xlab); ylabel(ylab); zlabel(lab);clabel(Crt,Hrt)
            end
        elseif strcmp(strf,'surfc') || ...
               strcmp(strf,'meshc')
            Hrt = options.plot3dMethod(xx,yy,f);
            xlabel(xlab); ylabel(ylab); zlabel(lab)
        elseif strcmp(strf,'surf') || ...
               strcmp(strf,'mesh')
            Hrt = options.plot3dMethod(xx,yy,f);
            xlabel(xlab); ylabel(ylab); zlabel(lab)
        elseif strcmp(strf,'contour3')
            Hrt = options.plot3dMethod(xx,yy,f,options.nlevels);
            xlabel(xlab); ylabel(ylab); zlabel(lab)
        else
            error('PLOT3DSTRUCTURE: Wrong plot3dMethod');
        end
        if ~strcmp(options.labels,'off')
           set(Hrt,'ShowText','on','TextStep',get(Hrt,'LevelStep')*2);% FIXME
        end
        if ~strcmp(options.colormap,'no')
           colormap(options.colormap);
        end
        if strcmp(options.colorbar,'yes')
           colorbar;
        end
        if strcmp(options.gridOn,'yes')
           grid on;
        else
           grid off;
        end
    else
       disp('PLOT3DSTRUCTURE: plot3dMode value is not a valid one')
    end
    title(titletext);
    if ~strcmp(options.prefix,'no')
       name = strcat(options.prefix,'_',var);
       savePlot(gcf,name,fmt);
    end
    ax{i,1} = gca;
    ax{i,2} = gcf;
end
end



if strcmp(options.closePlot,'yes')
   close all
end
if strcmp(options.mode,'thick')
   unsetPlot
end

if nargout==1
   varargout{1} = ax;
end
