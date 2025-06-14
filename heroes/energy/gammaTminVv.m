function [gammaT_mVV VV_mVV VH_mVV] = gammaTminVv(he,fC,atm,varargin)


options    = parseOptions(varargin,@setHeroesEnergyOptions);


f2min      = @(VH) defineGoal(VH,he,fC,atm,options);
ops        = optimset('TolX',1e-6,'Display','off');
VH_mVV     = fminbnd(f2min,0,200,ops);



fC.Vh      = VH_mVV;
ps         = getEpowerState(he,fC,atm,options);
gammaT_mVV = ps.gammaT;
VV_mVV     = ps.Vv;
end

function F = defineGoal(VH,he,fC,atm,options)

fC.Vh   = VH;
ps      = getEpowerState(he,fC,atm,options);
F       = -ps.Vv;

end

