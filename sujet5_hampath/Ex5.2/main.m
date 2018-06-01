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
ysol = 0.5;
figure;
epsilons = [ 1 0.5 0.1 1e-6];
color = [ 'b' 'y' 'r' 'k'];
for i = 1:4
    epsilon=epsilons(i)

    %-------------------------------------------------------------------------------------------------------------%
    fprintf('\nStep 1: parameters initialization\n');
    
    
    t0      = 0.0;                                      % Initial time
    tf      = 2.0;                                      % Final time
    x0      = 0.0;
    xf      = 0.5;
    %q0      = [-1.0 0.0]';                              % Initial state
    yGuess  = ysol;                               % Initial guess for the shooting metdhod
    par     = [t0 tf x0 xf epsilon]';                 % t0, tf, x_0,  x_f, eps
    options = hampathset                                % Hampath options
    n       = 1;                                        % State dimension
    
    %-------------------------------------------------------------------------------------------------------------%
    fprintf('\nStep 2: shooting\n');
    
    [ysol,ssol,nfev,njev,flag] = ssolve(yGuess,options,par);
    ysol = ysol';
    p0sol = ysol; % Initial adjoint vector
    
    %-------------------------------------------------------------------------------------------------------------%
    fprintf('\nStep 3: display solution\n');
    
    
    
    % Solution
    tspan = linspace(t0,tf,101);
    [tout,z,flag] = exphvfun(tspan,[x0;p0sol],options,par);
    
    subplot(1,4,1);plot(tout,z(  1,:),color(i));xlabel('t');ylabel('x(t)');   drawnow; title('State solution');
    hold on
    legend('1','0.5','0.1','1e-6')
    subplot(1,4,2);plot(tout,z(n+1,:),color(i));xlabel('t');ylabel('p_x(t)'); drawnow; title('Co-state solution');
    hold on
    legend('1','0.5','0.1','1e-6')

    % Control
    u       = control(tout,z,par);
    subplot(1,4,[3 4]);plot(tout,u,color(i));xlabel('t');ylabel('u(t)'); drawnow; title('Control');
    hold on
    legend('1','0.5','0.1','1e-6')
end



