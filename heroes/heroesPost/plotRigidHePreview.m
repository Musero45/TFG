function plotRigidHePreview(he,atm,myView)


%CG
x = he.geometry.xcg;
y = he.geometry.ycg;
z = he.geometry.zcg;

% % % % % figure(1)
set(gca,'XDir','reverse','ZDir','reverse')
grid on
hold on
plot3(x,y,z,'-o')

%MainRotor
x    = he.geometry.ls;
y    = he.geometry.ds;
h    = he.geometry.h;
R    = he.mainRotor.R;
epsx = he.geometry.epsilonx;
epsy = he.geometry.epsilony;

M = TAF(epsx,epsy);

r0h = M\[0;0;h];
r0  = r0h + [x; y; 0];

plotRotor(r0,R,M,'r')

%TailRotor
x    = he.geometry.ltr;
y    = he.geometry.dtr;
z    = he.geometry.htr;
R    = he.tailRotor.R;
thtr = he.geometry.thetatr;

M = TAtrF(thtr);
M = inv(M);

r0  = [x; y; z];

plotRotor(r0,R,M,'b')

%lHTP
x = he.geometry.llHTP;
y = he.geometry.dlHTP;
z = he.geometry.hlHTP;
r0 = [x; y; z];
theta = he.leftHTP.theta;
c = he.leftHTP.c;
S = he.leftHTP.S;
Gamma = he.geometry.GammalHTP;

plotStabilizer(r0,c,S,theta,Gamma,'g')

%rHTP
x = he.geometry.lrHTP;
y = he.geometry.drHTP;
z = he.geometry.hrHTP;
r0 = [x; y; z];
theta = he.rightHTP.theta;
c = he.rightHTP.c;
S = he.rightHTP.S;
Gamma = he.geometry.GammarHTP;

plotStabilizer(r0,c,S,theta,Gamma,'m')

%vf
x = he.geometry.lvf;
y = he.geometry.dvf;
z = he.geometry.hvf;
r0 = [x; y; z];
theta = he.verticalFin.theta;
c = he.verticalFin.c;
S = he.verticalFin.S;
Gamma = he.geometry.Gammavf;

plotStabilizer(r0,c,S,theta,Gamma,'c')


view(myView)
hold off

end

function plotRotor(r0,R,M,color)
marker = strcat(color,':.');
points = strcat(color,'-');

n = 50;
t = linspace(0,2*pi,n);
rA = [R*cos(t); R*sin(t); zeros(1,n)];
rF = zeros(3,20);
kA = [0;0;R/5];

TF  = r0+M\kA;
TxF = [r0(1),TF(1)];
TyF = [r0(2),TF(2)];
TzF = [r0(3),TF(3)];

for i = 1:n
    rF(:,i) = r0+M\rA(:,i);
end
plot3(r0(1),r0(2),r0(3),marker)
plot3(TxF,TyF,TzF,points);
plot3(rF(1,:),rF(2,:),rF(3,:),points)
end


function plotStabilizer(r0,c,S,theta,Gamma,color)
marker = strcat(color,':.');
points = strcat(color,'-');

rs(:,1) = [c/4*cos(theta); -S/(2*c); -c/4*sin(theta)];
rs(:,2) = [c/4*cos(theta); S/(2*c); -c/4*sin(theta)];
rs(:,3) = [-3*c/4*cos(theta); S/(2*c); 3*c/4*sin(theta)];
rs(:,4) = [-3*c/4*cos(theta); -S/(2*c); 3*c/4*sin(theta)];
rf = zeros (3,4);

T = TFS(Gamma);

for i = 1:4
    rf(:,i) = r0 + T*rs(:,i);
end

x = [rf(1,:) rf(1,1)];
y = [rf(2,:) rf(2,1)];
z = [rf(3,:) rf(3,1)];

plot3(r0(1),r0(2),r0(3),marker)
plot3(x,y,z,points)
end