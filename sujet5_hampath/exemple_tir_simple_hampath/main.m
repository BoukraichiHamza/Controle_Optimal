% Main file for the simple shooting case
%
% Problem definition
%
%   min int_0^1 u^2
%   dot(x) = v
%   dox(v) = -lambda v^2 + u
%   x(0) = x_0, x(1) = x_f, v(0) = v_0, v(1) = v_f
%
%  \author Olivier Cots (INP-ENSEEIHT-IRIT)
%  \date   2016
%  \copyright Eclipse Public License
%
clear;
close all;
format long;
path(pathdef);

set(0,  'defaultaxesfontsize'   ,  14     , ...
'DefaultTextVerticalAlignment'  , 'bottom', ...
'DefaultTextHorizontalAlignment', 'left'  , ...
'DefaultTextFontSize'           ,  14);

addpath(['libhampath/']);

%-------------------------------------------------------------------------------------------------------------%
fprintf('\nStep 1: parameters initialization\n');

    t0      = 0.0;                                      % Initial time
    tf      = 1.0;                                      % Final time
    q0      = [-1.0 0.0]';                              % Initial state
    yGuess  = [0.1 0.1]';                               % Initial guess for the shooting metdhod
    par     = [t0 tf q0(1) q0(2) 0.0 0.0 0.0]';         % t0, tf, x_0, v_0, x_f, v_f, lambda
    options = hampathset                                % Hampath options
    n       = 2;                                        % State dimension

%-------------------------------------------------------------------------------------------------------------%
fprintf('\nStep 2: shooting\n');

    [ysol,ssol,nfev,njev,flag] = ssolve(yGuess,options,par);
    ysol = ysol';
    p0sol = ysol; % Initial adjoint vector

%-------------------------------------------------------------------------------------------------------------%
fprintf('\nStep 3: display solution\n');

    % Figure
    figure;

    % Solution
    tspan = linspace(t0,tf,101);
    [tout,z,flag] = exphvfun(tspan,[q0;p0sol],options,par);

    subplot(2,4,1);plot(tout,z(  1,:),'b');xlabel('t');ylabel('x(t)');   drawnow; title('State solution');
    subplot(2,4,2);plot(tout,z(n+1,:),'b');xlabel('t');ylabel('p_x(t)'); drawnow; title('Co-state solution');
    subplot(2,4,5);plot(tout,z(  2,:),'b');xlabel('t');ylabel('v(t)');   drawnow;
    subplot(2,4,6);plot(tout,z(n+2,:),'b');xlabel('t');ylabel('p_v(t)'); drawnow;

    % Control
    u       = control(tout,z,par);
    subplot(2,4,[3 4]);plot(tout,u,'r');xlabel('t');ylabel('u(t)'); drawnow; title('Control');


