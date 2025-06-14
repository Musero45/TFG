function ioFisical = restrictionsFisical(hePerf)
%FISICALRESTRICTIONS Evaluates the fisical restrictions

D = 2*hePerf.mainRotor.R;
b = hePerf.mainRotor.b;
c = hePerf.mainRotor.c0;

Dtr = 2*hePerf.tailRotor.R;
btr = hePerf.tailRotor.b;

L   = hePerf.fuselage.lf;

GTOW = hePerf.inertia.MTOW; 

OR = hePerf.mainRotor.Omega*hePerf.mainRotor.R;
DL = hePerf.inertia.MTOW/pi*hePerf.mainRotor.R^2;

ThetaPF = hePerf.Restrictions.trimStatePF.Theta;
PhiPF = hePerf.Restrictions.trimStatePF.Phi;
ThetaCruise = hePerf.Restrictions.trimStateCruise.Theta;
PhiCruise = hePerf.Restrictions.trimStateCruise.Phi;

% Vmax check, must be positive
if isfield(hePerf.Performances,'Vm')
    Vm = hePerf.Performances.Vm;
    % Vm must be positive
    Vmin = 0;  
    if Vm<=Vmin
        ioFisical = 0;
        return
    end
end

% Stability results must avoid NaN problem by using t1/2 and T
if isfield(hePerf.Performances,'StabilityConvergence')
   thalf = hePerf.Performances.StabilityConvergence;
    if isnan(thalf)||isinf(thalf)
        ioFisical = 0;
        return
    end
end

if isfield(hePerf.Performances,'StabilityOscillation')
   T = hePerf.Performances.StabilityOscillation;
    if isnan(T)||isinf(T)
        ioFisical = 0;
        return
    end
end


% Max main rotor diameter
Dmax = 32;
if D>Dmax
    ioFisical = 0;
    return
end

% Max min main rotor blades
bmax = 8; bmin = 1;
if b>bmax||b<=bmin
    ioFisical = 0;
    return
end

% Max main rotor chord
cmax = 0.5;
if c>cmax
    ioFisical = 0;
    return
end

% Max tail rotor diameter
Dtrmax = 4;
if Dtr>Dtrmax
    ioFisical = 0;
    return
end

% Max tail rotor blades
btrmax = 18;
if btr>btrmax
    ioFisical = 0;
    return
end

% Max helicopter length
Lmax = 40.25;
if L>Lmax
    ioFisical = 0;
    return
end

% Max gross weight
GTOWmax = 56000*9.81;
if GTOW>GTOWmax
    ioFisical = 0;
    return
end

% Max tail rotor speed
ORmax = 340;
if OR>ORmax
    ioFisical = 0;
    return
end

% Max disk loading
% DLmax = 500;
% if DL>DLmax
%     ioFisical = 0;
%     return
% end

% Max angles in trim
ThetaPFmax = deg2rad(20); ThetaPFmin = deg2rad(-20);
if ThetaPF>ThetaPFmax||ThetaPF<=ThetaPFmin
    ioFisical = 0;
    return
end

ThetaCruisemax = deg2rad(20); ThetaCruisemin = deg2rad(-20);
if ThetaCruise>ThetaCruisemax||ThetaCruise<=ThetaCruisemin
    ioFisical = 0;
    return
end

PhiPFmax = deg2rad(20); PhiPFmin = deg2rad(-20);
if PhiPF>PhiPFmax||PhiPF<=PhiPFmin
    ioFisical = 0;
    return
end

PhiCruisemax = deg2rad(20); PhiCruisemin = deg2rad(-20);
if PhiCruise>PhiCruisemax||PhiCruise<=PhiCruisemin
    ioFisical = 0;
    return
end

ioFisical = 1;

end

