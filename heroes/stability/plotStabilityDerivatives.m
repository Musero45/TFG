function varargout = plotStabilityDerivatives(X,AXDS,AYDS,varargin)

options  = parseOptions(varargin,@setHeroesPlotOptions);



% if ~isstruct(X)
%    error('X: First input argument should be a single structure')
% end

if strcmp(options.defaultVars,'yes')==1
  zvars   = setStabilityDerivativesVars;
else
  zvars   = options.defaultVars;
end

ax = plotStructureNdMatrix(X,AXDS,AYDS,zvars,options);
if nargout == 1
   varargout{1} = ax;
end

function A = setStabilityDerivativesVars

var = {
'Fx_u'
'Fx_w'
'Fx_omy'
'Fx_The'
'Fx_v'
'Fx_omx'
'Fx_Phi'
'Fx_omz'
'Fx_Psi'
'Fz_u'
'Fz_w'
'Fz_omy'
'Fz_The'
'Fz_v'
'Fz_omx'
'Fz_Phi'
'Fz_omz'
'Fz_Psi'
'My_u'
'My_w'
'My_omy'
'My_The'
'My_v'
'My_omx'
'My_Phi'
'My_omz'
'My_Psi'
'Fy_u'
'Fy_w'
'Fy_omy'
'Fy_The'
'Fy_v'
'Fy_omx'
'Fy_Phi'
'Fy_omz'
'Fy_Psi'
'Mx_u'
'Mx_w'
'Mx_omy'
'Mx_The'
'Mx_v'
'Mx_omx'
'Mx_Phi'
'Mx_omz'
'Mx_Psi'
'Mz_u'
'Mz_w'
'Mz_omy'
'Mz_The'
'Mz_v'
'Mz_omx'
'Mz_Phi'
'Mz_omz'
'Mz_Psi'
};

lab = {
'F_{x,u} [kg s^{-1}]'
'F_{x,w} [kg s^{-1}]'
'F_{x,\omega_y} [kg m s^{-1}]'
'F_{x,\Theta} [kg m s^{-2}]'
'F_{x,v} [kg s^{-1}]'
'F_{x,\omega_x} [kg m s^{-1}]'
'F_{x,\Phi} [kg m s^{-2}]'
'F_{x,\omega_z} [kg m s^{-1}]' 
'F_{x,\Psi} [kg m s^{-2}]'
'F_{z,u} [kg s^{-1}]'
'F_{z,w} [kg s^{-1}]'
'F_{z,\omega_y} [kg m s^{-1}]'
'F_{z,\Theta} [kg m s^{-2}]'
'F_{z,v} [kg s^{-1}]'
'F_{z,\omega_x} [kg m s^{-1}]'
'F_{z,\Phi} [kg m s^{-2}]'
'F_{z,\omega_z} [kg m s^{-1}]' 
'F_{z,\Psi} [kg m s^{-2}]'
'M_{y,u} [kg m s^{-1}]'
'M_{y,w} [kg m s^{-1}]'
'M_{y,\omega_y} [kg m^2 s^{-1}]'
'M_{y,\Theta} [kg m^2 s^{-2}]'
'M_{y,v} [kg m s^{-1}]'
'M_{y,\omega_x} [kg m^2 s^{-1}]'
'M_{y,\Phi} [kg m^2 s^{-2}]'
'M_{y,\omega_z} [kg m^2 s^{-1}]' 
'M_{y,\Psi} [kg m^2 s^{-2}]'
'F_{y,u} [kg s^{-1}]'
'F_{y,w} [kg s^{-1}]'
'F_{y,\omega_y} [kg m s^{-1}]'
'F_{y,\Theta} [kg m s^{-2}]'
'F_{y,v} [kg s^{-1}]'
'F_{y,\omega_x} [kg m s^{-1}]'
'F_{y,\Phi} [kg m s^{-2}]'
'F_{y,\omega_z} [kg m s^{-1}]' 
'F_{y,\Psi} [kg m s^{-2}]'
'M_{x,u} [kg m s^{-1}]'
'M_{x,w} [kg m s^{-1}]'
'M_{x,\omega_y} [kg m^2 s^{-1}]'
'M_{x,\Theta} [kg m^2 s^{-2}]'
'M_{x,v} [kg m s^{-1}]'
'M_{x,\omega_x} [kg m^2 s^{-1}]'
'M_{x,\Phi} [kg m^2 s^{-2}]'
'M_{x,\omega_z} [kg m^2 s^{-1}]' 
'M_{x,\Psi} [kg m^2 s^{-2}]'
'M_{z,u} [kg m s^{-1}]'
'M_{z,w} [kg m s^{-1}]'
'M_{z,\omega_y} [kg m^2 s^{-1}]'
'M_{z,\Theta} [kg m^2 s^{-2}]'
'M_{z,v} [kg m s^{-1}]'
'M_{z,\omega_x} [kg m^2 s^{-1}]'
'M_{z,\Phi} [kg m^2 s^{-2}]'
'M_{z,\omega_z} [kg m^2 s^{-1}]' 
'M_{z,\Psi} [kg m^2 s^{-2}]'
};
    
unit =     ones(1,54);

A = getaxds(var,lab,unit);

% % % % % % % function plotStabilityDerivatives(sS,legend,varargin)
% % % % % % % % % % % % % % % % if length(varargin)==1 
% % % % % % % % % % % % % % % %    while iscell(varargin) && length(varargin)==1
% % % % % % % % % % % % % % % %       varargin = varargin{1};
% % % % % % % % % % % % % % % %    end
% % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % sS  = output2cellOfStructures(sS);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % plotOpt = parseOptions(varargin,@setHeroesPlotOptions);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % axesData.xvar = 'mux';
% % % % % % % % % % % % % % % % axesData.xlab = 'V/(\Omega R) [-]';
% % % % % % % % % % % % % % % % axesData.xunit = 1;
% % % % % % % % % % % % % % % % axesData.yvars = {'Xu' 'Xw' 'Xq' 'Xv' 'Xp' 'Xr' ...
% % % % % % % % % % % % % % % %                   'Zu' 'Zw' 'Zq' 'Zv' 'Zp' 'Zr' ...
% % % % % % % % % % % % % % % %                   'Mu' 'Mw' 'Mq' 'Mv' 'Mp' 'Mr' ...
% % % % % % % % % % % % % % % %                   'Yu' 'Yw' 'Yq' 'Yv' 'Yp' 'Yr' ...
% % % % % % % % % % % % % % % %                   'Lu' 'Lw' 'Lq' 'Lv' 'Lp' 'Lr' ...
% % % % % % % % % % % % % % % %                   'Nu' 'Nw' 'Nq' 'Nv' 'Np' 'Nr' ...
% % % % % % % % % % % % % % % %                   };
% % % % % % % % % % % % % % % % axesData.ylabs = {'C_{x,\mu_u} [-]' 'C_{x,\mu_w} [-]' 'C_{x,\omega_y}-\mu_{we} [-]' 'C_{x,\mu_v} [-]' 'C_{x,\omega_x} [-]' 'C_{x,\omega_z}-\mu_{ve} [-]' ...
% % % % % % % % % % % % % % % %                   'C_{z,\mu_u} [-]' 'C_{z,\mu_w} [-]' 'C_{z,\omega_y}-\mu_{ue} [-]' 'C_{z,\mu_v} [-]' 'C_{z,\omega_x}-\mu_{ve} [-]' 'C_{z,\omega_z} [-]' ...
% % % % % % % % % % % % % % % %                   'C''_{My,\mu_u} [-]' 'C''_{My,\mu_w} [-]' 'C''_{My,\omega_y} [-]' 'C''_{My,\mu_v} [-]' 'C''_{My,\omega_x} [-]' 'C''_{My,\omega_z} [-]' ...
% % % % % % % % % % % % % % % %                   'C_{y,\mu_u} [-]' 'C_{y,\mu_w} [-]' 'C_{y,\omega_y} [-]' 'C_{y,\mu_v} [-]' 'C_{y,\omega_x}-\mu_{we} [-]' 'C_{y,\omega_z}-\mu_{ue} [-]' ...
% % % % % % % % % % % % % % % %                   'C''_{Mx,\mu_u} [-]' 'C''_{Mx,\mu_w} [-]' 'C''_{Mx,\omega_y} [-]' 'C''_{Mx,\mu_v} [-]' 'C''_{Mx,\omega_x} [-]' 'C''_{Mx,\omega_z} [-]' ...
% % % % % % % % % % % % % % % %                   'C''_{Mz,\mu_u} [-]' 'C''_{Mz,\mu_w} [-]' 'C''_{Mz,\omega_y} [-]' 'C''_{Mz,\mu_v} [-]' 'C''_{Mz,\omega_x} [-]' 'C''_{Mz,\omega_z} [-]' ...
% % % % % % % % % % % % % % % %                   };
% % % % % % % % % % % % % % % %               
% % % % % % % % % % % % % % % % axesData.yunits = [1 1 1 1 1 1 ...
% % % % % % % % % % % % % % % %                    1 1 1 1 1 1 ...
% % % % % % % % % % % % % % % %                    1 1 1 1 1 1 ...
% % % % % % % % % % % % % % % %                    1 1 1 1 1 1 ...
% % % % % % % % % % % % % % % %                    1 1 1 1 1 1 ...
% % % % % % % % % % % % % % % %                    1 1 1 1 1 1 ...
% % % % % % % % % % % % % % % %                    ];
% % % % % % % % % % % % % % % %          
% % % % % % % % % % % % % % % % % axesData.ylabs = {'C_{x,\mu_u} [s^{-1}]' 'C_{x,\mu_w} [s^{-1}]' 'C_{x,\omega_y} [m?s^{-1}]' 'C_{x,\mu_v} [s^{-1}]' 'C_{x,\omega_x} [m?s^{-1}]' 'C_{x,\omega_z} [m?s^{-1}]' ...
% % % % % % % % % % % % % % % % %                   'C_{z,\mu_u} [s^{-1}]' 'C_{z,\mu_w} [s^{-1}]' 'C_{z,\omega_y} [m?s^{-1}]' 'C_{z,\mu_v} [s^{-1}]' 'C_{z,\omega_x} [m?s^{-1}]' 'C_{z,\omega_z} [m?s^{-1}]' ...
% % % % % % % % % % % % % % % % %                   'C_{My,\mu_u} [(m?s)^{-1}]' 'C_{My,\mu_w} [(m?s)^{-1}]' 'C_{My,\omega_y} [s^{-1}]' 'C_{My,\mu_v} [(m?s)^{-1}]' 'C_{My,\omega_x} [s^{-1}]' 'C_{My,\omega_z} [s^{-1}]' ...
% % % % % % % % % % % % % % % % %                   'C_{y,\mu_u} [s^{-1}]' 'C_{y,\mu_w} [s^{-1}]' 'C_{y,\omega_y} [m?s^{-1}]' 'C_{y,\mu_v} [s^{-1}]' 'C_{y,\omega_x} [m?s^{-1}]' 'C_{y,\omega_z} [m?s^{-1}]' ...
% % % % % % % % % % % % % % % % %                   'C_{Mx,\mu_u} [(m?s)^{-1}]' 'C_{Mx,\mu_w} [(m?s)^{-1}]' 'C_{Mx,\omega_y} [s^{-1}]' 'C_{Mx,\mu_v} [(m?s)^{-1}]' 'C_{Mx,\omega_x} [s^{-1}]' 'C_{Mx,\omega_z} [s^{-1}]' ...
% % % % % % % % % % % % % % % % %                   'C_{Mz,\mu_u} [(m?s)^{-1}]' 'C_{Mz,\mu_w} [(m?s)^{-1}]' 'C_{Mz,\omega_y} [s^{-1}]' 'C_{Mz,\mu_v} [(m?s)^{-1}]' 'C_{Mz,\omega_x} [s^{-1}]' 'C_{Mz,\omega_z} [s^{-1}]' ...
% % % % % % % % % % % % % % % % %                   };
% % % % % % % % % % % % % % % % %               
% % % % % % % % % % % % % % % % % axesData.yunits = [O O OR O OR OR ...
% % % % % % % % % % % % % % % % %                    O O OR O OR OR ...
% % % % % % % % % % % % % % % % %                    RO RO O RO O O ...
% % % % % % % % % % % % % % % % %                    O O OR O OR OR ...
% % % % % % % % % % % % % % % % %                    RO RO O RO O O ...
% % % % % % % % % % % % % % % % %                    RO RO O RO O O ...
% % % % % % % % % % % % % % % % %                    ];
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % plotCellOfStructures(sS,axesData,legend,plotOpt);