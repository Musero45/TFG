
function he = rigidNLBo105e0(atmosphere)

%--------------------------------------------------------------------------
% I generate now 4 adimensional blade regions for the main rotor and
% two for the tail rotor
%--------------------------------------------------------------------------

heA = rigidBo105(atmosphere);

psimrvect = linspace(0,2*pi,181);

lmr1 = linspace(0,1,29);

    
lmrRegions = {lmr1};

psitrvect = linspace(0,2*pi,181);

ltr1 = linspace(0,1,16);

ltrRegions  = {ltr1}; 


airfoilmr = {@NACA0012ARM};
        
airfoiltr = {@NACA0012ARM};

nAsetUp = struct('psimr1D',{psimrvect},...
                 'lmrRegions',{lmrRegions},'airfoilmr',{airfoilmr},...
                 'psitr1D',{psitrvect},...
                 'ltrRegions',{ltrRegions},'airfoiltr',{airfoiltr});
             

he = AddNlData2He(heA,nAsetUp);%heNA means non analytic helicopter


end
