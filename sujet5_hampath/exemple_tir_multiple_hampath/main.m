% Main file for the multiple shooting case
%
% Problem definition
%
%   min tf
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

    %Parameters
    t0      = 0.0                                   % Initial time
    q0      = [-1.0  0.0]'                          % Initial state
    par     = [t0 q0(1) q0(2) 0.0 0.0 0.0]';        % t0, x_0, v_0, x_f, v_f, lambda_0
    n       = length(q0);

    %Options
    options = hampathset                            % Hampath options

    %Initial guess
    t1      = 2.0;
    tf      = 4.0;
    p0      = [0.1 0.1]';
    yGuess  = [t1 tf p0(1) p0(2)]';
    [tout,z,flag] = exphvfun([t0 t1],[q0;p0],[t0 t1 tf],options,par);
    z1      = z(:,end);
    yGuess  = [yGuess ; z1];
   
%-------------------------------------------------------------------------------------------------------------%
fprintf('\nStep 2: shooting\n');
    
    [y0,ssol,nfev,njev,flag] = ssolve(yGuess,options,par);
    y0 = y0';
    t1   = y0(1);
    tf   = y0(2);
    p0f  = y0(3:4);
    
    % --------- %
    % Attention il faut donner le vecteur ti des instants initial, de commutations et final,
    % à exphvfun et control, car il y a plusieurs arcs.
    ti   = [t0 t1 tf];

    % Figures
    figure;

    % Solution
    tspan = linspace(t0,tf,101);
    [tout,z,flag] = exphvfun(tspan,[q0;p0f],ti,options,par);

    subplot(2,4,1);plot(tout,z(  1,:),'b');xlabel('t');ylabel('x(t)');   drawnow; xlim([t0 tf]); title('State solution');
    subplot(2,4,2);plot(tout,z(n+1,:),'b');xlabel('t');ylabel('p_x(t)'); drawnow; xlim([t0 tf]); title('Co-state solution');
    subplot(2,4,5);plot(tout,z(  2,:),'b');xlabel('t');ylabel('v(t)');   drawnow; xlim([t0 tf]);
    subplot(2,4,6);plot(tout,z(n+2,:),'b');xlabel('t');ylabel('p_v(t)'); drawnow; xlim([t0 tf]);

    % Control
    u    = control(tout,z,ti,par);
    subplot(2,4,[3 4]);plot(tout,u,'r');xlabel('t');ylabel('u(t)'); drawnow; xlim([t0 tf]); title('Control');

