sr = heroesRoot;
dir = fullfile(sr,'heroesData',filesep,'fuselage');

cd(dir);

sideslip = [-180 -135 -90 -30 -15 0 15 30 90 135 180]*pi/180;
coeffX   = [.1 .08 .0 -.07 -.08 -.07 .0 .08 .1];
coeffZ   = [.0 .15 1.3 1.3 .15 .0 -.15 -1.3 -1.3 -.15 -0];
coeffMy  = [.02 -.03 .1 .1 -.04 .02 -.1 -.1 .02 -.03];

n = length(sideslip);

KX  = zeros(n,length(coeffX));
KZ  = zeros(n,length(coeffZ));
KMy = zeros(n,length(coeffMy));

% longitudinal f(alpha,beta). Padfield's coeffs g(alpha) corrected
% f(alpha,beta) = g(alpha)*cos(beta)

for i=1:length(sideslip)
KX(i,:)  = coeffX * cos (sideslip(i));
KZ(i,:)  = coeffZ * cos (sideslip(i));
KMy(i,:) = coeffMy * cos (sideslip(i));
end

save ('generalFus','KX','KZ','KMy');

clear all