% Main file for orbital transfert
%
%  \author BOUKRAICHI Hamza (INP-ENSEEIHT)
%  \date   2018
%  \copyright Eclipse Public License
%
clear;
close all;
format long;

set(0,  'defaultaxesfontsize'   ,  14     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  14);

%-------------------------------------------------------------------------------------------------------------%
fprintf('\nStep 1: parameters initialization\n');

%Parameters
t0      = 0.0;                                                  % Initial time
x0      = [-44000.0  0.0 0.0 -10279.0]';                        % Initial state
par     = [t0 x0(1) x0(2) x0(3) x0(4) 5.1658620912e12 42165.0 388.8 ]';
n       = length(x0);

%Options
options = hampathset;                            % Hampath options

%Initial guess

tf      = 4.0;
p0      = [1e-3 4e-4 1e-3 1e-4]';
yGuess  = [p0(1) p0(2) p0(3) p0(4) tf]';

%-------------------------------------------------------------------------------------------------------------%
fprintf('\nStep 2: shooting\n');

[y0,ssol,nfev,njev,flag] = ssolve(yGuess,options,par);

tf   = y0(end);
p0f  = y0(1:4)';

% --------- %
% Attention il faut donner le vecteur ti des instants initial, de commutations et final,
% à exphvfun et control, car il y a plusieurs arcs.
%ti   = [t0 t1 tf];

% Figures
figure(2)

% Solution
tspan = linspace(t0,tf,101);
[tout,z,flag] = exphvfun(tspan,[x0;p0f],options,par);

% Control
u    = control(tout,z,par);

subplot(3,3,1);plot(tout,z(1,:),'b');xlabel('t');ylabel('x1(t)');   drawnow; xlim([t0 tf]);
subplot(3,3,2);plot(tout,z(5,:),'b');xlabel('t');ylabel('p1(t)'); drawnow; xlim([t0 tf]);
subplot(3,3,3);plot(tout,z(2,:),'b');xlabel('t');ylabel('x2(t)');   drawnow; xlim([t0 tf]);
subplot(3,3,4);plot(tout,z(6,:),'b');xlabel('t');ylabel('p2(t)'); drawnow; xlim([t0 tf]);

subplot(3,3,5);plot(tout,z(3,:),'b');xlabel('t');ylabel('x3(t)');   drawnow; xlim([t0 tf]);
subplot(3,3,6);plot(tout,z(7,:),'b');xlabel('t');ylabel('p3(t)'); drawnow; xlim([t0 tf]);
subplot(3,3,7);plot(tout,z(4,:),'b');xlabel('t');ylabel('x4(t)');   drawnow; xlim([t0 tf]);
subplot(3,3,8);plot(tout,z(8,:),'b');xlabel('t');ylabel('p4(t)'); drawnow; xlim([t0 tf]);


subplot(3,3,9);plot(tout,u,'r');xlabel('t');ylabel('u(t)'); drawnow; xlim([t0 tf]);title('Control');

