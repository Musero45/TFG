function [HelicopteroModelo]=Helimodel
%OJO, mejor no definir nada aqui, de clara a no perder el control de las variables.

%Carga de las variables a estructurar:
%eval('parametrosalberto');
%eval('parametrosalbertonuevo');
%eval('parametroslibro');
eval('parametrosBo105');
%eval('parametroslibrojuego');
%eval('parametrosalvaro');
%eval('parametroselena');
%eval('parametrossergio');

eval('Configurador_Analisis');

%4º Nivel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Establecimiento de polar del RP

[alphaSN,clop,cdop,kmax,alphaClRPdat,ClRPdat] = AirfoilRP('cl');
[alphaSN,clop,cdop,kmax,alphaCdRPdat,CdRPdat] = AirfoilRP('cd');
[alphaSN,clop,cdop,kmax,alphaCmRPdat,CmRPdat] = AirfoilRP('cm');

%   Establecimiento de polar del RA

[alphaSN,clop,cdop,kmax,alphaClRAdat,ClRAdat] = AirfoilRA('cl');
[alphaSN,clop,cdop,kmax,alphaCdRAdat,CdRAdat] = AirfoilRA('cd');
[alphaSN,clop,cdop,kmax,alphaCmRAdat,CmRAdat] = AirfoilRA('cm');

%   Establecimiento de polar del EH

[alphaSN,clop,cdop,kmax,alphaClEHdat,ClEHdat] = AirfoilEH('cl');
[alphaSN,clop,cdop,kmax,alphaCdEHdat,CdEHdat] = AirfoilEH('cd');
[alphaSN,clop,cdop,kmax,alphaCmEHdat,CmEHdat] = AirfoilEH('cm');

%   Establecimiento de polar del EV

[alphaSN,clop,cdop,kmax,alphaClEVdat,ClEVdat] = AirfoilEV('cl');
[alphaSN,clop,cdop,kmax,alphaCdEVdat,CdEVdat] = AirfoilEV('cd');
[alphaSN,clop,cdop,kmax,alphaCmEVdat,CmEVdat] = AirfoilEV('cm');

%   Estructuras de datos aerodinamicos

AirfdataRP = struct('alphaClRPdat',alphaClRPdat,'ClRPdat',ClRPdat,'alphaCdRPdat',alphaCdRPdat,'CdRPdat',CdRPdat,...
    'alphaCmRPdat',alphaCmRPdat,'CmRPdat',CmRPdat);

AirfdataRA = struct('alphaClRAdat',alphaClRAdat,'ClRAdat',ClRAdat,'alphaCdRAdat',alphaCdRAdat,'CdRAdat',CdRAdat,...
    'alphaCmRAdat',alphaCmRAdat,'CmRAdat',CmRAdat);

AirfdataEH = struct('alphaClEHdat',alphaClEHdat,'ClEHdat',ClEHdat,'alphaCdEHdat',alphaCdEHdat,'CdEHdat',CdEHdat,...
    'alphaCmEHdat',alphaCmEHdat,'CmEHdat',CmEHdat);

AirfdataEV = struct('alphaClEVdat',alphaClEVdat,'ClEVdat',ClEVdat,'alphaCdEVdat',alphaCdEVdat,'CdEVdat',CdEVdat,...
    'alphaCmEVdat',alphaCmEVdat,'CmEVdat',CmEVdat);


PerfilHorizontal = struct('AirfdataEH',AirfdataEH,'cla',[],'delta0',[],'delta1',[],'delta2',[],'cmo',[]);
PerfilVertical = struct('AirfdataEV',AirfdataEV,'cla',[],'delta0',[],'delta1',[],'delta2',[],'cmo',[]);

PosicionRotor = struct('h',h_rp,'x',x,'y',y,'epsilon_x',epsilon_x,'epsilon_y',epsilon_y);
PosicionRotorAntipar = struct('lRAH',lRAH,'lRAV',lRAV,'dRA',dRA,'epsilon_ra',epsilon_ra);
PosicionEH = struct('lEHH',lEHH,'lEHV',lEHV,'dEHI',dEHI,'dEHD',dEHD);
PosicionEV = struct('lEVH',lEVH,'lEVV',lEVV);

%3er Nivel

PerfilRotor=struct('AirfdataRP',AirfdataRP,'cla',[],'delta0',[],'delta1',[],'delta2',[],'cmo',[]);

PerfilAntipar=struct('AirfdataRA',AirfdataRA,'cla',[],'delta0',[],'delta1',[],'delta2',[],'cmo',[]);

Posicionamiento=struct('R',PosicionRotor,'RA',PosicionRotorAntipar,'EH',PosicionEH,'EV',PosicionEV,'XCG',XCG,'YCG',YCG,'ZCG',ZCG);

EstabilizadorHorizontalDerecho=struct('Perfil',PerfilHorizontal,'SDerecho',SDerecho,'c',c_eh,'theta_ehd',theta_ehd);
EstabilizadorHorizontalIzquierdo=struct('Perfil',PerfilHorizontal,'SIzquierdo',SIzquierdo,'c',c_eh,'theta_ehi',theta_ehi);
EstabilizadorVertical=struct('Perfil',PerfilVertical,'SVertical',SVertical,'c',c_ev,'theta_ev',theta_ev);


%2º nivel, Estructuras Pertenecientes al 1er Nivel
RotorPrincipal=struct('Perfil',PerfilRotor,'Omega',OmegaRotor,'b',b_rp,'R',R_rp,'e',e_rp,'c',c_rp,'Ip',Ip,'k_beta',k_beta,'Mp',Mp,'xGB',xGB,'theta1',theta1);
RotorAntipar=struct('Perfil',PerfilAntipar,'Omega',OmegaAntipar,'b',b_ra,'R',R_ra,'e',e_ra,'c',c_ra,'theta1',theta1_ra);
Estabilizadores=struct('EHD',EstabilizadorHorizontalDerecho,'EHI',EstabilizadorHorizontalIzquierdo,'EV',EstabilizadorVertical);
Fuselaje = struct('FactorAmplifi',kf,'ModeloAcciones',FusAcc,'Pos',Posicionamiento,'SP',SP,'SS',SS,...
    'Cd_x',[],'Cd_y',[],'Cd_z',[],'Cm_x',[],'Cm_y',[],'Cm_z',[]);
Motor=struct('Omega',OmegaMotor,'PMTO',PMTO,'PMC',PMC);

%1er Nivel, Estructura final

% ModeloAcciones = 'ASE';
% ModeloVelind = 'ModificadaCorregida';

HelicopteroModelo = struct('Analisis',Analisis,'RP',RotorPrincipal,'RA',RotorAntipar,'E',Estabilizadores,...
    'F',Fuselaje,'M',Motor,'altura',altura,'peso',PESO_referencia);

end