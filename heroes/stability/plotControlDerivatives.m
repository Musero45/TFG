function varargout = plotControlDerivatives(X,AXDS,AYDS,varargin)

options  = parseOptions(varargin,@setHeroesPlotOptions);



% if ~isstruct(X)
%    error('X: First input argument should be a single structure')
% end

if strcmp(options.defaultVars,'yes')==1
  zvars   = setControlDerivativesVars;
else
  zvars   = options.defaultVars;
end

ax = plotStructureNdMatrix(X,AXDS,AYDS,zvars,options);
if nargout == 1
   varargout{1} = ax;
end


function A = setControlDerivativesVars

var = {
'Fx_t0'
'Fx_t1S'
'Fx_t1C'
'Fx_t0tr'
'Fz_t0'
'Fz_t1S'
'Fz_t1C'
'Fz_t0tr'
'My_t0'
'My_t1S'
'My_t1C'
'My_t0tr'
'Fy_t0'
'Fy_t1S'
'Fy_t1C'
'Fy_t0tr'
'Mx_t0'
'Mx_t1S'
'Mx_t1C'
'Mx_t0tr'
'Mz_t0'
'Mz_t1S'
'Mz_t1C'
'Mz_t0tr'
};

lab = {
'F_{x,\theta_0} [kg m s^{-2}]'
'F_{x,\theta_{1S}} [kg m s^{-2}]'
'F_{x,\theta_{1C}} [kg m s^{-2}]'
'F_{x,\theta_{0,tr}} [kg m s^{-2}]'
'F_{z,\theta_0} [kg m s^{-2}]'
'F_{z,\theta_{1S}} [kg m s^{-2}]'
'F_{z,\theta_{1C}} [kg m s^{-2}]'
'F_{z,\theta_{0,tr}} [kg m s^{-2}]'
'M_{y,\theta_0} [kg m^2 s^{-2}]'
'M_{y,\theta_{1S}} [kg m^2 s^{-2}]'
'M_{y,\theta_{1C}} [kg m^2 s^{-2}]'
'M_{y,\theta_{0,tr}} [kg m^2 s^{-2}]'
'F_{y,\theta_0} [kg m s^{-2}]'
'F_{y,\theta_{1S}} [kg m s^{-2}]'
'F_{y,\theta_{1C}} [kg m s^{-2}]'
'F_{y,\theta_{0,tr}} [kg m s^{-2}]'
'M_{x,\theta_0} [kg m^2 s^{-2}]'
'M_{x,\theta_{1S}} [kg m^2 s^{-2}]'
'M_{x,\theta_{1C}} [kg m^2 s^{-2}]'
'M_{x,\theta_{0,tr}} [kg m^2 s^{-2}]'
'M_{z,\theta_0} [kg m^2 s^{-2}]'
'M_{z,\theta_{1S}} [kg m^2 s^{-2}]'
'M_{z,\theta_{1C}} [kg m^2 s^{-2}]'
'M_{z,\theta_{0,tr}} [kg m^2 s^{-2}]'
};
    
unit =     ones(1,24);

A = getaxds(var,lab,unit);







% % % % % % % % % % % % % % % % % % function plotControlDerivatives(sS,legend,varargin)
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % if length(varargin)==1 
% % % % % % % % % % % % % % % % % %    while iscell(varargin) && length(varargin)==1
% % % % % % % % % % % % % % % % % %       varargin = varargin{1};
% % % % % % % % % % % % % % % % % %    end
% % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % sS  = output2cellOfStructures(sS);
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % plotOpt = parseOptions(varargin,@setHeroesPlotOptions);
% % % % % % % % % % % % % % % % % % plotOpt.mode = 'thick';
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % axesData.xvar = 'mux';
% % % % % % % % % % % % % % % % % % axesData.xlab = 'V/(\Omega?R) [-]';
% % % % % % % % % % % % % % % % % % axesData.xunit = 1;
% % % % % % % % % % % % % % % % % % axesData.yvars = {'Xt0' 'Xt1C' 'Xt1S' 'Xt0T'...
% % % % % % % % % % % % % % % % % %                   'Zt0' 'Zt1C' 'Zt1S' 'Zt0T'...
% % % % % % % % % % % % % % % % % %                   'Mt0' 'Mt1C' 'Mt1S' 'Mt0T'...
% % % % % % % % % % % % % % % % % %                   'Yt0' 'Yt1C' 'Yt1S' 'Yt0T'...
% % % % % % % % % % % % % % % % % %                   'Lt0' 'Lt1C' 'Lt1S' 'Lt0T'...
% % % % % % % % % % % % % % % % % %                   'Nt0' 'Nt1C' 'Nt1S' 'Nt0T'...
% % % % % % % % % % % % % % % % % %                   };
% % % % % % % % % % % % % % % % % % axesData.ylabs = {'C_{x,{\theta_0}} [-]' 'C_{x,{\theta_{1C}}} [-]' 'C_{x,{\theta_{1S}}} [-]' 'C_{x,{\theta_{0T}}} [-]'...
% % % % % % % % % % % % % % % % % %                   'C_{z,{\theta_0}} [-]' 'C_{z,{\theta_{1C}}} [-]' 'C_{z,{\theta_{1S}}} [-]' 'C_{z,{\theta_{0T}}} [-]'...
% % % % % % % % % % % % % % % % % %                   'C''_{My,{\theta_0}} [-]' 'C''_{My,{\theta_{1C}}} [-]' 'C''_{My,{\theta_{1S}}} [-]' 'C''_{My,{\theta_{0T}}} [-]'...
% % % % % % % % % % % % % % % % % %                   'C_{y,{\theta_0}} [-]' 'C_{y,{\theta_{1C}}} [-]' 'C_{y,{\theta_{1S}}} [-]' 'C_{y,{\theta_{0T}}} [-]'...
% % % % % % % % % % % % % % % % % %                   'C''_{Mx,{\theta_0}} [-]' 'C''_{Mx,{\theta_{1C}}} [-]' 'C''_{Mx,{\theta_{1S}}} [-]' 'C''_{Mx,{\theta_{0T}}} [-]'...
% % % % % % % % % % % % % % % % % %                   'C''_{Mz,{\theta_0}} [-]' 'C''_{Mz,{\theta_{1C}}} [-]' 'C''_{Mz,{\theta_{1S}}} [-]' 'C''_{Mz,{\theta_{0T}}} [-]'...
% % % % % % % % % % % % % % % % % %                   };
% % % % % % % % % % % % % % % % % %               
% % % % % % % % % % % % % % % % % % axesData.yunits = [1 1 1 1 ...
% % % % % % % % % % % % % % % % % %                    1 1 1 1 ...
% % % % % % % % % % % % % % % % % %                    1 1 1 1 ...
% % % % % % % % % % % % % % % % % %                    1 1 1 1 ...
% % % % % % % % % % % % % % % % % %                    1 1 1 1 ...
% % % % % % % % % % % % % % % % % %                    1 1 1 1 ...
% % % % % % % % % % % % % % % % % %                    ];
% % % % % % % % % % % % % % % % % %                
% % % % % % % % % % % % % % % % % % % axesData.ylabs = {'C_{x,{\theta_0}} [m?s^{-2}]' 'C_{x,{\theta_{1C}}} [m?s^{-2}]' 'C_{x,{\theta_{1S}}} [m?s^{-2}]' 'C_{x,{\theta_{0T}}} [m?s^{-2}]'...
% % % % % % % % % % % % % % % % % % %                   'C_{z,{\theta_0}} [m?s^{-2}]' 'C_{z,{\theta_{1C}}} [m?s^{-2}]' 'C_{z,{\theta_{1S}}} [m?s^{-2}]' 'C_{z,{\theta_{0T}}} [m?s^{-2}]'...
% % % % % % % % % % % % % % % % % % %                   'C^?_{My,{\theta_0}} [s^{-2}]' 'C^?_{My,{\theta_{1C}}} [s^{-2}]' 'C^?_{My,{\theta_{1S}}} [s^{-2}]' 'C^?_{My,{\theta_{0T}}} [s^{-2}]'...
% % % % % % % % % % % % % % % % % % %                   'C_{y,{\theta_0}} [m?s^{-2}]' 'C_{y,{\theta_{1C}}} [m?s^{-2}]' 'C_{y,{\theta_{1S}}} [m?s^{-2}]' 'C_{y,{\theta_{0T}}} [m?s^{-2}]'...
% % % % % % % % % % % % % % % % % % %                   'C^?_{Mx,{\theta_0}} [s^{-2}]' 'C^?_{Mx,{\theta_{1C}}} [s^{-2}]' 'C^?_{Mx,{\theta_{1S}}} [s^{-2}]' 'C^?_{Mx,{\theta_{0T}}} [s^{-2}]'...
% % % % % % % % % % % % % % % % % % %                   'C^?_{Mz,{\theta_0}} [s^{-2}]' 'C^?_{Mz,{\theta_{1C}}} [s^{-2}]' 'C^?_{Mz,{\theta_{1S}}} [s^{-2}]' 'C^?_{Mz,{\theta_{0T}}} [s^{-2}]'...
% % % % % % % % % % % % % % % % % % %                   };
% % % % % % % % % % % % % % % % % % % axesData.yunits = [O2R O2R O2R O2R ...
% % % % % % % % % % % % % % % % % % %                    O2R O2R O2R O2R ...
% % % % % % % % % % % % % % % % % % %                    O2 O2 O2 O2 ...
% % % % % % % % % % % % % % % % % % %                    O2R O2R O2R O2R ...
% % % % % % % % % % % % % % % % % % %                    O2 O2 O2 O2 ...
% % % % % % % % % % % % % % % % % % %                    O2 O2 O2 O2 ...
% % % % % % % % % % % % % % % % % % %                    ];
% % % % % % % % % % % % % % % % % %                
% % % % % % % % % % % % % % % % % % plotCellOfStructures(sS,axesData,legend,plotOpt);