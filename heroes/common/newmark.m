function [d,v,a] = newmark(M,c,K,F,d0,v0,newmarkParameters)

n      = size(d0,1);
dt     = newmarkParameters(1);
nts    = newmarkParameters(2);
beta   = newmarkParameters(3);
gama   = newmarkParameters(4);

d      = zeros(n,nts);
v      = zeros(n,nts);
a      = zeros(n,nts);
dic    = zeros(n,nts);
vic    = zeros(n,nts);

d(:,1) = d0(:);
v(:,1) = v0(:);

% first integration step
a(:,1)=inv(M)*(F(:,1)-diag(c(:,1))*v0-K*d0);


% main integration loop
for i=2:nts
   C=diag(c(:,i));
   B=M+gama*dt*C+beta*dt^2.*K;

   dic(:,i)  = d(:,i-1)+dt*v(:,i-1)+dt^2/2*(1-2*beta)*a(:,i-1);
   vic(:,i)  = v(:,i-1)+dt*(1-gama)*a(:,i-1);
   a(:,i)    = inv(B)*(F(:,i)-C*vic(:,i)-K*dic(:,i));
   d(:,i)    = dic(:,i)+beta*dt^2*a(:,i);
   v(:,i)    = vic(:,i)+gama*dt*a(:,i);

end


