clear all
close all
setPlot
set(0,'DefaultTextFontSize',18)
set(0,'DefaultAxesFontSize',18)

%% Setup atmosphere and computation options
%
% First, we setup heroes environment by defining and ISA+0 atmosphere, 
% the analysis altitude is sea level, H=0 and wind velocity in ground
% reference system is set to zero. Default options are defined by 
% setHeroesRigidOptions.

atm       = getISA;
H         = 0;
muWT      = [0; 0; 0];
options   = setHeroesRigidOptions;
options.armonicInflowModel = @none;

%% Definition of the rigid helicópter, both linear and non-linear versions
% The linear and non-linear versions of the rigid helicopter are defined
% and made non-dimensional

he_ln     = rigidBo105e02223(atm);
he_nl     = rigidNLBo105e02223(atm);
ndHe_ln   = rigidHe2ndHe(he_ln,atm,H);
ndHe_nl   = rigidHe2ndHe(he_nl,atm,H);


%% Solution of the trim problem for linear assuptions for the aeromechanic model
% From the mathematical point of view, the trim problem is a system of
% 37 equations with 42 unknows non-linear algebraic equations. Therefore it
% is neccessary to prescribe 5 variables. In the present case we analize a
% straight (cs=0) level flight (wTOR=0) without slip angle (betaf0=0) for
% an interval of non-dimensional flight speeds VOR =
% linspace(0.005,0.4,15). An aditional condition related to yaw angle must
% be prescribed, in this case vTOR = 0.

VOR0   = 0.005;
VORend = 0.5;

FC     = {'VOR',linspace(VOR0,VORend,15),...
          'betaf0',0,...
          'wTOR',0,...
          'cs',0,...
          'vTOR',0};
       
%The function that solves the trim solution and some additional postprocess
%variables is getNdHeTrimState. This function innerly defined a initial 
%condition for the numerical iteration of the solution. This initial condition
%can be also prescribed by the usser to facilitate the iteration process,
%as it is commented in what follows.

ndTs_ln1 = getNdHeTrimState(ndHe_ln,muWT,FC,options); 
tS_ln1   = ndHeTrimState2HeTrimState(ndTs_ln1,he_ln,atm,H,options);

options.mrForces = @completeF;

ndTs_ln2 = getNdHeTrimState(ndHe_ln,muWT,FC,options); 
tS_ln2   = ndHeTrimState2HeTrimState(ndTs_ln2,he_ln,atm,H,options);


%% Solution of the trim problem for non-linear assuptions for the aeromechanic model
%The iteration process of the trim solution when the non-linear
%aeromechanic model is considered is costly. To facilitate the numerical
%solution process, it is convenient to prescribe an initial condition
%close to the solution. This is easily using as initial value od the
%solution to iterate in the non-linear model, the solution of the linear
%one.

FC0      = {'VOR',VOR0,...
            'betaf0',0,...
            'wTOR',0,...
            'cs',0,...
            'vTOR',0};

ndTs0              = getNdHeTrimState(ndHe_ln,muWT,FC0,options);  
ndS0               = ndTs0.solution;
options.IniTrimCon = ndS0;

% Once the initial condition of the non-linear problem has been calculated
% is is cruxial to realise that to use the non-linear aeromechanic model,
% the non-linear aeromechanic model as well as the non-linear models for
% the calculation of forces and moments in both rotors must be specified in
% the corresponding fields of the options structure.

options.aeromechanicModel = @aeromechanicsNL;
options.mrForces          = @completeFNL;
options.mrMoments         = @aerodynamicMNL;
options.trForces          = @completeFNL;
options.trMoments         = @aerodynamicMNL;

ndTs_nl        = getNdHeTrimState(ndHe_nl,muWT,FC,options);
tS_nl          = ndHeTrimState2HeTrimState(ndTs_nl,he_nl,atm,H,options);

%% Postprocessing of the non-dimensional trinm state results
%In what follows, an exmample of use of high level plotting functions
%available in HEROES to show the differences among the linear and
%non-linear solutions of the trim problem

ndTsSol    = {ndTs_ln1.solution,ndTs_ln2.solution,ndTs_nl.solution};

axds       = getaxds({'VOR'},{'$V/\Omega R\,\mathrm{[-]}$'},1);

var        = {...
'Theta',...
'Phi',...
'theta0',...
'theta1C',...
'theta1S',...
'theta0tr',...
'beta0',...
'beta1C',...
'beta1S'
};

lab        = {...
'$$\Theta$$ [$$^o$$]',...
'$$\Phi$$ [$$^o$$]',...
'$$\theta_0$$ [$$^o$$]',...
'$$\theta_{1C}$$ [$$^o$$]',...
'$$\theta_{1S}$$ [$$^o$$]',...
'$$\theta_{0,tr}$$ [$$^o$$]',...
'$$\beta_0$$ [$$^o$$]',...
'$$\beta_{1C}$$ [$$^o$$]',...
'$$\beta_{1S}$$ [$$^o$$]',...
};

r2d       = 180/pi;
unit      = [r2d r2d r2d r2d r2d r2d r2d r2d r2d];
azds      = getaxds(var,lab,unit);
axATa     = plotNdTrimSolution(...
            ndTsSol,axds,{'Linear thrusF','Linear completeF','Nonlinear'},...
           'defaultVars',azds ...
);               

%Basic technique to plot figures
figure(100)

plot(ndTs_ln1.solution.VOR,ndTs_ln1.solution.CT0,'k-');
hold on
plot(ndTs_ln2.solution.VOR,ndTs_ln2.solution.CT0,'b-');
plot(ndTs_nl.solution.VOR,ndTs_nl.solution.CT0,'r-');
xlabel('$V/\Omega R\,\mathrm{[-]}$');
ylabel('$C_T\,\mathrm{[-]}$');
legend('lin ThrustF','lin CompleteF','n-lin','location','best');
grid on


figure(101)

plot(ndTs_ln1.solution.VOR,ndTs_ln1.ndPow.CPM,'k-');
hold on
plot(ndTs_ln2.solution.VOR,ndTs_ln2.ndPow.CPM,'b-');
plot(ndTs_nl.solution.VOR,ndTs_nl.ndPow.CPM,'r-');
xlabel('$V/\Omega R\,\mathrm{[-]}$');
ylabel('$C_{PM}\,\mathrm{[-]}$');legend('lin','n-lin');
legend('lin ThrustF','lin CompleteF','n-lin','location','best');
grid on

%Other example about using high level plot functions in HEROES. Now we are
%comparing the fields PM, Pmr and Ptr for both linear and non-linear
%simulations. This field does not contain the field V (flight speed), this
%is why it is following added to the structures tu plot.

tS_ln1.Pow.V = tS_ln1.solution.V;
tS_ln2.Pow.V = tS_ln2.solution.V;
tS_nl.Pow.V = tS_nl.solution.V;

TsPow    = {tS_ln1.Pow,tS_ln2.Pow,tS_nl.Pow};

axds       = getaxds({'V'},{'$V\,\mathrm{[m/s]}$'},1);

var        = {...
'PM',...
'Pmr',...
'Ptr'};

lab        = {...
'$P_M\,\mathrm[W]$',...
'$P_{mr}\,\mathrm[W]$',...
'$P_{tr}\,\mathrm[W]$'
};

unit      = [1 1 1];
azds      = getaxds(var,lab,unit);
axATa     = plotNdTrimSolution(...
            TsPow,axds,{'Linear thrusF','Linear completeF','Nonlinear'},...
           'defaultVars',azds ...
);               
