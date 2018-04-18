function [ parout, yout, sout, niter, flag] = continuation(y0,par0,lambda_f,index_lambda,options,derivativeChoice)
%-------------------------------------------------------------------------------------------
%
%    Continuation
%
%    Description
%
%        Continuation method to solve a one-parameter family of shooting equations.
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [ parout, yout, sout, niter, flag] = continuation(y0,par0,lambda_f,index_lambda, ...
%                                                          options,derivativeChoice)
%
%    Inputs
%
%        y0             - real vector   : intial guess for shooting variable
%        par0           - real vector   : initial set of parameters
%        lambda_f       - real scalar   : final continuation parameter
%        index_lambda   - integer       : index in par vector of the continuation
%                                         parameter lambda
%        options        - struct vector : options.odeset
%                                         options.optimoptions
%                                         options.contoptions
%
%                                           with  0 < contoptions.lambda_step_min_rel     < 1
%                                                 0 < contoptions.lambda_step_initial_rel < 1
%                                                 0 < contoptions.alpha                   < 1
%                                                   contoptions.iteration_max
%                                                   contoptions.norme_sfun_max
%
%           Remark: After an iteration, if no convergence then the step is uptated as:
%
%               lambda_step = alpha * lambda_step
%
%
%        derivativeChoice - String      : must be 'finite', 'ind' or 'eqvar'
%           if 'finite' then sjac      is computed by finite differences
%           if 'ind'    then expdhvfun is computed by intern finite differences (BOCK)
%           if 'eqvar'  then expdhvfun is computed by variational equations
%
%    Outputs
%
%        parout  - real matrix      : paramters along the continuation path
%        yout    - real matrix      : shooting variable solutions along the path
%        sout    - real vector      : value of the norm of sfun at each point of yout
%        niter   - integer          : number of iterations
%        flag    - integer          : flag =  1, if lambda_f is reached
%                                     flag = -1, if iteration_max is reached
%                                     flag = -2, if lambda_step_min_rel is reached
%                                     flag = -3, if no convergence at first iteration
%
%-------------------------------------------------------------------------------------------

% Programmation défensive : on teste si les paramètres d'options vérifient les contraintes
contoptions             = options.contoptions;
lambda_step_min_rel     = contoptions.lambda_step_min_rel;
lambda_step_initial_rel = contoptions.lambda_step_initial_rel;
alpha                   = contoptions.alpha;

if(lambda_step_min_rel<=0 || lambda_step_min_rel>=1)
    error('0 < contoptions.lambda_step_min_rel < 1 is not satisfied!');
end;

if(lambda_step_initial_rel<=0 || lambda_step_initial_rel>=1)
    error('0 < contoptions.lambda_step_initial_rel < 1 is not satisfied!');
end;

if(alpha<=0 || alpha>=1)
    error('0 < contoptions.alpha < 1 is not satisfied!');
end;

if(nargin==5)
    derivativeChoice = 'eqvar';
end;

%Initialisation
lambda_0        = par0(index_lambda);
lambda_step     = lambda_step_initial_rel * (lambda_f - lambda_0);
lambda_step_min = abs(lambda_step_min_rel * (lambda_f - lambda_0));
y_n             = y0;
par_n           = par0;
lambda_n        = lambda_0;
flag            = 0;
iteration_max   = contoptions.iteration_max;
norme_sfun_max  = contoptions.norme_sfun_max;

%Options pour ssolve
optionsSolve.odeset         = options.odeset;
optionsSolve.optimoptions   = options.optimoptions;

%Préparation des sorties
parout  = [];
yout    = [];
sout    = [];
niter   = 1;

while(flag==0)

    % Résolution des équations de tir
    [ ysol, ssol, nfev, niterSsolve, flagSsolve] = ssolve(y_n,options,par_n,derivativeChoice);

    % Test de bonne convergence
    ns = norm(ssol);
    if((flagSsolve>0) & (ns<=norme_sfun_max))

        % Stockage des informations
        parout = [parout par_n(:)];
        yout   = [yout   ysol(:)];
        sout   = [sout   ns];

        % Affichage
        printIter(niter,lambda_n,ns,ysol);

        % Mise à jour ou arret si la cible est atteinte
        if (abs(lambda_f-lambda_n) <= lambda_step_min)
            flag =  1; % On a atteint la cible finale
        else
            % Mise à jour avec test si on atteint lambda_f au prochain coup
            y_n         = ysol;
            if((lambda_n + lambda_step - lambda_f) * (lambda_n - lambda_f) < 0)
                lambda_n = lambda_f;
            else
                lambda_n    = lambda_n + lambda_step;
            end;
            niter = niter + 1;
        end

    else

        if (niter == 0)
            flag = -3;
        else
            flagSsolve
            ns
            lambda_n    = lambda_n + (alpha - 1.0) * lambda_step
            lambda_step = alpha * lambda_step
        end;

    end;
    par_n(index_lambda) = lambda_n;

    % Mise à jour du flag
    if (niter > iteration_max)
        flag = -1;
    end;
    if (abs(lambda_step) < lambda_step_min)
        flag = -2; % On n'avance plus
    end;

end;

return


function printIter(niter,lambda,norm_sfun,y)

vide   = '                ';
lengthCell = length(vide);

tiretsBase = '';
for i=1:lengthCell-2
    tiretsBase = [tiretsBase '-'];
end;
tiretsAll  = '';
for i=1:4
    tiretsAll = [tiretsAll tiretsBase];
end;
tirets = ['\n' tiretsAll '--------' '\n'];

if(niter==1)
    fprintf(tirets(3:end));
    i = 0;strings = {};
    str = '| Iteration'     ; str = [str blanks(lengthCell-length(str)-4)]; i=i+1; strings{i} = str;
    str = '| lambda'        ; str = [str blanks(lengthCell-length(str))]; i=i+1; strings{i} = str;
    str = '| |S(y)|'        ; str = [str blanks(lengthCell-length(str))]; i=i+1; strings{i} = str;
    str = '| |y|'           ; str = [str blanks(lengthCell-length(str)) '|']; i=i+1; strings{i} = str;
    fprintf('%s %s %s %s',strings{:});
    fprintf(tirets);
    fprintf(tirets(3:end));
end

i = 0;strings = {};
str = sprintf('| %i',niter)         ; str = [str blanks(lengthCell-length(str)-4)]; i=i+1; strings{i} = str;
str = sprintf('| %2.9f',lambda)     ; str = [str blanks(lengthCell-length(str))]; i=i+1; strings{i} = str;
str = sprintf('| %g',norm_sfun)  ; str = [str blanks(lengthCell-length(str))]; i=i+1; strings{i} = str;
str = sprintf('| %2.9f',norm(y))    ; str = [str blanks(lengthCell-length(str)) '|']; i=i+1; strings{i} = str;
fprintf('%s %s %s %s',strings{:}) ;
fprintf(tirets);

return
