function [ ysol, ssol, nfev, niter, flag] = ssolve(y0,options,par)
%-------------------------------------------------------------------------------------------
%
%    ssolve
%
%    Description
%
%        Interface of the Matlab non linear solver (fsolve) to solve the optimal
%        control problem described by the sfun subroutines.
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [ysol,ssol,nfev,njev,flag] = ssolve(y0,options,par)
%
%    Inputs
%
%        y0      - real vector      : intial guess for shooting variable
%        options - struct vector    : options.odeset and options.optimoptions
%        par     - real vector      : parameters, par=[] if no parameters
%
%    Outputs
%
%        ysol    - real vector      : shooting variable solution
%        ssol    - real vector      : value of sfun at ysol
%        nfev    - integer          : number of evaluations of sfun
%        niter   - integer          : number of iterations
%        flag    - integer          : solver output (should be 1)
%
%-------------------------------------------------------------------------------------------

%% A REMPLACER
%ysol = y0;
%ssol = zeros(length(y0),1);
[X,FVAL,EXITFLAG,OUTPUT] = fsolve(@(y)sfun(y,options,par),y0);
ysol = X;
ssol = sfun(ysol,options,par);
nfev = OUTPUT.funcCount;
niter= OUTPUT.iterations;
flag = EXITFLAG;
