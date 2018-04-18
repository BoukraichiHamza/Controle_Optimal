function [ Je ] = expcost(tspan, z0, options, par, iepsi)
%-------------------------------------------------------------------------------------------
%
%    expcost
%
%    Description
%
%        Computes the cost.
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [tout, z, flag] = expcost(tspan, z0, options, iepsi)
%
%    Inputs
%
%        tspan   - real row vector of dimension 2   : tspan = [t0 tf]
%        z0      - real vector                      : initial flow
%        options - struct vector                    : odeset options
%        par     - real vector                      : parameters, par=[] if no parameters
%        iepsi   -  integer                         : index of parameter epsilon in par vector
%
%    Outputs
%
%        Je      - real                             : cost
%
%-------------------------------------------------------------------------------------------

%% A REMPLACER
[~,aux] = ode45(@(t,z)rhsfun(t,z,par,iepsi),tspan,[z0 ; 0],options);
Je = aux(end,end);

return

% Second membre du systeme augmente pour le calcul du critere
function rhs = rhsfun(t, zc, par, iepsi)

n   = (length(zc)-1)/2;
z   = zc(1:2*n);
u   = control(t,z,par);
rhs = zeros(length(zc),1);

% Dynamique sur z
rhs(1:2*n) = hvfun(t,z,par);

%% A REMPLACER
% Dynamique du cout integral
%
rhs(2*n+1) = abs(u) - par(iepsi)*(log(abs(u)) + log(1-abs(u)));

return
