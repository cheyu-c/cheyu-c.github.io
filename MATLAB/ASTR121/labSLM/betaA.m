function f = betaA(beta,theta);     % define the function

thetaRad = theta*pi/180;
f = beta.*sin(thetaRad)./(1-beta.*cos(thetaRad));