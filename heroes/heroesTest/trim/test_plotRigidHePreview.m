function io = test_plotRigidHePreview(mode)
% This test function shows the functionality of plotRigidHePreview to have
% an overview of the geometric definition of a rigid helicopter. The test shows
% how to plot four different views of the rigid helicopter that are
% - lateral view
% - upper view
% - rear view
% - 3d view
%
% The main difference of this test compared to test_plotRigidHeDatabase is
% that this test defines the rigid helicopter following the next chain of
% transformations:
%   desreq -> stathe -> rigidHe (without any option)
%

close all

% First load the ISA atmosphere
atm = getISA;


% Then, define the engine
numEngines = 1;
engine     = Arriel2C1(atm,numEngines);

% Set the design requirements
dr         = cesarDR;

% Get the statistical helicopter
stathe     = desreq2stathe(dr,engine);

% vertical fin surface
Svt = .805;

% horizontal tail plane chord
cHTP = .4;

% Get the rigid helicopter from the statistical helicopter without any kind
% of options
he = stathe2rigidhe(stathe,atm,cHTP,Svt);

figure(1)

subplot(2,2,1)
lateralView = [0,0];
plotRigidHePreview(he,atm,lateralView);
axis equal

subplot(2,2,3)
upperView = [0,90];
plotRigidHePreview(he,atm,upperView);
axis equal

subplot(2,2,2)
rearView = [90,0];
plotRigidHePreview(he,atm,rearView);
axis equal


subplot(2,2,4)
view3d = [30,45];
plotRigidHePreview(he,atm,view3d);
axis equal

io = 1;
