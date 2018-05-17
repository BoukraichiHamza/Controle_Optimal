function dhv = dhvfun(t, z, dz, par, derivativeChoice,iarc)
%-------------------------------------------------------------------------------------------
%
%    dhvfun
%
%    Description
%
%        Computes the linearized of the Hamiltonian vector field associated to H.
%
%-------------------------------------------------------------------------------------------
%
%    Usage
%
%        dhv = dhvfun(t, z, dz, par, derivativeChoice)
%
%    Inputs
%
%        t                  -  real        : time
%        z                  -  real vector : state and costate
%        dz                 -  real matrix : variation of z
%        par                -  real vector : parameters, par=[] if no parameters
%        derivativeChoice   -  string      : 'eqvar' or 'ind'
%
%    Outputs
%
%        dhv  -  real vector : dhv = dhv(z) . dz
%
%-------------------------------------------------------------------------------------------

switch derivativeChoice

    case 'ind' % Diff\'erence finie sur le syst\`eme hamiltonien
        eta = sqrt(eps);
        dhv  = finiteDiff(@(z)hvfun(t,z,par,iarc),z,dz,eta);

    case 'eqvar'

        dhv  = [ -1  dcontrol(t, z, par,iarc); 0 1]*dz;

    otherwise
        error('derivativeChoice ne peut prendre les valeurs : ''eqvar'' ou ''ind''');
end;
