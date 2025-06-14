function newhe = getUpdatedInertiaHe(he,atm,Mpl,Ipl,OfGPL,eulerPl)

% nI = getNewInertia(he,atm,Mpl,Ipl,OfGPL,eulerPl) generates a helicopter newhe with
% updated inertia and geometry field after adding a payload to the helicopter he. 
% The payload has mass Mpl and Inertia tensor Ipl defined with respect to payload body axes 
% with origin in the payload center of mass GPL. The payload is located by the
% vector OfGPL which positions the payload center of mass with respect to
% the helicopter fuselage reference point Of. OfGPL = [oxPl,oyPl,ozPl] is expressed by its
% components in the helicopter body axis. The orientation of the payload
% inside the helicopter is defined by the three Euler angles eulerPl =
% [PsiPl,ThetaPl,PhiPl] that position the body Pl reference system [Opl;xPl,yPl,zPl] 
% with respect to the helicopter body reference system [Of;x,y,z].
%
% This function implements part of the developments in: 
% [1]. Irene Velasco Suárez. Diseño y Análisis Preliminar de un Helicóptero no Tripulado.
% PFC. ETSI Aeronáuticos. UPM. Noviembre 2017.
%
% Example of usage
%
%%% How to modify a rigid helicopter data by adding an internal payload with known inertia
%%% This demo shows how to modify a rigid helicopter with modified inertia data  
%%%
%%% First we setup heroes environment by defining an ISA+0 atmosphere and 
%%% a Bo105 rigid helicopter which are stored at the variables atm and he
%%% respectively.
%
%   atm           = getISA;
%   he            = PadfieldBo105(atm);
%
%%% getUpdatedInertiaHe is the main function and inputs to this function 
%%% are a clean configuration rigid helicopter an atmophere and the inertia
%%% characteristics of the payload to be shipped:
%
%%% Mpl: [kg]. Mass of the payload
%%% Ipl: [kg*m^2]. Inertia tensor of the payload defined in the payload reference
%%%      system [GPl;xPl,yPl,zPl].
%%% OfGPL: [m]. Center of mass of payload in the helicopter fuselage reference system [Of;x,y,z]
%%% eulerPl: [rad]. Euler angles of [xPl,yPl,zPl] with respect to [x,y,z]
%
%   Mpl           = 10;                         
%   Ipl           = 0*[[1 0 0];[0 2 0];[0 0 1];]; 
%   OfGPL         = [0.5;0;0];               
%   eulerPl       = pi/180*[0 10 0];            
%                                            
%   newHe         = getUpdatedInertiaHe(he,atm,Mpl,Ipl,OfGPL,eulerPl);%

%%% References
%%%
%%% [1] Alvaro Cuerva Tejero, Jose Luis Espino Granado, Oscar Lopez Garcia,
%%% Jose Meseguer Ruiz, and Angel Sanz Andres. Teoria de los Helicopteros.
%%% Serie de Ingenieria y Tecnologia Aeroespacial. Universidad Politecnica
%%% de Madrid, 2008.
%%%
%%% [2] Irene Velasco Suárez. Diseño y Análisis Preliminar de un Helicóptero
%%% no Tripulado. PFC. ETSI Aeronáuticos. UPM. Noviembre 2017.


newhe = he;

% Center of mass of the clean configuration he (components of the vector
% OfOo in [Of;x,y,z] reference system
xcghe0           = he.geometry.xcg;
ycghe0           = he.geometry.ycg;
zcghe0           = he.geometry.zcg;

OfO0 = [xcghe0;ycghe0;zcghe0];

% Inertia and geometry of clean configuration helicopter. This is the
% inertia tensor of the helicopter with clean configuration, and it is
% calculated in its body reference system [Oo,x,y,z] where Oo represents
% the clean configuration center of mass

Ixhe0            = he.inertia.Ix;
Iyhe0            = he.inertia.Iy;
Izhe0            = he.inertia.Iz;
Ixyhe0           = he.inertia.Ixy;
Ixzhe0           = he.inertia.Ixz;
Iyzhe0           = he.inertia.Iyz;
M0               = he.inertia.W/atm.g;

Ihe0_O0 = [[Ixhe0 -Ixyhe0 -Ixzhe0];
           [-Ixyhe0 Iyhe0 -Iyzhe0];
           [-Ixzhe0 -Iyzhe0 Izhe0]];

%%% Skew matrix corresponding to vector OfO0
OfO0M   = v2SkewV(OfO0);
%%% Application of Steinner Theorem to 
Ihe0_Of_f = M0*(OfO0M')*OfO0M+Ihe0_O0;      


% Center of mass of the payload in [Of;x,y,z]. This is indeed the vector OfGPL
%xcgpl            = OfGPL(1);
%ycgpl            = OfGPL(2);
%zcgpl            = OfGPL(3);


% New position of center of mass OfO
OfO = (M0*OfO0+Mpl*OfGPL)/(M0+Mpl);
OfOM = v2SkewV(OfO);

%%% Transformation matrix from pay load reference system [xPl,yPl,zPl] to helicopter reference
%%% helicopter reference system [x,y,z]

TfPl   = getR1(eulerPl(3))*getR2(eulerPl(2))*getR3(eulerPl(1));
OfGPLM = v2SkewV(OfGPL);

Ipl_Of_f = Mpl*(OfGPLM')*OfGPLM+TfPl*Ipl*TfPl';


Ihe_Of_f = Ihe0_Of_f+Ipl_Of_f;

Ihe_O_f  = (M0+Mpl)*(OfOM')*OfOM+Ihe_Of_f;


newhe.geometry.xcg = OfO(1);
newhe.geometry.ycg = OfO(2);
newhe.geometry.zcg = OfO(3);
                     
newhe.inertia.W = (M0+Mpl)*atm.g;

newhe.inertia.Ix  = Ihe_O_f(1,1);
newhe.inertia.Ixy = -Ihe_O_f(1,2);
newhe.inertia.Ixz = -Ihe_O_f(1,3);
newhe.inertia.Iy  = Ihe_O_f(2,2);
newhe.inertia.Iyz = -Ihe_O_f(2,3);
newhe.inertia.Iz  = Ihe_O_f(3,3);

function V = v2SkewV(v)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

V = [0 -v(3) v(2);
     v(3) 0 -v(1);
     -v(2) v(1) 0];
end


function R1 = getR1(a)
%Rotation matrix arround axis x1 = x
%   Detailed explanation goes here

R1 = [[1 0 0 ];...
      [0  cos(a) sin(a)];...
      [0 -sin(a) cos(a)]];

end

function R2 = getR2(a)
%Rotation matrix arround axis x2 = y
%   Detailed explanation goes here

R2 = [[cos(a) 0 -sin(a)];...
      [0 1 0];...
      [sin(a) 0 cos(a)]];

end

function R3 = getR3(a)
%Rotation matrix arround axis x3 = z
%   Detailed explanation goes here

R3 = [[ cos(a) sin(a) 0];...
        [-sin(a) cos(a) 0];...         
        [0 0 1]];

end

end