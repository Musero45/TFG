function P   = engPower(h,Psl,n,density)

rho0     = density(0);
rho      = density(h);

P        = Psl.*(rho./rho0).^n;
