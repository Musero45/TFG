function io = test_plotRigidHeDatabase(mode)
% This test function shows the functionality of plotRigidHePreview to have
% an overview of the geometric definition of a rigid helicopter. The test shows
% how to plot four different views of the rigid helicopter:
% - lateral view
% - upper view
% - rear view
% - 3d view
%
% The function loops through all of the current rigid helicopters located
% at: heroesData/rigidHe directory. The set of current rigid helicopters
% are:
% @practBo105
% @practPuma
% @rigidBo105
% @PadfieldBo105
% @practLynx
% @Puma
% @rigidPuma
%
% For the moment being the list of rigid helicopters should be 
% updated manually 

% Close all figures to have empty graphics axes
close all

% Define the list of rigid helicopters
listOfRigidHe = { ...
@practBo105,...
@practPuma,...
@rigidBo105,...
@PadfieldBo105,...
@practLynx,...
@Puma,...
@rigidPuma ...
};

nrigidHe = length(listOfRigidHe);

% Load the ISA atmosphere
atm = getISA;


for i = 1:nrigidHe
    figure(i)
    he           = listOfRigidHe{i}(atm);
    rigidHename  = he.id;
    set(gcf,'Name',rigidHename);
    io           = plotFourViews(he,atm);
end





function io = plotFourViews(he,atm)

% TODO output variables axes handles

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
