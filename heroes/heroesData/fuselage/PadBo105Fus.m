function K = PadBo105Fus(alphaF, betaF, Re)

d2r = pi/180;

if abs(alphaF) < 20*d2r
    K(1) = (-580.6-454*alphaF+6.2*alphaF^2+4648.9*alphaF^3)/(.5*1.225*30.48^2*7.5);
    K(3) = (-51.1-1202*alphaF+1515.7*alphaF^2-604.2*alphaF^3)/(.5*1.225*30.48^2*7.5);
    K(5) = (-1191.8+12752*alphaF+8201.3*alphaF^2-5796.7*alphaF^3)/(.5*1.225*30.48^2*8.56*7.5);
else
    attackX  = [-180 -160 -90 -30 0 20 90 160 180]*d2r;
    coeffX   = [.1 .08 .0 -.07 -.08 -.07 .0 .08 .1];
    attackZ  = [-180 -160 -120 -60 -20 0 20 60 120 160 180]*d2r;
    coeffZ   = [.0 .15 1.3 1.3 .15 .0 -.15 -1.3 -1.3 -.15 -0];
    attackMy = [-205 -160 -130 -60 -25 25 60 130 155 200]*d2r;
    coeffMy  = [.02 -.03 .1 .1 -.04 .02 -.1 -.1 .02 -.03];
    
    K(1) = interp1(attackX,coeffX,alphaF);
    K(3) = interp1(attackZ,coeffZ,alphaF);
    K(5) = interp1(attackMy,coeffMy,alphaF);
end

if abs(betaF)< 20*d2r
    K(2) = (-6.9-2399.0*betaF-1.7*betaF^2+12.7*betaF^3)/(.5*1.225*30.48^2*8.3);
    K(6) = (-10028*betaF)/(.5*1.225*30.48^2*8.56*8.3);
else
    sideslipY  = [-180 -150 -20 0 20 150 180]*d2r;
    coeffY     = [0 .5235 .5235 -.001213 -.5235 -.5235 0];
    sideslipMz = [-180 -120 -70 -25 0 25 70 120 180]*d2r;
    coeffMz    = [0 -0.1 -0.1 0.005 0 -0.005 0.1 0.1 0];
    K(2) = interp1(sideslipY,coeffY,betaF);
    K(6) = interp1(sideslipMz,coeffMz,betaF);
end

K(4) = 0;

end
