function jac  = sjac(y,options,par,derivativeChoice)
%-------------------------------------------------------------------------------------------
%
%    sjac
%
%    Description
%
%        Computes the Jacobian of the shooting function
%
%-------------------------------------------------------------------------------------------
%
%    Matlab
%
%        s = sjac(y, options, par, derivativeChoice)
%
%    Inputs
%
%        y                  - real vector  : shooting variable
%        options            - struct       : odeset options
%        par                - real vector  : parameters, par=[] if no parameters
%        derivativeChoice   - String       : must be 'finite', 'ind' or 'eqvar'
%           if 'finite' then sjac      is computed by finite differences
%           if 'ind'    then expdhvfun is computed by intern finite differences (BOCK)
%           if 'eqvar'  then expdhvfun is computed by variational equations
%
%    Outputs
%
%        jac     - real matrix, Jacobian of the shooting value
%
%-------------------------------------------------------------------------------------------

if(nargin==3)
    derivativeChoice = 'eqvar';
end;

switch derivativeChoice

    case 'finite' %Calcul de la jacobienne de la fonction de tir par diff\'erences finies avants

        abstol = options.AbsTol;
        reltol = options.RelTol;
        if(isempty(abstol) & isempty(reltol))
            %t = sqrt(eps);          % On copie le comportement par d\'efaut de la fonction fsolve
                                    % de matlab qui utilise un pas de l'ordre de la racine carr\'ee
                                    % de l'epsilon machine pour l'approximation par diff\'erences
                                    % finies.
            t = sqrt(1e-3);
        else
            t = sqrt(max(abstol,reltol)); % on choisit un pas de l'ordre de la racine carr\'ee de
                                    % l'erreur num\'erique du calcul de la jacobienne, qui ici
                                    % vient de l'int\'egration num\'erique du syst\`eme hamiltonien
        end;

        %% A REMPLACER
        jac = finiteDiff(@(y)sfun(y,options,par),y,eye(length(y)),t);

    case {'ind'}
        n = 1;
        p0 = y(1);
        t1 = y(2);
        z1 = y(3:4);
        
        [~,~,bloc1aux] = expdhvfun([t1; par(2)] , z1, -hvfun(t1, z1, par, 2), options, par, derivativeChoice, 2);
        bloc1 = bloc1aux(1,end);
        [~,~,bloc2aux] = expdhvfun([t1; par(2)] , z1, [1 0], options, par, derivativeChoice, 2);
        bloc2 = bloc2aux(1,end);
        [~,~,bloc3aux] = expdhvfun([t1; par(2)] , z1, [0 1], options, par, derivativeChoice, 2);
        bloc3 = bloc3aux(1,end);
        [~,expz0,bloc4aux] = expdhvfun([par(1); t1] , [par(3); p0] , [0; 1] , options, par, derivativeChoice, 1);
        bloc4 = bloc4aux(1:2,end);
        bloc5 = hvfun(t1, expz0(:,end), par, 1);
        
        jac = zeros(4,4);
        jac(2,4) = 1;
        jac(1,1) = 0;
        jac(3:4,3:4) = -eye(2*n);
        jac(1,2) = bloc1;
        jac(1,3:4) = [bloc2 bloc3];
        jac(3:4,1) = bloc4;
        jac(3:4,2) = bloc5;
        
        
    case{'eqvar'}
        error('On ne peut pas choisir eqvar pour le calcul de la jacobienne !');

    otherwise
        error('Choix ne peut prendre les valeurs : ''finite'', ''eqvar'' ou ''ind''');
end
