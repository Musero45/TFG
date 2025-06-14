close all
clear all

options = setHeroesRigidOptions;
options.GT         = 0;
options.inertialFM = 0;

%atmosphere variables needed
atm     = getISA;
g       = atm.g;
htest   = 0;
rho     = atm.density(htest);

%helicopter model selection
he   = PadfieldBo105(atm);
ndHe = rigidHe2ndHe(he,rho,g);

muWT = [0; 0; 0];
ndV = linspace(.2, .3, 16);
xcg = [.1; 0;-.1];
n = length(ndV);
m  = length(xcg);

CW = ndHe.inertia.CW;
O  = he.mainRotor.Omega;
R  = he.mainRotor.R;

fCT = zeros(6,n);
fCT(1,:) = ndV(:);
d2r = pi/180;

nlSolver  = options.nlSolver;

y    = zeros(25,n);
ndA  = zeros(9,9,n);
errA = zeros(9,9,n);
ndd  = zeros(9,n);
A    = zeros(9,9,n);
eigV = zeros(9,9,n);
dM   = zeros(9,9,n);
d    = zeros(9,n,m);
B    = zeros(9,4,n);
errB = zeros(9,4,n);

sS = cell(1,m);
tS = cell(1,m);


for j = 1:m
ndHe.geometry.Xcg = xcg(j)/R;
initialCondition = [0.05; -0.05; .25; 0.004; 0.0078; 0.135; 0.036; -0.005; 0.006; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -0.05; 0; 0; 0.007; 0; 0; 0];
    for i = 1:n
        tic;
        disp (['Solving trim...  ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
        if(norm(fCT(:,i))<eps || atan2(fCT(3,i),fCT(1,i))>86*d2r && atan2(fCT(3,i),fCT(1,i))<104*d2r)
            system2solve = @(x) helicopterTrimAxial(x,fCT(:,i),muWT,ndHe,options);
            y(1:24,i) = nlSolver(system2solve,initialCondition(1:24),options);
            y(25,i) = 0;
        else
            system2solve = @(x) helicopterTrim(x,fCT(:,i),muWT,ndHe,options);
            y(:,i) = nlSolver(system2solve,initialCondition,options);
        end
        for k = 1:25
            if abs(y(k,i))<eps
                y(k,i) = 0;
            end
        end
        initialCondition = y(:,i);
        
        control = y(3:6,i);
        y0      = y(7:24,i);
        MFT  = TFT(0,y(1,i),y(2,i));
        muV  = MFT*fCT(1:3,i);
        muWV = MFT*muWT;
        disp (['Calculating A... ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
        F = @(X) getStabilityEquations(0,X,control,muWV,y0,ndHe,options);
        X0 = [muV(1);muV(3);0;y(1,i);muV(2);0;y(2,i);0;0];
        [ndA(:,:,i),errA(:,:,i)] = jacobianest(F,X0);
        A(:,:,i) = ndA2A (ndA(:,:,i), O, R);
        [eigV(:,:,i),dM(:,:,i)] = eig(A(:,:,i));
        d(:,i,j) = diag(dM(:,:,i));
        ndd(:,i) = O.*eig(ndA(:,:,i));
%         disp (['Calculating B... ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
%         X = [muV(1);muV(3);0;y(1,i);0;0;y(2,i);0;0];
%         F = @(control) getStabilityEquations(0,X,control,muWV,y0,ndHe,options);
%         control0 = [y(3,i);y(4,i);y(5,i);y(6,i)];
%         [B(:,:,i),errB(:,:,i)] = jacobianest(F,control0);
%         toc
    end

% figure(j)
% plot(real(d(:,:,j)),imag(d(:,:,j)),'ko','Markersize',4,'MarkerFaceColor','black');
% grid on
% % axis([0 .2 0 5])
% % axis 'autox'
% xlabel('Re (s) [1/s]')
% ylabel('Im (s) [1/s]')
% name = strcat('eigMapCG',num2str(j));
% savePlot(gcf,name,{'pdf'});
%     
% sS{j}   = getStabilityState(ndA,B);
% sS{j}.V = ndV;
% 
% tS{j} = getHeTrimState(y,fCT,muWT,ndHe,options);
% % plotActionsByElement(tS{j});
end

mark = {'bo' 'rs' 'kd'};
face = {'blue' 'red' 'black'};
setPlot
set(0,'defaultlinelinewidth','factory');
figure(j+1)
hold on
box on
for j = 1:m
    plot(real(d(2:9,:,j)),imag(d(2:9,:,j)),mark{j},'Markersize',4,'MarkerFaceColor',face{j});
end
grid on
axis([0 .2 0 5])
axis 'autox'
xlabel('Re (s) [1/s]')
ylabel('Im (s) [1/s]')
name = strcat('eigMapCG',num2str(j+1));
savePlot(gcf,name,{'pdf'});

axis([0 .6 0 .35])
xlabel('Re (s) [1/s]')
ylabel('Im (s) [1/s]')
text('Position',[0.02 .27],'string','x_{CG}= 0.1 m')
text('Position',[.15 .225],'string','x_{CG}= 0 m')
text('Position',[.35 .175],'string','x_{CG}= -0.1 m')
name = strcat('eigMapCG',num2str(j+2));
savePlot(gcf,name,{'pdf'});

leg = {'adelantado' 'centrado' 'retrasado'};
% pairs = {};
% %%% Uncomment following line in order to generate output files
% pairs = {'format' {'pdf'} 'prefix' 'GC' 'closePlot' 'yes'};
% 
% plotStabilityDerivatives(sS,leg,pairs);
% plotControlDerivatives(sS,leg,pairs)
