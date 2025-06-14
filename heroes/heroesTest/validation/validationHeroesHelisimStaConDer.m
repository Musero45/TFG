function io = validationHeroesHelisimStaConDer(mode)
%% Helicopter Trim and Stabillity Validation
% 
% Stability and Control Derevates from Helisim, for the three different 
% helicopters (Bo105,Lynx and Puma), are in pages 278-292 from [1].
% With that data, we are able to compare each stability and control
% derivate with the results obtained with Heroes.
% 
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
% 

close all
clear all
setPlot;

atm           = getISA;

Bo105         = PadfieldBo105(atm);
Lynx          = rigidLynx(atm);
Puma          = rigidPuma(atm);
he_i          = {Bo105,Lynx,Puma};
HEvar         = {'Bo105','Lynx','Puma'};
Nhe           = length(he_i);

StabilityData_i     = {@HelisimBo105StabilityMatrices,...
                       @HelisimLynxStabilityMatrices,...
                       @HelisimPumaStabilityMatrices};
ControlData_i       = {@HelisimBo105ControlMatrices,...
                       @HelisimLynxControlMatrices,...
                       @HelisimPumaControlMatrices};

options       = setHeroesRigidOptions;

hsl           = 0;
ndHe_i        = rigidHe2ndHe(he_i,atm,hsl);

% The conversion factor from Knots to m/s is defined as K_ms
Kn2ms = 0.514444;
 
% It is defined also a VOR max, in order to set the maximum value for the
% adimensional velocity to be plotted, for both Padfield and Heroes results
% 140 is the mx speed in knots used in Padfield data
Vmax          = 140*Kn2ms;
muWT          = [0; 0; 0];
ndV           = linspace(0.001,Vmax,31);
VORBo105      = ndV./(he_i{1}.mainRotor.R*he_i{1}.mainRotor.Omega);
VORLynx       = ndV./(he_i{2}.mainRotor.R*he_i{2}.mainRotor.Omega);
VORPuma       = ndV./(he_i{3}.mainRotor.R*he_i{3}.mainRotor.Omega);
VOR           = {VORBo105,VORLynx,VORPuma};

fcBo105       = {'VOR',VORBo105,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};

fcLynx        = {'VOR',VORLynx,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};
             
fcPuma        = {'VOR',VORPuma,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};   

FC            = {fcBo105,fcLynx,fcPuma};
ndts          = cell(Nhe,1);
ndSs          = cell(Nhe,1);
Ss            = cell(Nhe,1);
SsStaDer      = cell(Nhe,1);
A2sd_i        = cell(Nhe,1);
SsConDer      = cell(Nhe,1);
B2cd_i        = cell(Nhe,1);
VecErrCD      = zeros(1,24);
VecErrSD      = zeros(1,48);  
MatErrSD      = zeros(7,9,Nhe);
MatErrCD      = zeros(7,5,Nhe);

zvarsSD  = {'Fx_u','Fx_w','Fx_omy','Fx_The',...
            'Fx_v','Fx_omx','Fx_Phi','Fx_omz',...
            'Fz_u','Fz_w','Fz_omy','Fz_The',...
            'Fz_v','Fz_omx','Fz_Phi','Fz_omz',...
            'My_u','My_w','My_omy','My_The',...
            'My_v','My_omx','My_Phi','My_omz',...
            'Fy_u','Fy_w','Fy_omy','Fy_The',...
            'Fy_v','Fy_omx','Fy_Phi','Fy_omz',...
            'Mx_u','Mx_w','Mx_omy','Mx_The',...
            'Mx_v','Mx_omx','Mx_Phi','Mx_omz',...
            'Mz_u','Mz_w','Mz_omy','Mz_The',...
            'Mz_v','Mz_omx','Mz_Phi','Mz_omz'};

azdsSD      =    getaxds(zvarsSD,...
   {'F_{x,u} [kg s^{-1}]','F_{x,w} [kg s^{-1}]',...
    'F_{x,omy} [kg s^{-1}]','F_{x,The} [kg s^{-1}]',...
    'F_{x,v} [kg s^{-1}]','F_{x,omx} [kg s^{-1}]',...
    'F_{x,Phi} [kg s^{-1}]','F_{x,omz} [kg s^{-1}]',...
    'F_{z,u} [kg s^{-1}]','F_{z,w} [kg s^{-1}]',...
    'F_{z,omy} [kg s^{-1}]','F_{z,The} [kg s^{-1}]',...
    'F_{z,v} [kg s^{-1}]','F_{z,omx} [kg s^{-1}]',...
    'F_{z,Phi} [kg s^{-1}]','F_{z,omz} [kg s^{-1}]',...                  
    'M_{y,u} [kg m s^{-1}]','M_{y,w} [kg m s^{-1}]',...
    'M_{y,omy} [kg m s^{-1}]','M_{y,The} [kg m s^{-1}]',...
    'M_{y,v} [kg m s^{-1}]','M_{y,omx} [kg m s^{-1}]',...
    'M_{y,Phi} [kg m s^{-1}]','M_{y,omz} [kg m s^{-1}]',...
    'F_{y,u} [kg s^{-1}]','F_{y,w} [kg s^{-1}]',...
    'F_{y,omy} [kg s^{-1}]','F_{y,The} [kg s^{-1}]',...
    'F_{y,v} [kg s^{-1}]','F_{y,omx} [kg s^{-1}]',...
    'F_{y,Phi} [kg s^{-1}]','F_{y,omz} [kg s^{-1}]',...
    'M_{x,u} [kg m s^{-1}]','M_{x,w} [kg m s^{-1}]',...
    'M_{x,omy} [kg m s^{-1}]','M_{x,The} [kg m s^{-1}]',...
    'M_{x,v} [kg m s^{-1}]','M_{x,omx} [kg m s^{-1}]',...
    'M_{x,Phi} [kg m s^{-1}]','M_{x,omz} [kg m s^{-1}]',...
    'M_{z,u} [kg m s^{-1}]','M_{z,w} [kg m s^{-1}]',...
    'M_{z,omy} [kg m s^{-1}]','M_{z,The} [kg m s^{-1}]',...
    'M_{z,v} [kg m s^{-1}]','M_{z,omx} [kg m s^{-1}]',...
    'M_{z,Phi} [kg m s^{-1}]','M_{z,omz} [kg m s^{-1}]'},...
    [1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,...
     1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1]);  
 
zvarsCD  = {'Fx_t0','Fx_t1S','Fx_t1C','Fx_t0tr',...
            'Fz_t0','Fz_t1S','Fz_t1C','Fz_t0tr',... 
            'My_t0','My_t1S','My_t1C','My_t0tr',...
            'Fy_t0','Fy_t1S','Fy_t1C','Fy_t0tr',...
            'Mx_t0','Mx_t1S','Mx_t1C','Mx_t0tr',...
            'Mz_t0','Mz_t1S','Mz_t1C','Mz_t0tr'};
        
azdsCD   =   getaxds(zvarsCD,...
  {'F_{x,\theta_0} [kg m s^{-2}]','F_{x,\theta_1S} [kg m s^{-2}]',...
   'F_{x,\theta_1C} [kg m s^{-2}]','F_{x,\theta_0tr} [kg m s^{-2}]',...
   'F_{z,\theta_0} [kg m s^{-2}]','F_{z,\theta_1S} [kg m s^{-2}]',...
   'F_{z,\theta_1C} [kg m s^{-2}]','F_{z,\theta_0tr} [kg m s^{-2}]',...
   'M_{y,\theta_0} [kg m^2 s^{-2}]','M_{y,\theta_1S} [kg m^2 s^{-2}]',...
   'M_{y,\theta_1C} [kg m^2 s^{-2}]','M_{y,\theta_0tr} [kg m^2 s^{-2}]',...
   'F_{y,\theta_0} [kg m s^{-2}]','F_{y,\theta_1S} [kg m s^{-2}]',...
   'F_{y,\theta_1C} [kg m s^{-2}]','F_{y,\theta_0tr} [kg m s^{-2}]',...
   'M_{x,\theta_0} [kg m^2 s^{-2}]','M_{x,\theta_1S} [kg m^2 s^{-2}]',...
   'M_{x,\theta_1C} [kg m^2 s^{-2}]','M_{x,\theta_0tr} [kg m^2 s^{-2}]',...
   'M_{z,\theta_0} [kg m^2 s^{-2}]','M_{z,\theta_1S} [kg m^2 s^{-2}]',...
   'M_{z,\theta_1C} [kg m^2 s^{-2}]','M_{z,\theta_0tr} [kg m^2 s^{-2}]'},...
   [1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1]);

% To run this code it is needed a lot of time, thats why it is used the 
% save and load funcion in order to avoid waiting too mucho for it 

for i = 1:Nhe;
%%   To compute the nondimensional trim state just use the function 
%    getNdHeTrimState.                
   ndts{i}        = getNdHeTrimState(ndHe_i{i},muWT,FC{i},options);

%%  Linear Stability analysis
   ndSs{i}        = getndHeLinearStabilityState(ndts{i},muWT,ndHe_i{i},options);
% % % save ndSs_i   
    Ss{i}          = ndHeSs2HeSs(ndSs{i},he_i{i},atm,hsl,options);

    SsStaDer{i}      = Ss{i}.stabilityDerivatives.staDer.AllElements;
    V                = ndV;
    SsStaDer{i}.V    = V;

%% Stability Derivates
%
% Amatrix2StabilityDer it is made of the analisys data 
% from the Padfield pag 278-292. This pages shows the Matrices A of the
% three helicopters for different speeds.
% Matrix A -> Helisim____StabilityMatrices -> function Amatrix2StabilityDer
 
 A2sd_i{i} = Amatrix2StabilityDer(ndHe_i{i},muWT,StabilityData_i{i},options,i);                   

%% This section plot the stability derivates for every speed in m/s 
%  - V -
%  To plot the results of Heroes solution as well as Padfield
%  solution, in order to compare both of them, it is created a cell with
%  two elements, one for each results.
%  Like this we are able to print both results in the same graphic to
%  compare it easily.                   

% % %  axds   = getaxds({'V'},{'V[m/s]'},1);          
% % %  c1        = {SsStaDer{i},A2sd_i{i}};
% % %  plotStabilityDerivatives(c1,axds,[],...
% % %                         'defaultVars',azdsSD,...
% % %                         'plot2dMode','nFigures',...
% % %                         'titleplot',HEvar{i}) 

%%
%   This section is usefull to compare both stability derivates results not 
%   only in graphs, but also with an estimated numerical error.
%   The function used is MycheckError4s
%   The estimation can be done by the standard desviation(std), the mean(mean),
%   or the root mean square(rms).
%   This function gives an output called 'err' that is a structure compound
%   of the different zvars with its relative error. 

% % %  xvar   = 'V';
% % %  [VerrSD.(HEvar{i})] = checkError4s(A2sd_i{i},SsStaDer{i},xvar,'metric',...
% % %                                       'mean','TOL', 1e-10,'zvars',zvarsSD);

%%   Now we plot the Stability derivates refered to the adimensional speed 
%    - V/OmegaR -

SsStaDer{i}.VOR  = VOR{i};  
                    
axds   = getaxds({'VOR'},{'V/(\Omega R) [-]'},1);                      
c2     = {SsStaDer{i},A2sd_i{i}};                                           
plotStabilityDerivatives(c2,axds,{'Heroes','Helisim'},...
                         'defaultVars',azdsSD,...
                         'plot2dMode','nFigures',...
                         'titleplot',HEvar{i});  
                     
%%                     
 xvar    = 'VOR';
[errSD.(HEvar{i})] = checkError4s(A2sd_i{i},SsStaDer{i},xvar,'metric',...
                                    'mean','TOL', 1e-10,'zvars',zvarsSD);

% To represent in a very visual way the relative error of every derivate,
% it is used de pcolor function, to create a color map.
% This colormap has the following structure:
%
%    | Fx_u | Fx_w| Fx_omy|Fx_The | Fx_v|Fx_omx | Fx_Phi | Fx_omz |
%    | Fz_u | Fz_w| Fz_omy|Fz_The | Fz_v|Fz_omx | Fz_Phi | Fz_omz |
%    | My_u | My_w| My_omy|My_The | My_v|My_omx | My_Phi | My_omz |
%    | Fy_u | Fy_w| Fy_omy|Fy_The | Fy_v|Fy_omx | Fy_Phi | Fy_omz |
%    | Mx_u | Mx_w| Mx_omy| Mx_The| Mx_v| Mx_omx| Mx_Phi | Mx_omz |
%    | Mz_u | Mz_w| Mz_omy| Mz_The| Mz_v|Mz_omx | Mz_Phi | Mz_omz | 

    for j = 1:length(zvarsSD); 
        VecErrSD(1,j) = errSD.(HEvar{i}).(zvarsSD{j}) ;
    end
    PreMatErrSD = reshape(VecErrSD,8,6);
    for k = 1:6 ;
      for s = 1:8 ;  
    MatErrSD(k,s,i) = PreMatErrSD(s,k);
      end
    end
  figure;
  h = pcolor(MatErrSD(:,:,i));
  title([HEvar{i},'-StabilityDer']);
  rotate(h,[1,0,0],180);
  colorbar;
  
%% Control Derivates
%
% Bmatrix2ControlDer it is made of the analisys data 
% from the Padfield pag 278-292.This pages shows the Matrix B of the
% three helicopters for different speeds.
% Matrix B -> Helisim____ControlMatrices   -> Bmatrix2ControlDer
 
SsConDer{i}    = Ss{i}.controlDerivatives.conDer.AllElements;
SsConDer{i}.V  = V;

B2cd_i{i} = Bmatrix2ControlDer(ControlData_i{i},i);

%% - V -
% % %  xvar   = 'V';
% % % [VerrCD.(HEvar{i})] = checkError4s(B2cd_i{i},SsConDer{i},xvar,'metric',... 
% % %                                      'mean','TOL', 1e-10,'zvars',zvarsCD);       

%% - V -
% % % axds          = getaxds({'V'},{'V[m/s]'},1);
% % %  d1       = {SsConDer{i},B2cd_i{i}};              
% % % plotControlDerivatives(d1,axds,[],...
% % %                          'defaultVars',azdsCD,...
% % %                          'plot2dMode','nFigures',...
% % %                          'titleplot',HEvar{i});
                     
%% - V/OmegaR -
SsConDer{i}.VOR  = VOR{i};    

axds     = getaxds({'VOR'},{'V/(\Omega R) [-]'},1);                    
d2       = {SsConDer{i},B2cd_i{i}}; 
plotControlDerivatives(d2,axds,{'Heroes','Helisim'},...
                         'defaultVars',azdsCD,...
                         'plot2dMode','nFigures',...
                         'titleplot',HEvar{i});
                     
%% - V/OmegaR -
xvar    = 'VOR';
[errCD.(HEvar{i})] = checkError4s(B2cd_i{i},SsConDer{i},xvar,'metric',... 
                                    'mean','TOL', 1e-10,'zvars',zvarsCD);
                                         
% To represent in a very visual way the relative error of every derivate,
% it is used de pcolor function, to create a color map.
% This colormap has the following structure:
%
%          Fx_t0,  Fx_t1S,  Fx_t1C,  Fx_t0tr
%          Fz_t0,  Fz_t1S,  Fz_t1C,  Fz_t0tr
%          My_t0,  My_t1S,  My_t1C,  My_t0tr
%          Fy_t0,  Fy_t1S,  Fy_t1C,  Fy_t0tr
%          Mx_t0,  Mx_t1S,  Mx_t1C,  Mx_t0tr
%          Mz_t0,  Mz_t1S,  Mz_t1C,  Mz_t0tr 

    for j = 1:length(zvarsCD); 
        VecErrCD(1,j) = errCD.(HEvar{i}).(zvarsCD{j}) ;
    end
    PreMatErrCD = reshape(VecErrCD,4,6);
    for k = 1:6 ;
      for s = 1:4 ;  
    MatErrCD(k,s,i) = PreMatErrCD(s,k);
      end
    end 
  figure;
  h = pcolor(MatErrCD(:,:,i));
  title([HEvar{i},'-ControlDer']);  
  rotate(h,[1,0,0],180);
  colorbar;
    
end

io = 1;
