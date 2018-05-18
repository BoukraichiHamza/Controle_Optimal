function s  = sfun(y,options,par)
%-------------------------------------------------------------------------------------------
%
%    sfun
%
%    Description
%
%        Computes the shooting function
%
%-------------------------------------------------------------------------------------------
%
%    Matlab
%
%        s = sfun(y, options, par)
%
%    Inputs
%
%        y       - real vector  : shooting variable
%        options - struct       : odeset options
%        par     - real vector  : parameters, par=[] if no parameters
%
%    Outputs
%
%        s       - real vector, shooting value
%
%-------------------------------------------------------------------------------------------
%
% par = [t0; tf; x0; xf]
% y   = [p0; t1; z1]
%
t0 = par(1);
tf = par(2);
x0 = par(3);
xf = par(4);

n  = 1; %dimension of te state
p0 = y(1:n);
z0 = [x0;p0];

t1 = y(n+1);
z1 = y(n+2:n+2+2*n-1);

%% A REMPLACER
[ ~, Za ]  = exphvfun([t0 t1], z0, options, par, 1);
[ ~, Zb ]  = exphvfun([t1 tf], z1, options, par, 2);
s = [ xf - Zb(1:n,end); norm(z1(n+1:end,end))-1;z1 - Za(:,end)];
