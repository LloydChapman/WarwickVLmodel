function dXdt=LnrsdInfctnSubsystem(t,X,lambda,T,Sigma,nVstar,b,pH,sigma,muV,a1,a2,omega)
%LNRSDINFCTNSUBSYSTEM Define linearised infection sub-system.
nV=nVstar*exp(muV*a1*sin(omega*t+a2)/omega);
alphaV=muV*(1+a1*cos(omega*t+a2));
T(1,end)=b*pH*nV;
Sigma(end-1,end-1)=sigma+alphaV;
Sigma(end,end)=alphaV;
dXdt=(T/lambda-Sigma)*X;