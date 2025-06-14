function K = fuselageCoeffsInterp(alphaF, betaF, Re, aeroData)

attack   = aeroData.attackAngles;
sideslip = aeroData.sideslipAngles;
coeff    = aeroData.coeffs;

K(1) = interp2(attack.X,sideslip.X,coeff.X,alphaF,betaF);
K(2) = interp2(attack.Y,sideslip.Y,coeff.Y,alphaF,betaF);
K(3) = interp2(attack.Z,sideslip.Z,coeff.Z,alphaF,betaF);
K(4) = interp2(attack.Mx,sideslip.Mx,coeff.Mx,alphaF,betaF);
K(5) = interp2(attack.My,sideslip.My,coeff.My,alphaF,betaF);
K(6) = interp2(attack.Mz,sideslip.Mz,coeff.Mz,alphaF,betaF);

end
