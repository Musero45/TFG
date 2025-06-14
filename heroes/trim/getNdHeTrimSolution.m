function [Solution,Residuals] = getNdHeTrimSolution(ndHe,muWT,FC,varargin)
%getNdHeTrimSolution provides the solution of the general trim problem
% for a given non dimensional helicopter, ndHe, a nondimensional wind vector
% expressed in the ground reference system, muWT, a set of given options and a number
% of user define flight conditions given in varargin.
%
% [S,R] = getNdHeTrimSolution(ndHe,muWT,FC) gets the trim solution S
% from the general trim system helicopterTrim for the user-prescribed values of the
% flight consitions in FC. The function also provides the residuals
% R of the general trim system helicopterTrim.
% See also helicopterTrim.
%
%
%==========================================================================
% INPUTS and OUTPUTS
%--------------------------------------------------------------------------
% The inputs are:
%
% muWT:      is the nondimensional wind velocity vector expressed in
%            the ground reference system.
% 
% FC:        is the cell {'FC1var',FC1val,'FC2var',FC2val,
%            'FC3var',FC3val,'FC4var',FC4val,'FC5var',FC5val'},
%
%            where 'FC1var' to 'FC5var' are the 5 variables that can
%            be prescribed by the user in the general flight state
%            vector of 42 components. See also helicopterTrim.
%
%            FC1val to FC5val can be either scalars of one
%            dimensional vectors. In any case, 
%            getNdHeTrimSolution(ndHe,muWT,options,varargin) solves
%            the general trim probem for a set of flight conditions
%            SetFC equal to the cartesian product:
%           
%            SetFC = FC1val x FC2val x FC3val x FC4val x FC5val
%
%            If FC1val to FC5val are scalars, one single flight 
%            condition is resolved.
%
%            If FC1val to FC5val are one dimensional vectors
%            with lengths n1 to n5, then n1xn2xn3xn4xn5 flight 
%            conditions are resolved.
%
%
% The outputs are:
%
% S:         is a strucuture with 43 fields 
%           class: 'GeneralTrimSolution'
%           Theta: [n1xn2xn3xn4xn5 double] 
%             Phi: [n1xn2xn3xn4xn5 double]
%          theta0: [n1xn2xn3xn4xn5 double]
%         theta1C: [n1xn2xn3xn4xn5 double]
%         theta1S: [n1xn2xn3xn4xn5 double]       
%        theta0tr: [n1xn2xn3xn4xn5 double]
%           beta0: [n1xn2xn3xn4xn5 double]
%          beta1C: [n1xn2xn3xn4xn5 double]
%          beta1S: [n1xn2xn3xn4xn5 double]
%         lambda0: [n1xn2xn3xn4xn5 double]
%        lambda1S: [n1xn2xn3xn4xn5 double]
%             CT0: [n1xn2xn3xn4xn5 double]
%            CT1C: [n1xn2xn3xn4xn5 double]
%            CT1S: [n1xn2xn3xn4xn5 double]
%         beta0tr: [n1xn2xn3xn4xn5 double]
%        beta1Ctr: [n1xn2xn3xn4xn5 double]
%        beta1Str: [n1xn2xn3xn4xn5 double]
%       lambda0tr: [n1xn2xn3xn4xn5 double]
%      lambda1Ctr: [n1xn2xn3xn4xn5 double]
%      lambda1Str: [n1xn2xn3xn4xn5 double]
%           CT0tr: [n1xn2xn3xn4xn5 double]
%          CT1Ctr: [n1xn2xn3xn4xn5 double]
%          CT1Str: [n1xn2xn3xn4xn5 double]
%           omega: [n1xn2xn3xn4xn5 double]
%             Psi: [n1xn2xn3xn4xn5 double]
%            uTOR: [n1xn2xn3xn4xn5 double]
%            vTOR: [n1xn2xn3xn4xn5 double]
%            wTOR: [n1xn2xn3xn4xn5 double]
%            ueOR: [n1xn2xn3xn4xn5 double]
%            veOR: [n1xn2xn3xn4xn5 double]
%            weOR: [n1xn2xn3xn4xn5 double]
%           omxad: [n1xn2xn3xn4xn5 double]
%           omyad: [n1xn2xn3xn4xn5 double]
%           omzad: [n1xn2xn3xn4xn5 double]
%       omegaAdzT: [n1xn2xn3xn4xn5 double]
%             VOR: [n1xn2xn3xn4xn5 double]
%          gammaT: [n1xn2xn3xn4xn5 double]
%           betaT: [n1xn2xn3xn4xn5 double]
%          betaf0: [n1xn2xn3xn4xn5 double]
%         alphaf0: [n1xn2xn3xn4xn5 double]
%              cs: [n1xn2xn3xn4xn5 double]
%              CW: [n1xn2xn3xn4xn5 double]
%
%            Each of the fields 2 to 43 contains a (n1,n2,n3,n4,n5)
%            size matrix with the values of the corresponding
%            S-field in the previous list corresponding to 
%            the user prescribed flight condition
%            given by ndgrid(FC1val,FC2val,FC3val,FC4val,FC5val)
%
% R:         is a strucuture with 43 fields 
%
% S:         is a strucuture with 43 fields 
%           class: 'GeneralTrimResiduals'
%           FVAL1: [n1xn2xn3xn4xn5 double] 
%           ...
%           FVAL42: [n1xn2xn3xn4xn5 double]
%==========================================================================
%
%==========================================================================
% SYNTAX
%--------------------------------------------------------------------------
%
%    S = getNdHeTrimSolution(ndHe,muWT,FC) provides the general
%    trim solution for nondimensional helicopter ndHe, non dimensional
%    wind vector muWT, flight condition FC and default
%    HeroesRigidOptions. See also setHeroesRigidOptions
%        
%    S = getNdHeTrimSolution(ndHe,muWT,FC,OPTIONS) 
%    provides the general trim solution for nondimensional
%    helicopter ndHe, non dimensional wind vector muWT,
%    flight condition FC and OPTIONS prescribed by the user.
%    OPTIONS provided by the user are parsed with default
%    HeroesRigidOptions. See also setHeroesRigidOptions
%
%    [S,R] = getNdHeTrimSolution(ndHe,muWT,FC,OPTIONS) 
%    provides the general trim solution and general trim residuals
%    for nondimensional helicopter ndHe, non dimensional wind
%    vector muWT, flight condition FC and OPTIONS prescribed
%    by the user. OPTIONS provided by the user are parsed with
%    default HeroesRigidOptions. See also setHeroesRigidOptions
%
%     IMPORTANT: The user must note that the prescription of the 
%     OPTIONS, FCjvar and the corresponding FCjval must be
%     physically sound.
%==========================================================================
%
%==========================================================================
%     EXAMPLE OF USAGE 1: Calculate one single trim solution for a
%     straigth level flight in ISA at sea level with nondimensional
%     forward flight speed V/OR = 0.1, no slip angle and no wind.
%--------------------------------------------------------------------------
%
%      options    = setHeroesRigidOptions;
%      atm        = getISA;
%      he         = PadfieldBo105(atm);
%      ndHe       = rigidHe2ndHe(he,atm,0);
%      muWT       = [0; 0; 0];
%
%     getNdHeTrimSolution(ndHe,muWT,...
%                       {'VOR',0.1,...
%                       'gammaT',0,...
%                       'betaf0',0,...
%                       'vTOR',0,...
%                       'cs',0} ...
%                        )
%  ans = 
%
%         class: 'GeneralTrimSolution'
%         Theta: 0.0385
%           Phi: -0.0371
%        theta0: 0.2310
%       theta1C: 0.0298
%       theta1S: -0.0187
%      theta0tr: 0.0968
%         beta0: 0.0347
%        beta1C: -0.0061
%        beta1S: 0.0040
%       lambda0: -0.0333
%      lambda1C: -0.0237
%      lambda1S: 0
%           CT0: 0.0052
%          CT1C: -2.0822e-004
%          CT1S: 4.0410e-004
%       beta0tr: 3.5866e-098
%      beta1Ctr: -1.6198e-098
%      beta1Str: 1.3575e-098
%     lambda0tr: -0.0344
%    lambda1Ctr: -0.0244
%    lambda1Str: 9.4038e-004
%         CT0tr: 0.0054
%        CT1Ctr: -0.0027
%        CT1Str: 0.0022
%         omega: 1
%           Psi: -0.0014
%          uTOR: 0.1000
%          vTOR: 0
%          wTOR: 0
%          ueOR: 0.0999
%         veOR: 0
%          weOR: 0.0039
%         omxad: 0
%         omyad: 0
%         omzad: 0
%     omegaAdzT: 0
%           VOR: 0.1000
%        gammaT: 0
%         betaT: 0
%        betaf0: 0
%       alphaf0: 0.0385
%            cs: 0
%            CW: 0.0067
%==========================================================================
% 
%==========================================================================
%     EXAMPLE OF USAGE 2: Calculate one the trim solution for a
%     straigth flight in ISA at sea level with nondimensional
%     forward flight speeds V/OR = [0.1 0.2], climb angle
%     gammaT = [5*pi/180 10*pi/180], no slip angle and no wind.
%--------------------------------------------------------------------------
%
%      atm        = getISA;
%      he         = PadfieldBo105(atm);
%      ndHe       = rigidHe2ndHe(he,atm,0);
%      muWT       = [0; 0; 0];
%
%     S           = getNdHeTrimSolution(ndHe,muWT,...
%                       {'VOR',[0.1 0.15 0.2],...
%                       'gammaT' [5*pi/180 10*pi/180],...
%                       'betaf0',0,...
%                       'vTOR',0,...
%                       'cs',0} ...
%                       )
%    ans = 
%
%         class: 'GeneralTrimSolution'
%         Theta: [3x2 double]
%           Phi: [3x2 double]
%        theta0: [3x2 double]
%       theta1C: [3x2 double]
%       theta1S: [3x2 double]
%      theta0tr: [3x2 double]
%         beta0: [3x2 double]
%        beta1C: [3x2 double]
%        beta1S: [3x2 double]
%       lambda0: [3x2 double]
%      lambda1C: [3x2 double]
%      lambda1S: [3x2 double]
%           CT0: [3x2 double]
%          CT1C: [3x2 double]
%          CT1S: [3x2 double]
%       beta0tr: [3x2 double]
%      beta1Ctr: [3x2 double]
%      beta1Str: [3x2 double]
%     lambda0tr: [3x2 double]
%    lambda1Ctr: [3x2 double]
%    lambda1Str: [3x2 double]
%         CT0tr: [3x2 double]
%        CT1Ctr: [3x2 double]
%        CT1Str: [3x2 double]
%         omega: [3x2 double]
%           Psi: [3x2 double]
%          uTOR: [3x2 double]
%          vTOR: [3x2 double]
%          wTOR: [3x2 double]
%          ueOR: [3x2 double]
%          veOR: [3x2 double]
%          weOR: [3x2 double]
%         omxad: [3x2 double]
%         omyad: [3x2 double]
%         omzad: [3x2 double]
%     omegaAdzT: [3x2 double]
%           VOR: [3x2 double]
%        gammaT: [3x2 double]
%         betaT: [3x2 double]
%        betaf0: [3x2 double]
%       alphaf0: [3x2 double]
%            cs: [3x2 double]             
%            cs: [3x2 double]
%            CW: [3x2 double]
%  and the collective pitch angle in degrees is
%
%  ans.theta0*180/pi
%
%  ans =
%
%   13.9571   14.6744
%   13.7660   14.9266
%   14.1390   15.7286
%
%=====================================================================
%     EXAMPLE OF USAGE 3: Calculate the trim solution and trim
%     residual for a straight autorrotation descend flight
%     in ISA at sea level with nondimensional velocity component
%     uT/OR = [0.1 0.15 0.2],ratio of omegas: omega=OmegaAu/OmegaRated =
%     [0.95 1 1.05], slip angles betaf0 = [0 5*180/pi] and no wind. 
%---------------------------------------------------------------------
%      atm        = getISA;
%      he         = PadfieldBo105(atm);
%      ndHe       = rigidHe2ndHe(he,atm,0);
%      muWT       = [0; 0; 0];
%
%     [S,R]       = getNdHeTrimSolution(ndHe,muWT,...
%                       {'uTOR',[0.1 0.15 0.2],...
%                       'omega',[0.95 1 1.05],...
%                       'betaf0',[0*pi/180 5*pi/180],...
%                       'vTOR',0,...
%                       'cs',0},...
%                       'engineState',@EngineOffTransmissionOn);
%     
%     and as an example the dencend angle gammaT expressed in degrees
%     is presented
%
%     S.gammaT*180/pi
%
%       ans(:,:,1) =
%
%      -27.2381  -26.3616  -25.7022
%      -15.9132  -15.6054  -15.4481
%      -11.4119  -11.4302  -11.5558
%
%
%       ans(:,:,2) =
%
%      -27.0803  -26.2191  -25.5751
%      -15.8103  -15.5266  -15.3930
%      -11.3986  -11.4500  -11.6085
%
%     and as an example the residual of the equation F(1)
%     is presented
%
%     R.FVAL1
%
%        ans(:,:,1) =
%
%        1.0e-018 *
%
%      0.1084         0   -0.1355
%      0.0136    0.0136    0.0136
%      0.0610   -0.0559   -0.0724
%
%
%        ans(:,:,2) =
%
%        1.0e-018 *
%
%           0    0.0271   -0.0271
%      0.1084   -0.1355    0.0271
%     -0.0102   -0.0288    0.0296
%=====================================================================
%
%
%=====================================================================
%     EXAMPLE OF USAGE 4: Calculate the trim solution and trim
%     residual for a straight autorrotation descend flight
%     in ISA at sea level with nondimensional velocity component
%     uT/OR = [0.1 0.2],ratio of omegas: omega=OmegaAu/OmegaRated =
%     [0.95 1 1.05], slip angles betaf0 = [0 5*180/pi] and no wind. 
%---------------------------------------------------------------------
%      atm        = getISA;
%      he         = PadfieldBo105(atm);
%      ndHe       = rigidHe2ndHe(he,atm,0);
%      muWT       = [0; 0; 0];
%
%      S       = getNdHeTrimSolution(ndHe,muWT,...
%                       {'uTOR',[0.1 0.15 0.2],...
%                       'omega',[0.95 1 1.05],...
%                       'betaf0',[0*pi/180 5*pi/180],...
%                       'vTOR',0,...
%                       'cs',0},...
%                       'engineState',@EngineOffTransmissionOn);
%     
%     and as an example the dencend angle gammaT expressed in degrees
%     is presented
%
%     S.gammaT*180/pi
%
%       ans(:,:,1) =
%
%      -27.2381  -26.3616  -25.7022
%      -15.9132  -15.6054  -15.4481
%      -11.4119  -11.4302  -11.5558
%
%
%       ans(:,:,2) =
%
%      -27.0803  -26.2191  -25.5751
%      -15.8103  -15.5266  -15.3930
%      -11.3986  -11.4500  -11.6085
%==========================================================================
%
%==========================================================================
%     Example of usage 5: Calculate the trim solution and trim
%     residual for a spiral autorrotation descend flight
%     in ISA at sea level with nondimensional velocity component
%     uT/OR = [0.1 0.2],ratio of omegas: omega=OmegaAu/OmegaRated =
%     1.05, slip angle betaf0 = 0, radious of the path
%     1/cs =  [-1/200 -1/100] and no wind . 
%--------------------------------------------------------------------------
%      atm        = getISA;
%      he         = PadfieldBo105(atm);
%      ndHe       = rigidHe2ndHe(he,atm,0);
%      muWT       = [0; 0; 0];
%
%     S       = getNdHeTrimSolution(ndHe,muWT,...
%                       {'uTOR',[0.1 0.15 0.2],...
%                       'omega',[0.95 1 1.05],...
%                       'betaf0',0,...
%                       'vTOR',0,...
%                       'cs',[-1/200 -1/100]},...
%                       'engineState',@EngineOffTransmissionOn);
%     
%     and as an example the dencend balance gammaT expressed in degrees
%     is presented
%
%     S.Phi*180/pi
%
%     ans(:,:,1,1,1) =
%
%      -2.7978   -2.7936   -2.7891
%      -6.3192   -6.3153   -6.3111
%      -11.1587  -11.1554  -11.1519
%
%
%     ans(:,:,1,1,2) =
%
%      -5.6068   -5.6032   -5.5990
%      -12.4847  -12.4818  -12.4781
%      -21.4821  -21.4804  -21.4776
%==========================================================================



options    = parseOptions(varargin,@setHeroesRigidOptions);

% nlSolver in options is got
nlSolver  = options.nlSolver;

% input known data for trim solutions assigned to FC
%FC = varargin;

% trim solution set up variables and values are obtained
TrimSolutionSetUp = getTrimSolutionSetUp(FC);

%Definition of solving conditions
FC1 = TrimSolutionSetUp.FCvars.FC1;
FC2 = TrimSolutionSetUp.FCvars.FC2;
FC3 = TrimSolutionSetUp.FCvars.FC3;
FC4 = TrimSolutionSetUp.FCvars.FC4;
FC5 = TrimSolutionSetUp.FCvars.FC5;

valFC1M = TrimSolutionSetUp.FCvalues.FC1val;
valFC2M = TrimSolutionSetUp.FCvalues.FC2val;
valFC3M = TrimSolutionSetUp.FCvalues.FC3val;
valFC4M = TrimSolutionSetUp.FCvalues.FC4val;
valFC5M = TrimSolutionSetUp.FCvalues.FC5val;

%Size, s, of the solution data and number of flight conditions, n 
s = size(valFC1M);
n = numel(valFC1M);

% initial conditions for trim solution are obtained
[iniTrimCon,~] = getInitialTrimConditions(ndHe);                                                   
initialCondition = cell2mat(struct2cell(iniTrimCon));  

%Update of the initial conditions using the user defined FC
initialCondition(FC1) = valFC1M(1);
initialCondition(FC2) = valFC2M(1);
initialCondition(FC3) = valFC3M(1);
initialCondition(FC4) = valFC4M(1);
initialCondition(FC5) = valFC5M(1);


%================================================================
% Initialization of trim variables and residuals
%----------------------------------------------------------------

Solution.('class')  = 'GeneralTrimSolution';
Residuals.('class') = 'GeneralTrimResiduals';

trimVars = getTrimVarsNames;

for vari = 1:length(trimVars)
        
    Solution.(trimVars{vari}) = zeros(s);
    Residuals.(strcat('FVAL',num2str(vari))) = zeros(s);
    
end
                                              
%================================================================
% Trim solution loop
%================================================================
                                                           
 for i = 1:n
        
        disp (['Solving trim...  ', num2str(i), ' of ', num2str(n)]);
        
        valFC1 = valFC1M(i);
        valFC2 = valFC2M(i);
        valFC3 = valFC3M(i);
        valFC4 = valFC4M(i);
        valFC5 = valFC5M(i);
        
            trimSetUp = struct('FC1',FC1,'FC2',FC2,'FC3',FC3,'FC4',FC4,'FC5',FC5,...
                           'valFC1',valFC1,'valFC2',valFC2,'valFC3',valFC3,...
                           'valFC4',valFC4,'valFC5',valFC5);
                   
            system2solve = @(x)MYhelicopterTrim(x,muWT,ndHe,trimSetUp,options);
                       
            [x,FVAL] = nlSolver(system2solve,initialCondition,options);
                           
            initialCondition = x;
            
            
            
            for xi = 1:length(x)
                
                Solution.(trimVars{xi})(i) = x(xi);
                Residuals.(strcat('FVAL',num2str(xi)))(i) = FVAL(xi);
                
            end            

 end


