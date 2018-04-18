function u = control(t, z, par)
%-------------------------------------------------------------------------------------------
%
%    control
%
%    Description
%
%        Computes the control.
%
%-------------------------------------------------------------------------------------------
%
%    Usage
%
%        u = control(t, z, par)
%
%    Inputs
%
%        t    -  real        : time
%        z    -  real vector : state and costate
%        par  -  real vector : parameters, par=[] if no parameters
%
%    Outputs
%
%        u   -  real vector : control
%
%-------------------------------------------------------------------------------------------
% par = [t0; tf; x0; xf; umax]
%
n  = length(z)/2;
x  = z(1:n);
p  = z(n+1:2*n);
umax = par(7);


%% A REMPLACER
if p(2) > umax
    u = umax;
elseif p(2) < -1*umax
    u = -1*umax;
else
    u = p(2);
end
