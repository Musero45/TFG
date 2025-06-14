function [WHATS] = WHATS
% QFD matrix performances evaluated for the customer

%% WHAT's
%Customer Weights QFD, QFD activation, OEC activation
%Customer tarjet value, Analysis direction, Customer importance
%What's (name,unit,label,datatick,legend,...
%   functionQFD,modeltypeQFD,activeQFD,functionOEC,modeltypeOEC,activeOEC,...
%   tarjetvalue,direction,Weight)

%% %%%%%%%%%%%%%
% PERFORMANCES %
%%%%%%%%%%%%%%%%
% PL
PLW = 4; activeQFD = 'yes'; activeOEC = 'yes';
tarjetPL = 630.0*9.81; direct = @bestFIX;  
perf(1) = getWHAT('{\itPL_{MFW}}','[N]','PL','PL','Carga de pago',...
    @qfdPL,'energy',activeQFD,@oecPL,'energy',activeOEC,tarjetPL,direct,PLW);

% Range
RangeW = 4; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetRange = 515000.0; direct = @bestFIX;
perf(2) = getWHAT('{\itR_{max}}','[m]','Range','R','Alcance',...
    @qfdRange,'energy',activeQFD,@oecRange,'energy',activeOEC,tarjetRange,direct,RangeW);

% Endurance
EnduranceW = 4; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetEndurance = 3*3600.0; direct = @bestFIX;     
perf(3) = getWHAT('{\itE_{max}}','[s]','Endurance','E','Autonomía',...
    @qfdEndurance,'energy',activeQFD,@oecEndurance,'energy',activeOEC,tarjetEndurance,direct,EnduranceW);

% Max speed
VmW = 4; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetVm = 67.5; direct = @bestFIX;     
perf(4) = getWHAT('{\itV_{m}}','[m/s]','Vm','Vm','Velocidad máxima',...
    @qfdVm,'energy',activeQFD,@oecVm,'energy',activeOEC,tarjetVm,direct,VmW);

% Ceiling
CeilingW = 4; activeQFD = 'no'; activeOEC = 'no';  
tarjetCeiling = 0.0; direct = @bestMAX;    
perf(5) = getWHAT('{\itCeiling}','[m]','Ceiling','C','Techo',...
    @qfdCeilingOGE,'energy',activeQFD,@oecCeilingOGE,'energy',activeOEC,tarjetCeiling,direct,CeilingW);

%% %%%%%%%%
% MISSION %
%%%%%%%%%%%
% Mission fuel
MissionFuelW = 4; activeQFD = 'yes'; activeOEC = 'yes'; % Mission activeOEC must be 'yes'
tarjetMissionFuel = 'none'; direct = @bestMIN;    
miss(1) = getWHAT('{\itM_{F}}','[kg]','MissionFuel','MF','Combustible misión',...
    @qfdMissionFuel,'energy',activeQFD,@oecMissionFuel,'energy',activeOEC,tarjetMissionFuel,direct,MissionFuelW);

%% %%%%%%%
% SAFETY %
%%%%%%%%%%
%Autorrotation
AutorrotationW = 5; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetAutorrotation = 'none'; direct = @bestMAX;    
secu(1) = getWHAT('{\it\gamma_{T_{aut.}}}','[rad]','Autorrotation','Au','Autorrotación',...
    @qfdAutorrotation,'energy',activeQFD,@oecAutorrotation,'energy',activeOEC,tarjetAutorrotation,direct,AutorrotationW);

%% %%%%%%%
%  COST  %
%%%%%%%%%%
% Adquisition cost
CACW = 3; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetCAC = 'none'; direct = @bestMIN;    
cost(1) = getWHAT('{\itC_{AC}}','[$]','CAC','CA','Coste adquisición',...
    @qfdCAC,'dimensioning',activeQFD,@oecCAC,'dimensioning',activeOEC,tarjetCAC,direct,CACW);

% Operation cost
COPW = 3; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetCOP = 'none'; direct = @bestMIN;    
cost(2) = getWHAT('{\itC_{OP}}','[$/yr]','COP','CO','Coste operación',...
    @qfdCOP,'dimensioning',activeQFD,@oecCOP,'dimensioning',activeOEC,tarjetCOP,direct,COPW);

%% %%%%%%%%%%%%%%%%%%%%%%%%
% ADDITIONAL PERFORMANCES %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hover efficiency
HoverEfficiencyW = 2; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetHoverEfficiency = 'none'; direct = @bestMAX;    
addP(1) = getWHAT('{\itFM}','[-]','HoverEfficiency','FM','Eficiencia VPF',...
    @qfdHoverEfficiency,'dimensioning',activeQFD,@oecHoverEfficiency,'dimensioning',activeOEC,tarjetHoverEfficiency,direct,HoverEfficiencyW);

% Stability convergence
StabilityConvergenceW = 1; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetStabilityConvergence = 'none'; direct = @bestMIN;      
addP(2) = getWHAT('{\it1/\Deltat_{1/2}}','[s-1]','StabilityConvergence','SC','Estabilidad convergencia',...
    @qfdStabilityConvergence,'rigid',activeQFD,@oecStabilityConvergence,'rigid',activeOEC,tarjetStabilityConvergence,direct,StabilityConvergenceW);

% Stability oscillation
StabilityOscillationW = 1; activeQFD = 'yes'; activeOEC = 'yes';  
tarjetStabilityOscillation = 'none'; direct = @bestMIN;    
addP(3) = getWHAT('{\it1/T}','[s-1]','StabilityOscillation','SO','Estabilidad oscilación',...
    @qfdStabilityOscillation,'rigid',activeQFD,@oecStabilityOscillation,'rigid',activeOEC,tarjetStabilityOscillation,direct,StabilityOscillationW);


%% 
% Load cathegories
Cat{1} = getCat('Performances',perf);
Cat{2} = getCat('Mission',miss);
Cat{3} = getCat('Security',secu);
Cat{4} = getCat('Costs',cost);
Cat{5} = getCat('AdditionalPrestations',addP);
                    
% Configure WHATS
Whats = getWHATS('Whats',Cat);
WHATS = addNumberItem(Whats);

end