function he = rigidNLGazelle(atmosphere,lmr,psimrvect)

%--------------------------------------------------------------------------
% I generate now 1 adimensional blade regions for the main rotor and
% 1 for the tail rotor
%--------------------------------------------------------------------------

heA      = rigidGazelle(atmosphere);

% Main Rotor
    
lmrRegions = {lmr};

airfoilmr = {@OA209ARM};


% Tail Rotor

psitrvect = linspace(0,2*pi,72);

ltr = linspace(0,1.0,5);

ltrRegions  = {ltr};
  
airfoiltr = {@NACA0012ARM};

%%
nAsetUp = struct('psimr1D',{psimrvect},...
                 'lmrRegions',{lmrRegions},'airfoilmr',{airfoilmr},...
                 'psitr1D',{psitrvect},...
                 'ltrRegions',{ltrRegions},'airfoiltr',{airfoiltr});
             

he = addNLrotor2He(heA,nAsetUp);%heNA means non analytic helicopter


end
