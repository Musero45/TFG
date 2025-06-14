function r4fRigidHe = rigidHe2r4fRigidHe(rigidHe,engine,transmission,weightConf,atm,options)

r4fRigidHe        = rigidHe;

r4fRigidHe.class = 'r4fRigidHe';
r4fRigidHe.id = strcat(['r4f' rigidHe.id]);
r4fRigidHe.engine       = engine;
r4fRigidHe.transmission = transmission;
r4fRigidHe.weightConf   = weightConf;

%New inertia
newW = weightConf.EW+weightConf.PLW+weightConf.FW+weightConf.CW;
oldW = rigidHe.inertia.W;

r4fRigidHe.inertia.W   = newW;
r4fRigidHe.inertia.Ix  = newW/oldW*rigidHe.inertia.Ix;
r4fRigidHe.inertia.Iy  = newW/oldW*rigidHe.inertia.Iy; 
r4fRigidHe.inertia.Iz  = newW/oldW*rigidHe.inertia.Iz;
r4fRigidHe.inertia.Ixy = newW/oldW*rigidHe.inertia.Ixy; 
r4fRigidHe.inertia.Ixz = newW/oldW*rigidHe.inertia.Ixz; 
r4fRigidHe.inertia.Iyz = newW/oldW*rigidHe.inertia.Iyz; 


 