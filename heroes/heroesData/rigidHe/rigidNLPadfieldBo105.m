
function he = rigidNLPadfieldBo105(atmosphere)

%--------------------------------------------------------------------------
% I generate now 4 adimensional blade regions for the main rotor and
% two for the tail rotor
%--------------------------------------------------------------------------

heA = PadfieldBo105(atmosphere);

psimrvect = linspace(-pi,pi,180);

lmr1 = linspace(0,0.15,5);
lmr2 = linspace(0.16,0.24,8);
lmr3 = linspace(0.25,0.70,10);
lmr4 = linspace(0.71,1,6);
    
lmrRegions = {lmr1,lmr2,lmr3,lmr4};

psitrvect = linspace(-pi,pi,180);

ltr1 = linspace(0,0.15,6);
ltr2 = linspace(0.16,1,10);

ltrRegions  = {ltr1,ltr2}; 


airfoilmr = {@NACA0012ARM,@NACA0012ARM,@NACA0012ARM,...
            @NACA0012ARM};
        
airfoiltr = {@NACA0012ARM,@NACA0012ARM};

nAsetUp = struct('psimr1D',{psimrvect},...
                 'lmrRegions',{lmrRegions},'airfoilmr',{airfoilmr},...
                 'psitr1D',{psitrvect},...
                 'ltrRegions',{ltrRegions},'airfoiltr',{airfoiltr});
             

he = addNLrotor2He(heA,nAsetUp);%heNA means non analytic helicopter


end
