function [tout,z,dz,flag,varargout] = expdhvfun(tspan,z0,dz0,varargin)
%-------------------------------------------------------------------------------------------
%
%    expdhvfun (needs hfun.f90)
%
%    Description
%
%        Computes the chronological exponential of the variational system associated to hv.
%
%    Options used
%
%        MaxStepsOde, MaxStepSizeOde, ODE, TolOdeAbs, TolOdeRel
%
%-------------------------------------------------------------------------------------------
%
%    Matlab / Octave Usage
%
%        [tout,z,dz,flag] = expdhvfun(tspan, z0, dz0,     options, par) : single arc
%        [tout,z,dz,flag] = expdhvfun(tspan, z0, dz0, ti, options, par) : multiple arcs
%
%    Inputs
%
%        tspan   - real row vector, tspan = [tspan1 tspan2 ... tspanf] must be sorted and
%                    included in ti, if any.
%        z0      - real vector, initial flow
%        dz0     - real matrix, initial Jacobi fields
%        ti      - real row vector, in multiple shooting case ti = [t0 t1 ... t_nbarc-1 tf]
%                    must be increasing.
%        options - struct vector, hampathset options
%        par     - real vector, parameters given to hfun par=[] if no parameters
%
%    Outputs
%
%        tout    - real row vector, time at each integration step
%        z       - real matrix, flow at time tout
%        dz      - real matrix, Jacobi fields at time tout
%        flag    - integer, flag should be 1 (ODE integrator output)
%        nfev    - integer, number of function evaluations
%
%-------------------------------------------------------------------------------------------
nrhs0min = 5;
if(nargin<nrhs0min || nargin>nrhs0min+1 || nargout>5 || nargout<4)
    error('wrong syntax: try help');
end

if(nargin==nrhs0min)
    ti =[tspan(1) tspan(end)];
    options=varargin{1};
    par=varargin{2};
elseif(nargin==nrhs0min+1)
    ti=varargin{1};
    options=varargin{2};
    par=varargin{3};
end

str=num2str(clock); str=strrep(str,' ',''); str=strrep(str,'.','');
strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'expdhvfunIn' strFinal '.txt'];
while(exist(nomfilein,'file'))
    strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'expdhvfunIn' strFinal '.txt'];
end;
nomfileout=[ 'expdhvfunOu' strFinal '.m']; nomfun='expdhvfun'; nominterface='matlab'; nomfunint=[ 'expdhvfunOu' strFinal];

%!Description of input file
%!options
%!nt
%!n
%!nbarc
%!lpar
%!tspan(1,nt)
%!z0(2*n,1)
%!ti(1,nbarc+1)
%!par(lpar,1)

%Create file in
[m ,nt ] = size(tspan); if(m>1)             error('Variable tspan must be a row vector!');                      end;
[nn,ntz] = size(z0);    if(ntz>1)           error('Variables z0 must be a column vector!');                     end;
                        if(mod(nn,2)~=0)    error('Variable z0 must have an even number of rows!');             end; n = nn/2;
[nn,kdz] = size(dz0);   if(nn~=2*n)         error('Variable dz0 must have the same number of rows than z0!');   end;
[m,nti]  = size(ti);    if(m>1)             error('Variable ti must be a row vector!');                         end; nbarc = nti - 1;
[lpar,m] = size(par);   if(m>1)             error('Variable par must be a column vector!');                     end;

fid = fopen(nomfilein,'w');
fprintf(fid,hampathget(options));
fprintf(fid,'%i\n%i\n%i\n%i\n%i\n',nt,n,kdz,nbarc,lpar);
fclose(fid);
save(nomfilein,'-ascii','-double','-append','tspan','z0','dz0','ti','par');

%Call main routine
p = mfilename('fullpath'); [pathstr,name,ext] = fileparts(p);
gfortranMatlab(1); flag = system([pathstr '/mainProg ' nomfilein ' ' nomfileout ' ' nomfun ' ' nominterface ' ' nomfunint]); gfortranMatlab(2);

%Get results from file out
try
    [tout,z,dz,flag,nfev] = eval(nomfunint);
    if(nargout==4)
        varargout{1} = nfev;
    end;
catch err
    if(exist(nomfilein,'file'))  flagAux = system(['rm ' nomfilein]);  end;
    if(exist(nomfileout,'file')) flagAux = system(['rm ' nomfileout]); end;
    error('Problem during execution!');
end;

flagAux = system(['rm ' nomfilein]);
flagAux = system(['rm ' nomfileout]);

return;

%!!******************************************************************************************!!
%! Written on 2009-2013                                                                      !!
%! by Oivier Cots - Math. Institute, Bourgogne Univ / ENSEEIHT-IRIT / INRIA Sophia-Antipolis !!
%!!******************************************************************************************!!

