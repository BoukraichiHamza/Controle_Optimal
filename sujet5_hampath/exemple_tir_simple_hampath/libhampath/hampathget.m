function value = hampathget(options, name)
% hampathget -- Gets hampath package options.
%
% Usage
%  value = hampathget(options, name)
%
% Inputs
%  options - struct, options
%  name    - string, option name
%
% Outputs
%  value   - any, option value
%
% See help hampathset for the description of the different options
%
if(nargin==2 & strcmp(name,'getoptionsformex')==1)

    %On renvoie les options pour les donner aux mex-files
    value.dw  = [   options.MaxSf               ...
                    options.MaxSfunNorm         ...
                    options.MaxStepSizeOde      ...
                    options.MaxStepSizeOdeHam   ...
                    options.TolOdeAbs           ...
                    options.TolOdeRel           ...
                    options.TolOdeHamAbs        ...
                    options.TolOdeHamRel        ...
                    options.TolDenseHamEnd      ...
                    options.TolDenseHamX        ...
                    options.TolX                ];

    value.iw  = [   options.DispIter            ...
                    options.MaxFEval            ...
                    options.MaxStepsOde         ...
                    options.MaxStepsOdeHam      ...
                    options.StopAtTurningPoint  ];
                    
    value.lsw = [   length(options.Derivative)      ...
                    length(options.Display)         ...
                    length(options.DoSavePath)      ...
                    length(options.IrkInit)         ...
                    length(options.IrkSolver)       ...
                    length(options.ODE)             ...
                    length(options.ODEHam)          ...
                    length(options.SolverMethod)    ];
                    
    value.sw  = strcat(     options.Derivative,     ...
                            options.Display,        ...
                            options.DoSavePath,     ...
                            options.IrkInit,        ...
                            options.IrkSolver,      ...
                            options.ODE,            ...
                            options.ODEHam,         ...
                            options.SolverMethod    );

else

    if(nargout~=1)
        error('wrong number of outputs: try help');
    end

    if(nargin==1)

        value = [   options.Derivative                  '\n'    ...
                    int2str(options.DispIter)           '\n'    ...
                    options.Display                     '\n'    ...
                    options.DoSavePath                  '\n'    ...
                    options.IrkInit                     '\n'    ...
                    options.IrkSolver                   '\n'    ...
                    int2str(options.MaxFEval)           '\n'    ...
                    num2str(options.MaxSf)              '\n'    ...
                    num2str(options.MaxSfunNorm)        '\n'    ...
                    int2str(options.MaxStepsOde)        '\n'    ...
                    int2str(options.MaxStepsOdeHam)     '\n'    ...
                    num2str(options.MaxStepSizeOde)     '\n'    ...
                    num2str(options.MaxStepSizeOdeHam)  '\n'    ...
                    options.ODE                         '\n'    ...
                    options.ODEHam                      '\n'    ...
                    options.SolverMethod                '\n'    ...
                    int2str(options.StopAtTurningPoint) '\n'    ...
                    num2str(options.TolOdeAbs)          '\n'    ...
                    num2str(options.TolOdeRel)          '\n'    ...
                    num2str(options.TolOdeHamAbs)       '\n'    ...
                    num2str(options.TolOdeHamRel)       '\n'    ...
                    num2str(options.TolDenseHamEnd)     '\n'    ...
                    num2str(options.TolDenseHamX)       '\n'    ...
                    num2str(options.TolX)               '\n' ];

    else

        switch lower(name)
            case 'derivative' 
                value = options.Derivative;
            case 'dispiter' 
                value = options.DispIter;
            case 'display' 
                value = options.Display;
            case 'dosavepath' 
                value = options.DoSavePath;
            case 'irkinit'
                value = options.IrkInit;
            case 'irksolver'
                value = options.IrkSolver;
            case 'maxfeval' 
                value = options.MaxFEval;
            case 'maxsf' 
                value = options.MaxSf;
            case 'maxsfunnorm' 
                value = options.MaxSfunNorm;
            case 'maxstepsode' 
                value = options.MaxStepsOde;
            case 'maxstepsodeham' 
                value = options.MaxStepsOdeHam;
            case 'maxstepsizeode' 
                value = options.MaxStepSizeOde;
            case 'maxstepsizeodeham' 
                value = options.MaxStepSizeOdeHam;
            case 'ode' 
                value = options.ODE;
            case 'odeham' 
                value = options.ODEHam;
            case 'solvermethod' 
                value = options.SolverMethod;
            case 'stopatturningpoint' 
                value = options.StopAtTurningPoint;
            case 'tolodeabs' 
                value = options.TolOdeAbs;
            case 'toloderel' 
                value = options.TolOdeRel;
            case 'tolodehamabs' 
                value = options.TolOdeHamAbs;
            case 'tolodehamrel' 
                value = options.TolOdeHamRel;
            case 'toldensehamend' 
                value = options.TolDenseHamEnd;
            case 'toldensehamx' 
                value = options.TolDenseHamX;
            case 'tolx'
                value = options.TolX;
        otherwise
            error(sprintf('Unrecognized property name ''%s''.', name));
        end;

    end;

end;

 % Written on 2009-2015
 % by Oivier Cots - Math. Institute, Bourgogne Univ / ENSEEIHT-IRIT
