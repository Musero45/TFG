function io = test_checkTrimReferenceHA2(mode)
% This script compares the referente trim state for hovering flight 
% of Bo-105, Lynx and Puma helicopters computed using maple work sheets used
% in Ha2 and by heroes.
%
% This is a validation test because the results should be more or less the
% same
%
% TODO: despite the fact we use a non harmonic inflow model, the values of
% lambda_1C and lambda_1S computed by heroes are not zero at all. This
% should be investigated because either linearInflow option set to
% @LMTCuerva does not work or the computed values of lambda_1C and lambda_1S
%
% June 2015
% After the hard overhaul of heroes during winter and spring of 2014/2015 
% we have found out a bug triggered by this script. This validation script
% is not passed anymore and we have to scracth our heads in order to hunt 
% this bug!!!! SHIT HAPPENS!
%
% Now we have found out that the inertia matrix of pract-helicopters can
% not be zero. After adding the original helicopter inertia matrices the
% test is passed. Therefore, inertia matrix plays a fundamental role at the
% new trim functionality (extendended trim flight condition to cope 
% with stationary turns) which it makes sense because inertia moments are
% present at the equations and depending on the imposed degree of freedoms
% the system of equations can be ill or well conditioned despite the fact
% that solution is not going to depend on the inertia moments. The point is
% that fsolve cannot find a solution for a null inertia tensor but it can
% find a solution independent of the inertia tensor when the inertia tensor
% is not null. So, we have added the original inertia tensor for each
% pract-helicopter.
% IMPORTANT NOTE: we do not know what potential impact has this
% modification at other uses of pract-helicopters but the important thing
% is that now this validation test is passed.

close all;

TOL = 1e-3;
% Set up the options structure to guarantee agreement with the maple
% results
opt1       = {... 
              'uniformInflowModel',@Glauert,...
              'linearInflow',@LMTCuerva,...
              'mrForces',@thrustF,...
              'trForces',@thrustF,...
              'mrMoments',@aerodynamicM,...
              'trMoments',@aerodynamicM,...
              'GT',0};
options    = parseOptions(opt1,@setHeroesRigidOptions);


% Load atmosphere
atm        = getISA;
hsl        = 0;

% Define wind
muWT = [0; 0; 0];

% Hover flight condition
fCT = {'ueOR',0.0001,...
       'veOR',0,...
       'cs',0,...
       'weOR',0,...
       'Psi',0 ...
      };
 
% fCT = {'VOR',0.0,...
%        'betaf0',0,...
%        'wTOR',0,...
%        'cs',0,...
%        'vTOR',0};

rigidhe         = {@practBo105,@practLynx,@practPuma};
maplehe         = {'Bo-105','Lynx','Puma'};
nhe             = length(rigidhe);
err             = cell(nhe,1);

isum = 0;
disp('------------------------------------------------------')
disp('Testing trim state comparison between maple and heroes')
for i = 1:nhe


disp(strcat('Running:',maplehe{i}))

he         = rigidhe{i}(atm);
ndHeRef    = rigidHe2ndHe(he,atm,0);
ndts       = getNdHeTrimState(ndHeRef,muWT,fCT,options);
ts         = ndHeTrimState2HeTrimState(ndts,he,atm,hsl,options);
tsHeroes   = ndts.solution;
tsHeroes.power   = ts.Pow.P;
tsMaple    = getReferenceTrimHA2MapleResults(maplehe{i});
err{i}     = checkError4s(tsHeroes,tsMaple,[],...
             'TOL',TOL,'zvars',{...
                     'Phi',...
                     'Theta',...
                     'lambda0',...
                     'lambda0tr',...
                     'theta0',...
                     'theta1C',...
                     'theta1S',...
                     'theta0tr',...
                     'power',...
                     'beta0',...
                     'beta1C',...
                     'beta1S' ...
                     });
% isum = isum  + ia;
end
disp('------------------------------------------------------')
% io = round(isum/nhe);
% 8/02/2016 contents of error structures using the new format of
% checkErrors4s 
% 
% err{1} = 
% 
%           Phi: 1.8957e-04
%         Theta: 3.0501e-04
%       lambda0: 1.2976e-05
%     lambda0tr: 1.3527e-05
%        theta0: 1.3288e-05
%       theta1C: 0.0020
%       theta1S: 9.1884e-04
%      theta0tr: 4.6186e-05
%         power: 160.9348
%         beta0: 0.0078
%        beta1C: 2.4617e-04
%        beta1S: 1.6594e-04
%
%  err{2}
% 
%           Phi: 3.5327e-04
%         Theta: 6.6003e-04
%       lambda0: 8.9594e-06
%     lambda0tr: 2.8088e-05
%        theta0: 1.8257e-06
%       theta1C: 0.0017
%       theta1S: 0.0016
%      theta0tr: 8.1661e-05
%         power: 502.7550
%         beta0: 0.0142
%        beta1C: 5.6722e-04
%        beta1S: 3.2183e-04
% 
%  err{3}
% 
%           Phi: 0.0304
%         Theta: 0.0098
%       lambda0: 9.0472e-05
%     lambda0tr: 8.4561e-04
%        theta0: 2.9853e-04
%       theta1C: 0.0259
%       theta1S: 0.0069
%      theta0tr: 0.0025
%         power: 68.4487
%         beta0: 0.0201
%        beta1C: 1.2159e-04
%        beta1S: 0.0288
%
% ------------------------------------------------------
% The output of this script using r324 (August, 30th, 2014)
% Testing trim state comparison between maple and heroes
% Running:Bo-105
% ... Getting trim states ...
% Test : passed
% Relative Error :0.00039158
% Running:Lynx
% ... Getting trim states ...
% Test : passed
% Relative Error :0.00035387
% Running:Puma
% ... Getting trim states ...
% Test : passed
% Relative Error :2.2033e-05
% ------------------------------------------------------
% AFter adding the inertia tensor to the original helicopters:
% ------------------------------------------------------
% Testing trim state comparison between maple and heroes
% Running:Bo-105
% Solving trim...  1 of 1
% Test : passed
% Relative Error :0.00042167
% Running:Lynx
% Solving trim...  1 of 1
% Test : passed
% Relative Error :0.00054114
% Running:Puma
% Solving trim...  1 of 1
% Test : passed
% Relative Error :6.1953e-05
% ------------------------------------------------------



function x  = getReferenceTrimHA2MapleResults(heName)


switch heName
case 'Bo-105'

% Solution with h_ra < 0
Phi       = -0.5771964178e-1;
Theta     = 0.4754805682e-1;
lambda_i  = -0.5723726019e-1;
lambda_ia = -0.7301245835e-1;
theta_0   = .2667861844;
theta_1C  = -0.2342779901e-3;
theta_1S  = 0.6072905349e-2;
theta_T   = .1792209793;
power     = 3.814978113e5;
beta_0    = 0.03014061426;
beta_1C   = -0.004672782410;
beta_1S   = 0.002942093739;



% % Solution with h_ra > 0
% Phi = -0.6692674183e-1;
% Theta = 0.4750161640e-1;
% lambda_i = -0.5722085374e-1;
% lambda_ia = -0.7368305662e-1; 
% theta_0 = .2667223507;
% theta_1C = -0.7581560903e-2;
% theta_1S = 0.1066856384e-2;
% theta_T = .1815131474;

case 'Lynx'

% Solution with h_ra < 0
Phi       = -0.7019453922e-1;
Theta     = 0.4246947383e-1;
lambda_i  = -0.5876253869e-1;
lambda_ia = -0.9286757267e-1;
theta_0   = .2592862868;
theta_1C  = 0.6657257586e-2;
theta_1S  = -0.5009829826e-2;
theta_T   = .2045788352;
power     = 9.285709845e5;
beta_0    = 0.04192975500;
beta_1C   = 0.007574336786;
beta_1S   = 0.004212919849;



% % Solution with h_ra > 0
% Phi =-0.8225067429e-1;
% Theta = 0.4235736256e-1;
% lambda_i = -0.5873555657e-1;
% lambda_ia =-0.9343739910e-1; 
% theta_0 = .2591850859;
% theta_1C = -0.3149401370e-2;
% theta_1S = -0.9289468468e-2;
% theta_T = .2062371051;

case 'Puma'


% Solution with h_ra < 0
Phi       = -0.6313056784e-1;
Theta     = 0.5375558935e-1;
lambda_i  = -0.6551728650e-1;
lambda_ia = -0.8493251828e-1;
theta_0   = .2463177636;
theta_1C  = 0.7417506065e-2;
theta_1S  = 0.6793112870e-2;
theta_T   = .1870201799;
power     = 1.104785278e6;
beta_0    = 0.07155741792;
beta_1C   = -0.006137396104;
beta_1S   = 0.009572064623;


% % Solution with h_ra > 0
% Phi =-0.9367864935e-1;
% Theta = 0.5333511392e-1;
% lambda_i = -0.6543886718e-1;
% lambda_ia =-0.8565889215e-1; 
% theta_0 = .2460253880;
% theta_1C =  -0.1813942154e-1;
% theta_1S = 0.2633997021e-2;
% theta_T = .1891339096;

otherwise
 disp('getReferenceTrimHA2MapleResults: wrong helicopter name')
end


x = struct( ...
'Phi',Phi, ...
'Theta',Theta, ...
'lambda0',lambda_i, ...
'lambda0tr',lambda_ia, ...
'theta0',theta_0, ...
'theta1C',theta_1C, ...
'theta1S',theta_1S, ...
'theta0tr',theta_T, ...
'power',power,...
'beta0',beta_0,...
'beta1C',beta_1C,...
'beta1S',beta_1S ...
);
