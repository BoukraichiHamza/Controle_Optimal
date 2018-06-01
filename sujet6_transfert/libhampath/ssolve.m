function [ ysol, ssol, nfev, njev, flag] = ssolve(y0,options,par)
%-------------------------------------------------------------------------------------------
%
%    ssolve (needs sfun.f90)
%
%    Description
%
%        Interface of the Fortran non linear solver (hybrj) to solve the optimal
%        control problem described by the Fortran subroutines.
%
%    Options used
%        Derivative, Display, FreeFinalTime, MaxFEval, MaxStepsOde, MaxStepSizeOde, ODE,
%        SolverMethod, TolOdeAbs, TolOdeRel, TolX
%
%-------------------------------------------------------------------------------------------
%
%    Matlab / Octave Usage
%
%        [ysol,ssol,nfev,njev,flag] = ssolve(y0,options,par)
%
%    Inputs
%
%        y0      - real vector, intial guess for shooting variable
%        options - struct vector, hampathset options
%        par     - real vector, par in hfun and sfun, par=[] if no parameters
%
%    Outputs
%
%        ysol    - real vector, shooting variable solution
%        ssol    - real vector, value of sfun at ysol
%        nfev    - integer, number of evaluations of sfun
%        njev    - integer, number of evaluations of sjac
%        flag    - integer, solver output (should be 1)
%
%-------------------------------------------------------------------------------------------
if(nargin~=3 || nargout~=5)
    error('wrong syntax: try help');
end

str=num2str(clock); str=strrep(str,' ',''); str=strrep(str,'.',''); 
strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'ssolveIn' strFinal '.txt'];
while(exist(nomfilein,'file'))
    strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'ssolveIn' strFinal '.txt'];
end;
nomfileout=[ 'ssolveOu' strFinal '.m']; nomfun='ssolve'; nominterface='matlab'; nomfunint=[ 'ssolveOu' strFinal];

%!Description of input file
%!options
%!ny
%!npar
%!y0(ny,1)
%!par(npar,1)

%Create input file
[m,n]   = size(y0) ;  if(m~=1 & n~=1) error('Variable y0 must be a vector!')  ;  end; ny   = max(m,n);
[m,n]   = size(par);  if(m>1 & n>1) error('Variable par must be a vector!');  end; npar = max(m,n);
y0      = y0(:);    %On ecrit en colonne
par     = par(:);

fid = fopen(nomfilein,'w');
fprintf(fid,hampathget(options));
fprintf(fid,'%i\n%i\n',ny,npar);
fclose(fid);
save(nomfilein,'-ascii','-double','-append','y0','par');

%Call main routine
p = mfilename('fullpath'); [pathstr,name,ext] = fileparts(p);
gfortranMatlab(1); flag = system([pathstr '/mainProg ' nomfilein ' ' nomfileout ' ' nomfun ' ' nominterface ' ' nomfunint]); gfortranMatlab(2);

%Get results from file out
try
    [ ysol, ssol, nfev, njev, flag] = eval(nomfunint);
catch err
    if(exist(nomfilein,'file'))  flagAux = system(['rm ' nomfilein]);  end;
    if(exist(nomfileout,'file')) flagAux = system(['rm ' nomfileout]); end;
    error('Problem during execution!');
end;

flagAux = system(['rm ' nomfilein]);
flagAux = system(['rm ' nomfileout]);

return;

%!!******************************************************************************************!!
%! Written on 2009-2015                                                                      !!
%! by Oivier Cots - Math. Institute, Bourgogne Univ / ENSEEIHT-IRIT / INRIA Sophia-Antipolis !!
%!!******************************************************************************************!!


