%%%% Airfoil analysis example


%%% In most of the cases, the information available from a given airfoil 
%%% are the values of cl, cd and cm from a given interval of angles of
%%% attack for a certain Reynolds and Mach number, and in stationary
%%% conditions.
%%%
%%% However, during the simulations, cl and cd data from angles of attack
%%% out of the interval might be necessary.
%%%
%%% Ideally experimental values for the whole [-pi,pi] angles of attack
%%% interval should be available. In those cases, where only values of cl
%%% and cd for a limited angle of attack interval are available, there
%%% exist some techniques that allow to extrapolate the cl and cd data to the 
%%% for the whole [-pi,pi] angle of attack interval.
%%%
%%% These extrapolation techniques require to have available and
%%% experimental interval of angle of attack including the stall region.
%%%
%%%

clear all
close all

setPlot
set(0,'DefaultTextFontSize',16)
set(0,'DefaultAxesFontSize',16)

d2r = pi/180;
r2d = 1/d2r;

%%% Consider the following exprimental cl and cd data obtained in a
%%% wind tunnel for certain Reynolds and Mach numbers, Re* and M*.
%%% clData is a matrix whose first column are the experimental angle of 
%%% attack in deg and the second column are the corresponding cl values.
%%% The same for cdData.

clData = [ ...
-6.81 -0.311
-6.69 -0.310
-6.37 -0.267
-5.58 -0.185
-4.22 -0.047
-2.18 0.172
-0.21 0.393
1.18  0.541
2.95  0.744
4.08  0.872
5.37  1.026
6.63  1.138
7.69  1.242
8.70  1.341
9.62  1.412
10.74 1.433
12.02 1.420
13.70 1.277
15.46 1.211
17.12 1.221
18.93 1.183
20.81 1.122
22.86 1.041
25.16 0.982
27.69 0.869
30.32 0.781
32.19 0.714
];

cdData = [ ...
-6.81 0.0130
-6.69 0.0130
-6.37 0.0126
-5.58 0.0126
-4.22 0.0106
-2.18  0.0108
-0.21  0.0097
1.18   0.0099
2.95   0.0107
4.08   0.0102
5.37   0.0108
6.63   0.0118
7.69   0.0117
8.70   0.0136
9.62   0.0191
10.74  0.0242
12.02  0.0525
13.70  0.0764
15.46  0.0965
17.12  0.1364
18.93  0.1752
20.81  0.2068
22.86  0.2449
25.16  0.2836
27.69  0.3366
30.32  0.4069
32.19  0.4502
];

%%%Both experimental laws are represented in figure 1

figure (1)

subplot(1,2,1)
plot(clData(:,1),clData(:,2),'ko--');
hold on
grid on
xlabel('$\alpha\,\mathrm{[deg]}$');
ylabel('$c_l\,\mathrm{[-]}$');

subplot(1,2,2)
plot(cdData(:,1),cdData(:,2),'ko--');
hold on
grid on
xlabel('$\alpha\,\mathrm{[deg]}$');
ylabel('$c_d\,\mathrm{[-]}$');

clData(:,1) = clData(:,1)*d2r;
cdData(:,1) = cdData(:,1)*d2r;

linInt = [-5 5]*d2r;

mode = 'ZLL';

data = getadeltai(clData,cdData,linInt,mode);


figure (2)
    
    alphacl = clData(:,1);
    alphacd = cdData(:,1);

subplot(1,2,1)
plot(alphacl*r2d,clData(:,2),'ko-');
hold on
plot(alphacl*r2d,data.clfunC(clData(:,1)),'r.--')
grid on
xlabel('$\alpha_{C}\,\mathrm{[deg]}$');
ylabel('$c_l\,\mathrm{[-]}$');

subplot(1,2,2)
plot(alphacd*r2d,cdData(:,2),'ko-');
hold on
plot(alphacd*r2d,data.cdfunC(cdData(:,1)),'r.--')
grid on
xlabel('$\alpha_{C}\,\mathrm{[deg]}$');
ylabel('$c_d\,\mathrm{[-]}$');
sgtitle('$\mathrm{Chord\,as\,angle\,of\,attack\,reference\,line}$')

figure (3)
    
    alphacl = clData(:,1)-data.alpha0C;
    alphacd = cdData(:,1)-data.alpha0C;

subplot(1,2,1)
plot(alphacl*r2d,clData(:,2),'ko-');
hold on
plot(alphacl*r2d,data.clfunLSN(alphacl),'r.--')
grid on
xlabel('$\alpha_{LSN}\,\mathrm{[deg]}$');
ylabel('$c_l\,\mathrm{[-]}$');

subplot(1,2,2)
plot(alphacd*r2d,cdData(:,2),'ko-');
hold on
plot(alphacd*r2d,data.cdfunLSN(alphacd),'r.--')
grid on
xlabel('$\alpha_{LSN}\,\mathrm{[deg]}$');
ylabel('$c_d\,\mathrm{[-]}$');
sgtitle('$\mathrm{Zero\,lift\,line\,as\,angle\,of\,attack\,reference\,line}$')

