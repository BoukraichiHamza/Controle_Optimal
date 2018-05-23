function [ tout, exphv, flag, varargout ]  = exphvfun(arg1,arg2,arg3,arg4,arg5)
%-------------------------------------------------------------------------------------------
%
%    exphvfun (needs hfun.f90)
%
%    Description
%
%        Computes the chronological exponential of the Hamiltonian vector field hv
%        defined by h.
%
%    Options used
%
%        MaxStepsOde, MaxStepSizeOde, ODE, TolOdeAbs, TolOdeRel
%
%-------------------------------------------------------------------------------------------
%
%    Matlab / Octave Usage
%
%        [tout,exphv,flag] = exphvfun(tspan, z0,     options, par) : single arc
%        [tout,exphv,flag] = exphvfun(tspan, z0, ti, options, par) : multiple arcs
%
%    Inputs
%
%        tspan   - real row vector, tspan = [tspan1 tspan2 ... tspanf] must be sorted and
%                    included in ti, if any.
%        z0      - real vector, initial flow
%        ti      - real row vector, in multiple shooting case ti = [t0 t1 ... t_nbarc-1 tf]
%                    must be increasing.
%        options - struct vector, hampathset options
%        par     - real vector, parameters given to hfun par=[] if no parameters
%
%    Outputs
%
%        tout    - real row vector, time at each integration step
%        exphv   - real matrix, exphv(:,i) : flow at tout(i)
%        flag    - integer, flag should be 1 (ODE integrator output)
%        nfev    - integer, number of function evaluations
%
%-------------------------------------------------------------------------------------------
nrhs0min = 4;
if(nargin<nrhs0min || nargin>nrhs0min+1 || nargout>4 || nargout<3)
    error('wrong syntax: try help');
end

tspan=arg1;
z0=arg2;
if(nargin==nrhs0min)
    ti =[tspan(1) tspan(end)];
    options=arg3;
    par=arg4;
elseif(nargin==nrhs0min+1)
    ti=arg3;
    options=arg4;
    par=arg5;
end

str=num2str(clock); str=strrep(str,' ',''); str=strrep(str,'.','');
strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'exphvfunIn' strFinal '.txt'];
while(exist(nomfilein,'file'))
    strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'exphvfunIn' strFinal '.txt'];
end;
nomfileout=[ 'exphvfunOu' strFinal '.m']; nomfun='exphvfun'; nominterface='matlab'; nomfunint=[ 'exphvfunOu' strFinal];

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
[m ,nt ] = size(tspan); if(m>1)             error('Variable tspan must be a row vector!');              end;
[nn,ntz] = size(z0);    if(ntz>1)           error('Variables z0 must be a column vector!');             end;
                        if(mod(nn,2)~=0)    error('Variable z0 must have an even number of rows!');     end; n = nn/2;
[m,nti]  = size(ti);    if(m>1)             error('Variable ti must be a row vector!');                 end; nbarc = nti - 1;
[lpar,m] = size(par);   if(m>1)             error('Variable par must be a column vector!');             end;

fid = fopen(nomfilein,'w');
fprintf(fid,hampathget(options));
fprintf(fid,'%i\n%i\n%i\n%i\n',nt,n,nbarc,lpar);
fclose(fid);
save(nomfilein,'-ascii','-double','-append','tspan','z0','ti','par');

%Call main routine
p = mfilename('fullpath'); [pathstr,name,ext] = fileparts(p);
gfortranMatlab(1); flag = system([pathstr '/mainProg ' nomfilein ' ' nomfileout ' ' nomfun ' ' nominterface ' ' nomfunint]); gfortranMatlab(2);

%Get results from file out
try
    [tout,exphv,flag,nfev] = eval(nomfunint);
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

