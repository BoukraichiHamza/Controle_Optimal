function [hv,dhv] = dhvfun(arg1,arg2,arg3,arg4,arg5)
%-------------------------------------------------------------------------------------------
%
%    dhvfun (needs hfun.f90)
%
%    Description
%
%        Computes the second member of the variational system associated to H.
%
%-------------------------------------------------------------------------------------------
%
%    Matlab / Octave Usage
%
%        [hv, dhv] = dhvfun(t, z, dz,     par) : single arc
%        [hv, dhv] = dhvfun(t, z, dz, ti, par) : multiple arcs
%
%    Inputs
%
%        t    -  real row vector, t(i) = i-th time
%        z    -  real matrix, z(:,i) = i-th state and costate
%        dz   -  real matrix, dz(:,(i-1)*k+1:i*k) = the k i-th Jacobi fields
%        ti   -  real row vector, in multiple shooting case, ti = [t0 t1 ... t_nbarc-1 tf]
%        par  -  real vector, parameters given to hfun par=[] if no parameters
%
%    Outputs
%
%        hv   -  real matrix, hamiltonian vector field at time(s) t
%        dhv  -  real matrix, Linearized of the Hamiltonian vector field at time(s) t
%
%-------------------------------------------------------------------------------------------
nrhs0min = 4;
if(nargin<nrhs0min || nargin>nrhs0min+1 || nargout>2)
    error('wrong syntax: try help');
end

t=arg1;
z=arg2;
dz=arg3;
if(nargin==nrhs0min)
    ti =[t(1) t(end)];
    par=arg4;
elseif(nargin==nrhs0min+1)
    ti=arg4;
    par=arg5;
end

str=num2str(clock); str=strrep(str,' ',''); str=strrep(str,'.','');
strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'dhvfunIn' strFinal '.txt'];
while(exist(nomfilein,'file'))
    strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'dhvfunIn' strFinal '.txt'];
end;
nomfileout=[ 'dhvfunOu' strFinal '.m']; nomfun='dhvfun'; nominterface='matlab'; nomfunint=[ 'dhvfunOu' strFinal];

%!Description of input file
%!nt
%!n
%!kdz
%!nbarc
%!lpar
%!t(1,nt)
%!z(2*n,nt)
%!dz(2*n,nt*kdz)
%!ti(1,nbarc+1)
%!par(lpar,1)

%Create file in
[m ,nt ] = size(t);     if(m>1)             error('Variable t must be a row vector or scalar!');                end;
[nn,ntz] = size(z);     if(nt~=ntz)         error('Variables t and z must have the same number of columns!');   end;
                        if(mod(nn,2)~=0)    error('Variable z must have an even number of rows!');              end; n = nn/2;
[m,nti]  = size(ti);    if(m>1)             error('Variable ti must be a row vector!');                         end; nbarc = nti - 1;
[lpar,m] = size(par);   if(m>1)             error('Variable par must be a column vector!');                     end;
kdz = size(dz,2)/nt;

fid = fopen(nomfilein,'w');
fprintf(fid,'%i\n%i\n%i\n%i\n%i\n',nt,n,kdz,nbarc,lpar);
fclose(fid);
save(nomfilein,'-ascii','-double','-append','t','z','dz','ti','par');

%Call main routine
p = mfilename('fullpath'); [pathstr,name,ext] = fileparts(p);
gfortranMatlab(1); flag = system([pathstr '/mainProg ' nomfilein ' ' nomfileout ' ' nomfun ' ' nominterface ' ' nomfunint]); gfortranMatlab(2);

%Get results from file out
try
    [hv,dhv] = eval(nomfunint);
catch err
    if(exist(nomfilein,'file'))  flagAux = system(['rm ' nomfilein]);  end;
    if(exist(nomfileout,'file')) flagAux = system(['rm ' nomfileout]); end;
    error('Problem during execution!');
end;

flagAux = system(['rm ' nomfilein]);
flagAux = system(['rm ' nomfileout]);

return;

%!!******************************************************************************************!!
%! Written on 2014                                                                           !!
%! by Oivier Cots - Math. Institute, Bourgogne Univ / ENSEEIHT-IRIT / INRIA Sophia-Antipolis !!
%!!******************************************************************************************!!

