function io = plotRigidGazelle(mode)

close all
clear all
setPlot;

atm           = getISA;
he            = rigidGazelle(atm);


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
