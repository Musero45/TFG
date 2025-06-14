function io = padfieldTable4_1(mode)
%% padfieldTable4_1
% Trim forces and moments ? Lynx at 80 knots in climbing turn 
% (gammaT = 0.15 rad, turn rate = 0.4 rad/s)
%
% Data taken from reference [1]
% Phi digitize from table 4.1 page 204 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
%
% Author: Francisco J. Ruiz Fernandez
%

close all
clear all
setPlot;

atm           = getISA;
he            = rigidLynx(atm);
Om            = he.mainRotor.Omega;
Rmr           = he.mainRotor.R;
hsl           = 0;
ndHe          = rigidHe2ndHe(he,atm,hsl);

options       = setHeroesRigidOptions;

muWT          = [0; 0; 0];
gammaT        = [0; 0.1; 0.15];
omegaAdzT     = linspace(0.01,0.4,21)./Om;
VOR           = 80.*0.5144444./(Rmr*Om);
FC            = {'omegaAdzT',omegaAdzT,...
                 'betaf0',0,...
                 'gammaT',gammaT,...
                 'VOR',VOR,...
                 'vTOR',0};
             
% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.                         
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);

heStruct = {'weight','mainRotor','fuselage',...
            'leftHTP','rightHTP','verticalFin','tailRotor'};
CF = {'CFx','CFy','CFz'};
CM = {'CMtx','CMty','CMtz'};
FandM = {'Fx','Fy','Fz','Mx','My','Mz'};
Tu=he.characteristic.Tu(hsl);
Tutr=he.characteristic.Tu_tr(hsl);

% table4_1 is a structure that represents the table 4.1 from Padfield. 
% As that table only shows the forces and moments for a certain flight 
% condition (gammaT=0.15, tur rate = 0.4), thats why it is used only the
% (end,:,3) component of the matrices.
%
% The total amount of forces and moments for all the components, unless
% inertial forces, is represented in the structure Totaltable4_1.

 v=zeros(length(heStruct)); 
for r=1:length(FandM);  
  for j=1:length(heStruct);
     if r<=length(CF);       
     TrimForcesMoments.(heStruct{j}).(FandM{r}) = ...
       (ndts.actions.(heStruct{j}).fuselage.(CF{r})).*Tu;
  
     table4_1.(heStruct{j}).(FandM{r}) = ...
       TrimForcesMoments.(heStruct{j}).(FandM{r})(end,:,3); 
     else   
     TrimForcesMoments.(heStruct{j}).(FandM{r}) = ...
        (ndts.actions.(heStruct{j}).fuselage.(CM{r-3})).*Tu.*Rmr;
  
     table4_1.(heStruct{j}).(FandM{r}) = ...
        TrimForcesMoments.(heStruct{j}).(FandM{r})(end,:,3); 
     end
  end
   
  for k=1:length(heStruct);
 v(k) = table4_1.(heStruct{k}).(FandM{r});
  end
  Totaltable4_1.(FandM{r})= sum(v);
end

io = 1;
