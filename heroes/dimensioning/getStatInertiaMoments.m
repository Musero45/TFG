function inertiaMoments = getStatInertiaMoments(MTOW,radius)
% This FUNCTION is used to get an estimation of the inertia moments based
% on statistical interpolation from similar helicopters
%
% Example of usage:
% 
% MTOW = 2500*9.8;
% radius = 4.91;
% I = getStatInertiaMoments(MTOW,radius)
%
% which is not at all the inertia moments of Bo-105, Ixx seems quite
% different. Please note that this function provides a very crude
% approximation of the inertia moments and we can not trust too much in
% this estimation until we do not have more points to improve the data
% fitness.
%
%
% DOCUMENTATION
% The computation carried out in this function is based on the next script
%
%==========================================================================
%
% % From  reference [1] the following helicopter inertia moments data have
% % been obtained:
% %   Bo-105
% %   Lynx
% %   Puma-SA330
% %
% % From reference [2] we have taken the nominal data for the following 
% % helicopters:
% %   OH-6A
% %   AH-1G
% %   UH-1H
% %   CH-53D
% %
% % For the particular case of CH-53D which is the heviest helicopter in
% % ref [2] we have taken also the heavy configuration. The report provides 
% % also information corresponding to a light or heavy weight configuration.
% % Reference [2] has information about Bo-105, radius is the same but
% % there are some differences at inertia moment values. One thing that
% % surprised me was that the mass of the AH-1G and UH-1H are exactly the
% % same (could it be a typo) despite the fact that the inertia moments are
% % exactly the same.
% %
% % The next brief descriptions are taken from [2].
% %
% % The Hughes OH-6A i s a single-turbine, light observation helicopter
% % which has a gross weight of 1223 kg and seats two pilots plus
% % two passengers. The rotor system consists of a four-bladed, fully articu-
% % lated main rotor and is powered by a 317 shp Lycoming "63-A-w turboshaft
% % engine derated to 252.5 shp for takeoff.
% %
% %
% % The Bell AH-IG is a single turbine attack aircraft intended specifically
% % for armed helicopter missions. It cordbines the basic transmission, rotor
% % system, and power plant of the UH-IC but differs i n the fuselage.
% % The aircraft carries a crew of two seated in tandem with the pilot aft 
% % and the copilot/gunner forward. Both have a full set of flight controls,
% % however.
% %
% % The Bell UH-IH is a single turbine general purpose utility helicopter.
% % The rotor system includes a two-bladed, all-metal, semi-rigid main rotor 
% % on an underslung feathering axis hub with a stabilizer bar mounted at 
% % right angles to the main rotor blades. The vehicle is powered by
% % a Lycoming T53-L13 turbo-shaft engine rated at 1400 shaft horsepower.
% %
% % The Sikorsky CH-53D is a twin-turbine heavy assault transport helicopter.
% % With a maximum gross weight of 19050 kg, it carries a crew of three
% % and up to 64 troops. The rotor system consists of a six-bladed, fully-
% % articulated main rotor and is powered by two Y64-GE-412 (or -413) engines
% % rated at 3695 ( or 3925) shaft horsepower.
% %
% % [1] G.D. Padfield Helicopter Flight Dynamics 1996
% %
% % [2] R.K. Heffley, W.F. Jewell, J.M. Lehman, R.A. van Winkle
% % A compilation and analysis of helicopter handling qualities data.
% % Volume one:data compilation. NASA-CR-3144 (1979)
% 
% close all
% 
% 
% helabs     = {...
%               'Lynx'
%               'Bo-105'
%               'Puma-SA330'
%               'OH-6A'
%               'AH-1G'
%               'UH-1H'
%               'CH-53D (Nominal)'
%               'CH-53D (Heavy)'
% };
% 
% massHe     = [...
%               4313.7
%               2200 
%               5805
%               1157
%               3629
%               3629
%               15876
%               19051
% ];
% 
% radius     = [
%               6.4
%               4.91
%               7.5
%               4.013
%               6.706
%               7.32
%              11.009
%              11.009 
% ];
% 
% Ixx        = [
%               2767.1
%               1433
%               9638
%               446
%               3661
%               3966
%              48967
%              55076
% ];
% 
% Ixz        = [2034.8
%               660
%               2226
%               128
%               1288
%               1695
%              20050
%              20047
% ];
% 
% Iyy        = [
%               13904.5
%               4973
%               33240
%               1219
%               17354
%               14684
%              259611
%              284943
% ];
% 
% Izz        = [
%               12208.8
%               4099
%               25889
%               979
%               14643
%               12541
%              242965
%              267549
% ];
% 
% 
% % Define the independent variable
% x          = massHe.*radius.^2;
% xlab       = '\it M R ^2 \rm[kg m^2]';
% 
% % Define the set of helicopters to perform the fit
% idx        = [1,2,3,5];
% % Fit linear regresion
% pxx        = polyfit(x(idx),Ixx(idx),1);
% pxz        = polyfit(x(idx),Ixz(idx),1);
% pyy        = polyfit(x(idx),Iyy(idx),1);
% pzz        = polyfit(x(idx),Izz(idx),1);
% 
% % Evaluate linear regresion
% xi         = linspace(min(x),max(x),3);
% Ixxi       = polyval(pxx,xi);
% Ixzi       = polyval(pxz,xi);
% Iyyi       = polyval(pyy,xi);
% Izzi       = polyval(pzz,xi);
% 
% 
% figure(1)
% plot(x,Ixx,'ro'); hold on;
% plot(xi,Ixxi,'r-'); hold on;
% text(x,Ixx,helabs,'VerticalAlignment','bottom', ...
%                   'HorizontalAlignment','right')
% xlabel(xlab);ylabel('\it I_{xx} \rm[kg m^2]');
% 
% figure(2)
% plot(x,Ixz,'bs'); hold on;
% plot(xi,Ixzi,'b-'); hold on;
% text(x,Ixz,helabs,'VerticalAlignment','bottom', ...
%                   'HorizontalAlignment','right')
% xlabel(xlab);ylabel('I_{xz} \rm[kg m^2] ');
% 
% figure(3)
% plot(x,Iyy,'mv'); hold on;
% plot(xi,Iyyi,'m-'); hold on;
% text(x,Iyy,helabs,'VerticalAlignment','bottom', ...
%                   'HorizontalAlignment','right')
% xlabel(xlab);ylabel('I_{yy} \rm[kg m^2]');
% 
% figure(4)
% plot(x,Izz,'k^'); hold on;
% plot(xi,Izzi,'k-'); hold on;
% text(x,Izz,helabs,'VerticalAlignment','bottom', ...
%                   'HorizontalAlignment','right')
% xlabel(xlab);ylabel('I_{zz} \rm[kg m^2]');
% 
% 
% format longe
% disp(pxx)
% disp(pxz)
% disp(pyy)
% disp(pzz)
% 
% format short
% 
%==========================================================================


MTOM = MTOW/9.8;


pxx  = [3.067354852343361e-02    -1.142291627376396e+03];
pxz  = [5.671252321176800e-03     5.321459657335729e+02];
pyy  = [1.032399373950296e-01    -1.201271402458262e+03];
pzz  = [7.904135707828919e-02    -6.743350168534574e+00];



x    = MTOM*radius^2;
Ixx  = polyval(pxx,x);
Ixz  = polyval(pxz,x);
Iyy  = polyval(pyy,x);
Izz  = polyval(pzz,x);



inertiaMoments = struct(...
          'Ix',Ixx,...
          'Iy',Iyy,...
          'Iz',Izz,...
          'Ixy',0,...
          'Ixz',Ixz,...
          'Iyz',0 ...
          );
        




