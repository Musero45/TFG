function [ax,lx] = plotStabilityEigenvectors(coswmf,AXDS,AYDS,varargin)
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


options  = parseOptions(varargin,@setStabilityPlotOptions);



s            = size(coswmf);
n            = numel(coswmf);

w            = zeros(n,8);

% Organize eigenvectors: w is the matrix of modulus of eigenvectors which
% w(i,j) is the modulus of the i eigevector for the j value of parameter
for i = 1:n
    W        = coswmf{i}.eigW;
    W8       = W(2:end,2:end);
    xdata(i) = coswmf{i}.(char(AXDS.var));
    w(i,:)   = sqrt(sum(abs(W8).^2,2));
end

hgcf             = getCurrentFigureNumber;
figure(hgcf + 1)
hold on;
set(gcf,'Name',strcat('|W_i|'));
for i = 1:8
    plot(xdata,w(:,i),options.mode8liner{i}); hold on;
end
xlabel(AXDS.lab);ylabel('|W_i| [-]');
legend(options.mode8leg,'Location','Best');

% % % %==========================================================================
% % % % Plot eigen vector variation with parameter
% % % % it does make sense only when the number of stability maps is one since
% % % % every stability map figure corresponds to 8/9 autovector series.
% % % if strcmp(plotOptions.plotEigenValues,'yes')
% % % if nsm == 1  
% % %     % Get eigenmodes
% % %     eigW   = swmf.eigW;
% % % 
% % %     for k = 2:ssv
% % %     kfig = k-1;
% % %     figure(hgcf + 1 + kfig)
% % %     hold on
% % %     for i = 1:neq
% % %         b(1,:) = eigW(i,k,:);
% % %         if imag(si(k,:))== 0
% % %             plot(ndV,-sign(b(1,1)).*abs(b),mark{i})
% % %             ylabel('X_i [1/s]')
% % %         else
% % %             plot(ndV,abs(b),mark{i})
% % %             ylabel('|X_i| [1/s]')
% % %         end
% % %     end
% % % 
% % %     grid on
% % %     xlabel('V/(\Omega R) [-]')    
% % %     legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
% % %     if ~strcmp(plotOptions.prefix,'no')
% % %        name = strcat('modeAx',num2str(k));
% % %        savePlot(gcf,name,{'pdf'});
% % %     end
% % %     end
% % % end
% % % end
