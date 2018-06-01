function s  = sfun(y,options,par)
%-------------------------------------------------------------------------------------------
%
%    sfun (needs sfun.f90)
%
%    Description
%
%        Computes the shooting function
%
%    Options used
%
%        FreeFinalTime, MaxStepsOde, MaxStepSizeOde, ODE, TolOdeAbs, TolOdeRel
%
%-------------------------------------------------------------------------------------------
%
%    Matlab / Octave Usage
%
%        s = sfun(y,options,par)
%
%    Inputs
%
%        y       - real vector, shooting variable
%        options - struct, hampathset options
%        par     - real vector, par in hfun and sfun
%
%    Outputs
%
%        s       - real vector, shooting value
%
%-------------------------------------------------------------------------------------------
if(nargin~=3 || nargout>1)
    error('wrong syntax: try help');
end

str=num2str(clock); str=strrep(str,' ',''); str=strrep(str,'.','');
strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'sfunIn' strFinal '.txt'];
while(exist(nomfilein,'file'))
    strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'sfunIn' strFinal '.txt'];
end;
nomfileout=[ 'sfunOu' strFinal '.m']; nomfun='sfun'; nominterface='matlab'; nomfunint=[ 'sfunOu' strFinal];

%!Description of input file
%!options
%!ny
%!npar
%!y(ny,1)
%!par(npar,1)

%Create file
[m,n]   = size(y)  ;  if(m~=1 & n~=1) error('Variable y must be a vector!')  ;  end; ny   = max(m,n);
[m,n]   = size(par);  if(m>1 & n>1) error('Variable par must be a vector!');  end; npar = max(m,n);
y       = y(:);    %On ecrit en colonne
par     = par(:);
fid     = fopen(nomfilein,'w');
fprintf(fid,hampathget(options));
fprintf(fid,'%i\n%i\n',ny,npar);
fclose(fid);
save(nomfilein,'-ascii','-double','-append','y','par');

%Call main routine
p = mfilename('fullpath'); [pathstr,name,ext] = fileparts(p);
gfortranMatlab(1); flag = system([pathstr '/mainProg ' nomfilein ' ' nomfileout ' ' nomfun ' ' nominterface ' ' nomfunint]); gfortranMatlab(2);

%Get results from file out
try
    s = eval(nomfunint);
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


