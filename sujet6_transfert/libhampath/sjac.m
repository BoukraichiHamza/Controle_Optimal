function j = sjac(y,options,par,ipar)
%-------------------------------------------------------------------------------------------
%
%    sjac (needs sfun.f90)
%
%    Description
%
%        Computes the Jacobian of the shooting-homotopic function
%
%    Options used
%
%        Derivative, FreeFinalTime, MaxStepsOde, MaxStepSizeOde, ODE, TolOdeAbs,
%        TolOdeRel
%
%-------------------------------------------------------------------------------------------
%
%    Matlab / Octave Usage
%
%        j = sjac(y,options,par)
%        j = sjac(y,options,par,ipar)
%
%    Inputs
%
%        y       - real vector, shooting variable
%        options - struct, hampathset options
%        par     - real vector, par in hfun and efun, par=[] if no parameters
%        ipar    - integer vector, index of parameters for which the derivative is computed
%
%    Outputs
%
%        j       - real matrix, jacobian of the shooting/homotopic function
%
%-------------------------------------------------------------------------------------------
nrhs0min = 3;
if(nargin<nrhs0min || nargin>nrhs0min+1 || nargout>1)
    error('wrong syntax: try help');
end

if(nargin==nrhs0min)
    ipar=[];
else
    nmin=min(ipar);
    nmax=max(ipar);
    if(nmin<1)
        error('ipar must contain values between 1 and length(par)');
    end
    if(nmax>length(par))
        error('ipar must contain values between 1 and length(par)');
    end
end

str=num2str(clock); str=strrep(str,' ',''); str=strrep(str,'.','');
strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'sjacIn' strFinal '.txt'];
while(exist(nomfilein,'file'))
    strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'sjacIn' strFinal '.txt'];
end;
nomfileout=[ 'sjacOu' strFinal '.m']; nomfun='sjac'; nominterface='matlab'; nomfunint=[ 'sjacOu' strFinal];

%!Description of input file
%!options
%!ny
%!npar
%!nipar
%!ipar(nipar,1)
%!y(ny,1)
%!par(npar,1)

%Create file in
[m,n]   = size(y)   ;  if(m~=1 & n~=1) error('Variable y must be a vector!') ;  end; ny    = max(m,n);
[m,n]   = size(par) ;  if(m>1 & n>1) error('Variable par must be a vector!') ;  end; npar  = max(m,n);
[m,n]   = size(ipar);  if(m>1 & n>1) error('Variable ipar must be a vector!');  end; nipar = max(m,n);
y       = y(:);    %On ecrit en ligne pour recuperer avec fortran plus facilement
par     = par(:);
ipar    = ipar(:);

fid = fopen(nomfilein,'w');
fprintf(fid,hampathget(options));
fprintf(fid,'%i\n%i\n%i\n',ny,npar,nipar);
for i=1:nipar
    fprintf(fid,'%i\n',ipar(i));
end;
fclose(fid);
save(nomfilein,'-ascii','-double','-append','y','par');

%Call main routine
p = mfilename('fullpath'); [pathstr,name,ext] = fileparts(p);
gfortranMatlab(1); flag = system([pathstr '/mainProg ' nomfilein ' ' nomfileout ' ' nomfun ' ' nominterface ' ' nomfunint]); gfortranMatlab(2);

%Get results from file out
try
    j = eval(nomfunint);
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


