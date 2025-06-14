function ndInertia = inertia2ndInertia(inertia,R,rho)
%INERTIA2NDINERTIA  Transforms dimensional inertial parameters into a
%nondimensional ones
%
%   P = INERTIA2NDINERTIA(I,R,rho) computes the nondimensional inertia
%   parameters at density RHO given the dimensional ones and  the main
%   rotor radius R.

num = rho*pi*R^5;

Ix  = inertia.Ix;
Iy  = inertia.Iy;
Iz  = inertia.Iz;
Ixy = inertia.Ixy;
Ixz = inertia.Ixz;
Iyz = inertia.Iyz;

gammax   = num/Ix;
gammay   = num/Iy;
gammaz   = num/Iz;
RIxy     = Ix/Iy;
RIzy     = Iz/Iy;
RIxyy    = Ixy/Iy;
RIxzy    = Ixz/Iy;
RIyzy    = Iyz/Iy;

ndInertia = struct(...
                'gammax',gammax,...
                'gammay',gammay,...
                'gammaz',gammaz,...
                'RIxy',RIxy,...
                'RIzy',RIzy,...
                'RIxyy',RIxyy,...
                'RIxzy',RIxzy,...
                'RIyzy',RIyzy ...
                );