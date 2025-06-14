function FE = getTrimmedFlightEnvelope(r4fHe,vWT,FC4,atm,N,options,varargin) 
% FE = getTrimmedFlightEnvelope(r4fHe,vWT,FC4,atm,N,options,varargin)
% provides the flight envelope (Hmax = f(Vmax)) from trim flight analysis
% for a ready for flight helicopter r4fHe, atmosphere atm, wind
% velocity vector in ground reference system vWT and extra flight
% conditions FC4 (four extra flight conditions). Calcutation options are 
% specified in variable options. The number of calculated points in the
% flight envelope is specified in input N
%
% The FE is a structure with fields
%
%            -'HmaxHover': [m]. Maximum height in hover.
%            -'VmaxSL': [m/s]. Maximum velocity at see level.
%            -'Vmax': [m/s]. [1xN]. Maximum velocity values.
%            -'Hmax': [m]. [1xN]. Maximum height values;
%
%
%

W     = r4fHe.inertia.W;
R     = r4fHe.mainRotor.R;

%Maximum altitude at hover
V         = 1;
Hmax0     = 2000; 
Hmaxhover = getMaximumFlightAltitude(r4fHe,vWT,FC4,atm,...
                                     V,Hmax0,options);

%Maximum velocity  at sea level 
H      = 0;
rho    = atm.density(H);
VH0    = 6*sqrt(W/(2*rho*pi*R^2));
VmaxH0 = getMaximumFlightVelocity(r4fHe,vWT,FC4,atm,...
                                  H,VH0,options);                                 

                              
if mod(N,2) == 0
    
    N1 = N/2;
    N2 = N1;
    
else
    
    N1 = (N+1)/2;
    N2 = N-N1;
    
end
                              

%Max altitudes for V=[0,VmaxH0];                              
Vvec  = linspace(1,VmaxH0,N1);
Hmax  = getMaximumFlightAltitude(r4fHe,vWT,FC4,atm,...
                                     Vvec,Hmaxhover,options);


                                 
%Max velocities for H = [0 Hmax(end)]

Hvec   = linspace(0,Hmax(end),N2);
VH0 = VmaxH0;

Vmax  = getMaximumFlightVelocity(r4fHe,vWT,FC4,atm,Hvec,VH0,options);


FE = struct('HmaxHover',Hmaxhover,...
            'VmaxSL',VmaxH0,...
            'Vmax',[Vvec fliplr(Vmax)],...
            'Hmax',[Hmax fliplr(Hvec)]);


end