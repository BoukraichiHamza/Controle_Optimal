function [ parout, yout, sout, viout, dets, normS, ps, flag ] = hampath(parspan,y0,options)
%-------------------------------------------------------------------------------------------
%
%    hampath (needs sfun.f90)
%
%    Description
%
%        Interface of the homotopic method.
%
%    Options used
%        Derivative, DispIter, Display, DoSavePath, FreeFinalTime, MaxSf, MaxSfunNorm,
%        MaxStepsOde, MaxStepsOdeHam, MaxStepSizeOde, MaxStepSizeOdeHam, ODE, ODEHam,
%        StopAtTurningPoint, TolOdeAbs, TolOdeRel, TolOdeHamAbs, TolOdeHamRel,
%        TolDenseHamEnd, TolDenseHamX
%
%-------------------------------------------------------------------------------------------
%
%    Matlab / Octave Usage
%
%        [parout,yout,sout,viout,dets,normS,ps,flag] = hampath(parspan,y0,options)
%
%    Inputs
%
%        parspan - real matrix, parspan = [par0 parf]. parspan(:,i) is a parameter vector
%                    given to hfun and efun. The homotopy is from par0 to parf and of
%                    the form : (1-lambda)*par0 + lambda*parf, unless a fortran file with
%                    the subroutine parfun(lambda,lpar,par0,parf,parout), with lambda
%                    from 0 to 1, is provided.
%        y0      - initial solution, ie "sfun(y0,options,par0) = 0"
%        options - struct, hampathset options
%
%
%    Outputs
%
%        parout  - real matrix, parameters at each integration step.
%        yout    - real matrix, solutions along the paths, ie
%                   "sfun(yout(:,k),options,parout(:,k) = 0"
%        sout    - real vector, arc length at each integration step
%        viout   - real matrix, viout(:,k) = dot_c(:,k) where c = (y, lambda) and
%                   dot is the derivative w.r.t. arc length
%        dets    - real vector, det(h'(c(s)),c'(s)) at each integration step, where
%                   h is the homotpic function
%        normS   - real vector, norm of the shooting function at each integration step
%        ps      - real vector, <c'(s_old),c'(s)> at each integ. step
%        flag    - integer, flag should be 1 (ODE integrator output)
%                    if flag==0  then Sfmax is too small
%                    if flag==-1 then input is not consistent
%                    if flag==-2 then larger MaxSteps is needed
%                    if flag==-3 then step size became too small
%                    if flag==-4 then problem is problably stiff
%                    if flag==-5 then |S| is greater than NormeSfunMax
%                    if flag==-6 then the homotopic parameter do not
%                            evolve relatively wrt TolDenseHamX
%                    if flag==-7 then a turning point occurs
%
%
%-------------------------------------------------------------------------------------------
if(nargin~=3 || nargout>8)
    error('wrong syntax: try help');
end

if(size(parspan,2)==2)
    if(abs(parspan(:,1)-parspan(:,2))==0)
        parout = parspan(:,1);
        yout   = y0;
        sout   = -1;
        viout  = [];
        bifs   = {};
        dets   = -1;
        normS  = -1;
        ps     = -1;
        flag   = -1;
        fprintf('\n');
        fprintf('Warning: no continuation performed because parspan is not valid.');
        fprintf('\n');
        return
    end
end

str=num2str(clock); str=strrep(str,' ',''); str=strrep(str,'.','');
strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'hampathIn' strFinal '.txt'];
while(exist(nomfilein,'file'))
    strFinal = [str int2str(ceil(1e3*rand(1)))]; nomfilein=[ 'hampathIn' strFinal '.txt'];
end;
nomfileout=[ 'hampathOu' strFinal '.m']; nomfun='hampath'; nominterface='matlab'; nomfunint=[ 'hampathOu' strFinal];

%!Description of input file
%!options
%!ny
%!npar
%!y0(ny,1)
%!parspan(npar,2)

%Create file in
[m,n]   = size(y0)      ;  if(m~=1 & n~=1) error('Variable y0 must be a vector!');           end; ny   = max(m,n);
[npar,m]= size(parspan) ;  if(m~=2)        error('Variable parspan must have two columns!'); end;
y0      = y0(:);    %On ecrit en colonne

fid = fopen(nomfilein,'w');
fprintf(fid,hampathget(options));
fprintf(fid,'%i\n%i\n',ny,npar);
fclose(fid);
save(nomfilein,'-ascii','-double','-append','y0','parspan');

%Call main routine
p = mfilename('fullpath'); [pathstr,name,ext] = fileparts(p);
gfortranMatlab(1); flag = system([pathstr '/mainProg ' nomfilein ' ' nomfileout ' ' nomfun ' ' nominterface ' ' nomfunint]); gfortranMatlab(2);

%Get results from file out
try
[ parout, yout, sout, viout, dets, normS, ps, flag ] = eval(nomfunint);
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



