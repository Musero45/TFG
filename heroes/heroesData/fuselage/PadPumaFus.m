function K = PadPumaFus(alphaF, betaF, Re)

d2r = pi/180;

if abs(alphaF) < 20*d2r
    K(1) = (-822.9+44.5*alphaF+911.9*alphaF^2+1663.6*alphaF^3)/(.5*1.225*30.48^2*24.6);
    K(3) = (-458.2-5693.7*alphaF+2077.3*alphaF^2-3958.9*alphaF^3)/(.5*1.225*30.48^2*24.6);
    K(5) = (-1065.7+8745.0*alphaF+12473.5*alphaF^2-10033.0*alphaF^3)/(.5*1.225*30.48^2*14.06*24.6);
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
    K(2) = (-11672.0*betaF)/(.5*1.225*30.48^2*30.6);
    K(6) = (-24269.2*betaF+97619.0*betaF^3)/(.5*1.225*30.48^2*14.06*30.6);
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
