function io = gazelle_stabNasa88351(mode)
%% Helicopter Trim and Stabillity Analysis
% This demo shows how to use trim and stability functions to understand 
% how to obtain helicopter trim state, helicopter components actions,
% helicopter stability derivatives, helicopter control derivatives,
% helicopter linear stability eigenvalues and eigenvectors. 

close all
clear all
setPlot;

atm           = getISA;
he            = rigidGazelle(atm);

options       = setHeroesRigidOptions;


hsl            = 50;
ndHe           = rigidHe2ndHe(he,atm,hsl);

muWT          = [0; 0; 0];
ndV           = linspace(0.05,0.36,21); % pag 18
FC            = {'VOR',ndV,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};

%%
% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);
% % save ndtsTStab
% % load ('ndtsTStab')

azdsTS        = getaxds(...
                {'Theta','Phi',...
                 'theta0','theta1C',...
                 'theta1S','theta0tr'},...
                {'$$\Theta$$ [$^o$]','$\Phi$ [$^o$]',...
                 '$$\theta_{0}$$ [$$^o$$]','$$\theta_{1C}$$ [$$^o$$]',...
                 '$$\theta_{1S}$$ [$$^o$$]','$$\theta_{0tr}$$ [$$^o$$]'},...
                 [180/pi,180/pi, ...
                  180/pi,180/pi,...
                  180/pi,180/pi]...
                 );
axds          = getaxds({'VOR'},{'$$V/(\Omega R)$$ [-]'},1);
plotNdTrimSolution(ndts.solution,axds,[],...
                   'defaultVars',azdsTS,...
                   'plot2dMode','nFigures');

azdsACT       = getaxds({'CFx'  'CFy'  'CFz' ...
                       'CMtx' 'CMty' 'CMtz'},...
                      {'$$C_{Fx}$$ [-]' '$$C_{Fy}$$ [-]' '$$C_{Fz}$$ [-]' ...
                       '$$C_{Mx}$$ [-]' '$$C_{My}$$ [-]' '$$C_{Mz}$$ [-]'}, ...
                      [1 1 1 ...
                       1 1 1]);
plotActionsByElement(ndts.actions,axds,ndV,'defaultVars',azdsACT);               


io = 1;













% % pictures = {'picThetaGaz+HTP.bmp','picPhiGaz+HTP.bmp','pictheta0Gaz+HTP.bmp',...
% %             'pictheta1CGaz+HTP.bmp','pictheta1SGaz+HTP.bmp','pictheta0trGaz+HTP.bmp',...
% %             'picCFxGaz+HTP.bmp','picCFyGaz+HTP.bmp','picCFzGaz+HTP.bmp',...
% %             'picCMtxGaz+HTP.bmp','picCMtyGaz+HTP.bmp','picCMtzGaz+HTP.bmp'};
% %                               
% % for i=1:12;    
% % p=figure(i);    
% % saveas(p,pictures{i});
% % end

% % %%  How to compute trim states with different options 
% % % Now we are going to show how to compute and plot trim states with 
% % % different computing options. Default options are set by 
% % % setHeroesRigidOptions function. The way to override these default options
% % % is to define a cell with pair-values of the required options to be
% % % changed. For instance, by default setHeroesRigidOptions does not account
% % % for any aerodynamic interference between helicopter components. However,
% % % heroes provides some simple aerodynamic models to account for the main
% % % rotor wake downwash interference with the other components. For a
% % % theoretical review of these models see chapter 6 of reference [1]. In
% % % this section of the demonstration we are going to set the aerodynamic
% % % interference using a linear function by setting the fuselage, tailrotor,
% % % vertical fin, left and right horizontal tail planes interference
% % % aerodynamic models to @linearInterf. So, we define a cell of pair-values 
% % % specifying these pair-values, options1. The function parseOptions compares
% % % the subset of non-default options, options1, with the default options and
% % % sets the values defined by options1 and the other ones are set to default
% % % values. See also setHeroesRigidOptions documentation help for more
% % % information. 
% % options1       = {... 
% % 'fInterf',@linearInterf,...
% % 'trInterf',@linearInterf,...
% % 'vfInterf',@linearInterf,...
% % 'lHTPInterf',@linearInterf,...
% % 'rHTPInterf',@linearInterf ...
% % };
% % options1       = parseOptions(options1,@setHeroesRigidOptions);
% % 
% % 
% % %%
% % % Once the new options are defined they are just input to the trim and
% % % stability analysis functions. Therefore, using getNdHeTrimState we obtain
% % % a new trim state computed using the aerodynamic interferente between 
% % % main rotor and th other helicopter components. To compare both trim
% % % states and find out what the differences between both computations are we
% % % should define a cell of trim state solutions, ndtsSol. This cell of trim
% % % state solutions can be input into plotNdTrimState to plot both trim state
% % % solutions. To distinguish between both series we define a cell of legends
% % % of size 2x1 specifying a meaningful text to each cell slot.
% % 
% % % % ndts1         = getNdHeTrimState(ndHe,muWT,FC,options1);
% % % % save ndts1TStab
% % load ('ndts1TStab')
% % 
% % ndtsSol       = {ndts.solution,ndts1.solution};
% % leg           = {'Without aerodynamic interference',...
% %                  'With aerodynamic inteference'};
% % plotNdTrimSolution(ndtsSol,axds,leg,...
% %                    'defaultVars',azdsTS,...
% %                    'plot2dMode','nFigures');
% % 
% % 
% % %% Linear Stability analysis
% % 
% % % % ndSs        = getndHeLinearStabilityState(ndts,muWT,ndHe,options);
% % % % save ndSsTStab
% % load ('ndSsTStab')
% % 
% % Ss          = ndHeSs2HeSs(ndSs,he,atm,hsl,options);
% % 
% % SsStaDer      = Ss.stabilityDerivatives.staDer.AllElements;
% % V             = ndV*he.mainRotor.R*he.mainRotor.Omega;
% % SsStaDer.V    = V;
% % 
% % 
% % axds          = getaxds({'V'},{'V [m/s]'},1);
% % azdsSD        = getaxds(...
% %                 {'Fx_u',...
% %                  'My_w'},...
% %                 {'F_{x,u} [kg s^{-1}]',...
% %                  'M_{y,w} [kg m s^{-1}]'},...
% %                  [1,1] ...
% %                  );
% % plotStabilityDerivatives(SsStaDer,axds,[],...
% %                          'defaultVars',azdsSD,...
% %                          'plot2dMode','nFigures')
% % 
% %  
% % SsConDer    = Ss.controlDerivatives.conDer.AllElements;
% % SsConDer.V  = V;
% % azdsCD        = getaxds(...
% %                 {'Fz_t0',...
% %                  'My_t1S'},...
% %                 {'F_{z,\theta_0} [kg m s^{-2}]',...
% %                  'M_{y,\theta_{1S}} [kg m^2 s^{-2}]'},...
% %                  [1,1] ...
% %                  );
% % plotControlDerivatives(SsConDer,axds,[],...
% %                          'defaultVars',azdsCD,...
% %                          'plot2dMode','nFigures');
% % 
% % %%
% % % Another important variables of linear stability states are the
% % % eigenvalues and eigenvectors which describes the linear dynamic response
% % % of the linearized helicopter dynamical system.
% % %
% % % Eigenvalues are usually represented as a root loci map with the velocity
% % % modulus as a parameter. To compute the eigenvalues matlab eig function
% % % some times sorts wrongly the eigenvalues and most of the times for a
% % % proper track of the eigenvalues heroes uses eigen shuffle function to
% % % produce a properly tracked eigenvalues which are denoted with Tr. In this
% % % demonstration we use plotStabilityEigenValues to plot the stability state
% % % substructure eigenValTr. We proceed as above by defining a new structure
% % % with the eigenValTr substructure and velocity modulus as independent
% % % variable an finally we use plotStabilityEigenvalues to show the root loci
% % % map. We set the option rootLociLabsFmt to ini2end to add labels to each
% % % eigenvalue variation with velocity modulus denoting the first and the
% % % last values.
% % ssMap         = Ss.eigenSolution.eigenValTr;
% % ssMap.V       = V;
% % plotStabilityEigenvalues(ssMap,axds,[],...
% %                          'rootLociLabsFmt','ini2end');
% % 
% % 
% % %% References
% % %
% % % [1] Alvaro Cuerva Tejero, Jose Luis Espino Granado, Oscar Lopez Garcia,
% % % Jose Meseguer Ruiz, and Angel Sanz Andres. Teoria de los Helicopteros.
% % % Serie de Ingenieria y Tecnologia Aeroespacial. Universidad Politecnica
% % % de Madrid, 2008.
% % %
% % % DEVELOPMENT NOTES
% % %
% % % Two important plot functions do not work anymore with the simple case of
% % % vector flight condition and scalar helicopter. These functions are:
% % %
% % % * plotStabilityEigenvectors
% % % * plotStabilityEigencharacteristics
% % % 
% % % We should put back these functions into a working state
% % %
% % % eigW          = Ss.eigenSolution.eigW;
% % % eigW.V        = V;
% % % plotStabilityEigenvectors(eigW,axds,[]);
% % % 
% % % 
% % % charE         = Ss.eigenSolution.charValTr;
% % % charE.V       = V;
% % % plotStabilityEigencharacteristics(charE,axds,[]);

