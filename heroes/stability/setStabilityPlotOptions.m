function options = setStabilityPlotOptions
%  rootLociLabs - Switch to plot root loci labels [ {'yes'} | 'no']
%     This string specifies whether the root loci map has to put text
%     labels at the eigen values showing the index of the flight condition
%     parameter
%
%  rootLociLabsFmt - Defines the format of root loci text labels 
%                    ['all' |'ini2end']
%     This string Defines the format of root loci text labels. If
%     rootLociLabsFmt is set to 'all' all the eigen values are labelled. If
%     rootLociLabsFmt is set to 'ini2end' then only the first and the final
%     eigen values of an eigen mode are labelled
%

% Parent options of stability map plot 
options = setHeroesPlotOptions;

% Actual options for stability map plot
options.eigenCharNames = {'mod','omega','zeta','omegaN','invTau','t1_2','t2'};
options.eigenCharLabs  = {'|s_i|','\omega','\zeta',...
                               '\omega_N','1/\tau','t_{1,2}','t_2'};
options.mode8leg      = {'u','w','\omega_y','\Theta','v','\omega_x',...
                        '\Phi','\omega_z'};
options.mode8marker   = {'s','o','d','v','^','<','>','p'};
options.mode8liner    = {'b-s','r-.o','m--d','k-v','g-.^','b--<','r->','m--p'};
options.mode8color    = {'b','r','m','k','g','b','r','m'};
options.eigenLabs              = {'s1','s2','s3','s4','s5','s6','s7','s8'};
options.eigenText              = {'Mode 1','Mode 2','Mode 3','Mode 4',...
                                  'Mode 5','Mode 6','Mode 7','Mode 8'};
options.rootLociLabs           = 'yes';
options.rootLociLabsFmt        = 'all';
options.plotReimEigenValues    = 'yes';
options.plotLongLatEigenValues = 'yes';

