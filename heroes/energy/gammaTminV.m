function [gammaT_mV VV_mV VH_mV] = gammaTminV(he,fC,atm,varargin)


options    = parseOptions(varargin,@setHeroesEnergyOptions);


f2min = @(VH) defineGoal(VH,he,fC,atm,options);
ops = optimset('TolX',1e-6,'Display','off');
VH_mV = fminbnd(f2min,0,200,ops);



fC.Vh      = VH_mV;
ps         = getEpowerState(he,fC,atm,options);
gammaT_mV  = ps.gammaT;
VV_mV      = ps.Vv;
end

function F = defineGoal(VH,he,fC,atm,options)

fC.Vh   = VH;
ps      = getEpowerState(he,fC,atm,options);
F       = sqrt(ps.Vv^2 + ps.Vh^2);

end

