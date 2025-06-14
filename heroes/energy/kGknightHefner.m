function kG  = kGknightHefner(z,mu,cts2)

num   = 1./8*(1-exp(-cts2)) + z.^2;
den   = 1./4*(1+exp(-cts2)) + z.^2;

kG    = num./den;

