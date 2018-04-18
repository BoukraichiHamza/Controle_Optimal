% Auteur : Olivier Cots, INP-ENSEEIHT & IRIT
% Date   : Novembre 2016
%
% Etude du problème de contrôle optimal en fonction de epsilon:
% min J(u) = int_{t0}^(tf} |u(t)| - epsilon * ( ln(|u(t)|) + ln(1-|u(t)|) ) dt
% dot{x}(t) = -x(t) + u(t), u(t) in [-1, 1]
% x(0) = x0
% x(tf) = xf
%
% t0 = 0, tf = 2, x0 = 0, xf = 0.5.
%

% On réinitialise l'environnement
%
clear all;
close all;
path(pathdef);
clc;

% Des paramètres pour l'affichage
%
tirets  = ['------------------------------------------'];
LW      = 1.5;
set(0,  'defaultaxesfontsize'   ,  12     , ...
'DefaultTextVerticalAlignment'  , 'bottom', ...
'DefaultTextHorizontalAlignment', 'left'  , ...
'DefaultTextFontSize'           ,  12     , ...
'DefaultFigureWindowStyle','docked');

% On choisit un format long pour plus de détails sur les résultats numériques
%
format long;

% On ajoute dans le path, le répertoire lib contenant les routines à implémenter par l'étudiant
%
addpath(['lib/']);
addpath(['ressources/']);

% Définition des paramètres : par = [t0, tf, x0, xf, epsilon]
% Et du tspan
%
t0  = 0.0;
tf  = 2.0;
x0  = 0.0;
xf  = 0.5;

n   = length(x0); % Dimension de l'état

tspan = [t0 tf];

% Définitions des options
%
optionParDefaut = 1;
if(optionParDefaut)
    optionsODE          = odeset; %('AbsTol',1e-6,'RelTol',1e-3);
else
    optionsODE          = odeset('AbsTol',1e-6,'RelTol',1e-3);
end;
optionsNLE              = optimoptions('fsolve','display','none','Jacobian','on');
options.odeset          = optionsODE;
options.optimoptions    = optionsNLE;

%-------------------------------------------------------------------------------------------------------------
% Exercice 3.1
%-------------------------------------------------------------------------------------------------------------
% Continuation sur epsilon et visualisation des résultats
%
disp(tirets);
disp('Exercice 3.1 : Continuation sur epsilon et visualisation des résultats.');


derivativeChoice = 'eqvar';

y0          = 0.5;

epsilon_0   = 1.0;
iepsi       = 5;
par0        = [t0; tf; x0; xf; epsilon_0];

%------------------------------------------
%% A REMPLACER

epsilon_f   = 1e-6;

contoptions.lambda_step_initial_rel = 0.5;

contoptions.lambda_step_min_rel     = 1e-6;
contoptions.alpha                   = 5e-1;
contoptions.iteration_max           = 1e3;
contoptions.norme_sfun_max          = 1e-3;

%------------------------------------------
epsilons = [epsilon_0 epsilon_f]; %Choix des epsilons pour l'affichage
%------------------------------------------

%% FIN A REMPLACER
%------------------------------------------

options.contoptions = contoptions;

[ parout, yout, sout, niter, flag] = continuation(y0,par0,epsilon_f,iepsi,options,derivativeChoice);

if(flag==1) %On affiche les résultats

    % Affichage du chemin de solutions
    figRes1 = figure('units','normalized'); %Visualisation
    nbFigs1 = {2,2};

    subplot(nbFigs1{:},1); hold on; grid on; plot([1:niter], parout(iepsi,:), 'b', 'LineWidth', LW);
    xlabel('iteration'); ylabel('$\varepsilon$','Interpreter','LaTex');
    subplot(nbFigs1{:},2); hold on; grid on; plot(parout(iepsi,:),      yout, 'b', 'LineWidth', LW);
    xlabel('$\varepsilon$','Interpreter','LaTex'); ylabel('p_0');
    subplot(nbFigs1{:},3);                   semilogy(parout(iepsi,:),  sout, 'b', 'LineWidth', LW); hold on; grid on;
    xlabel('$\varepsilon$','Interpreter','LaTex'); ylabel('$|S_\varepsilon(p_0)|$','Interpreter','LaTex');

    Jes  = [];
    Jes0 = []; % Crit\`ere o\`u epsilon = 0 mais la trajectoire d\'epend de epsilon
    for i=1:length(sout)
        z0  = [x0 ; yout(:,i)];
        par = parout(:,i);
        Je  = expcost(tspan, z0, optionsODE, par, iepsi);
        Jes = [Jes ; Je];
        parAux          = par; iepsi0 = length(parAux) + 1;
        parAux(iepsi0)  = 0.0;
        Je0             = expcost(tspan, z0, optionsODE, parAux, iepsi0);
        Jes0            = [Jes0 ; Je0];
    end;
    subplot(nbFigs1{:},4); hold on; grid on;
    plot(parout(iepsi,:), Jes,  'b', 'LineWidth', LW);
    plot(parout(iepsi,:), Jes0, 'r', 'LineWidth', LW);
    xlabel('$\varepsilon$','Interpreter','LaTex');
    leg = legend('$J_\varepsilon(u_\varepsilon)$','$J_0(u_\varepsilon)$','Location','NorthWest');
    set(leg,'Interpreter','latex'); % ylabel('Critere');

    % On affiche la convergence de l'extrémale, du contrôle et du critère.
    figRes2 = figure('units','normalized'); %Visualisation
    nbFigs2 = {1,3};

    if(norm(epsilons-sort(epsilons,'descend'))>1e-8) error('Attention changer les epsilons pour l''affichage'); end;
    Neps     = length(epsilons);

    leg   = {};
    for i=1:Neps
        [vv,ii] = min(abs(epsilons(i)-parout(iepsi,:)));
        epsilon = parout(iepsi,ii);
        z0      = [x0 ; yout(:,ii)];
        par     = parout(:,ii);
        [ tout, z ] = exphvfun(tspan, z0, optionsODE, par);
        u = [];
        for j=1:length(tout)
            u = [u ; control(tout(j), z(:,j), par)];
        end;
        subplot(nbFigs2{:},1); hold on; plot(tout, z(1,:), 'LineWidth', LW);
        subplot(nbFigs2{:},2); hold on; plot(tout, z(2,:), 'LineWidth', LW);
        subplot(nbFigs2{:},3); hold on; plot(tout,      u, 'LineWidth', LW);

        % Pour la legende
        leg{i} = sprintf(['epsilon = %g'], epsilon);

        % On affiche
        drawnow;
    end;

    % Les légendes
    subplot(nbFigs2{:},1); legend(leg{:},'Location','NorthWest');
    subplot(nbFigs2{:},2); legend(leg{:},'Location','NorthWest');
    subplot(nbFigs2{:},3); legend(leg{:},'Location','NorthWest');
    subplot(nbFigs2{:},1); ylim([x0 xf]); daxes(tf,xf,'k--');

    % Les labels
    subplot(nbFigs2{:},1); xlabel('t'); ylabel('$x_\varepsilon$','Interpreter','LaTex');
    subplot(nbFigs2{:},2); xlabel('t'); ylabel('$p_\varepsilon$','Interpreter','LaTex');
    subplot(nbFigs2{:},3); xlabel('t'); ylabel('$u_\varepsilon$','Interpreter','LaTex');

else

    fprintf('Problème de convergence de la méthode de continuation. flag = %i\n', flag);

end
