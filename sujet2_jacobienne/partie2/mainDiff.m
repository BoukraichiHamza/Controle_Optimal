% Auteur : Olivier Cots, INP-ENSEEIHT & IRIT
% Date   : Novembre 2016
%
% Test de l'algorithme de différences finies avant
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
set(0,  'defaultaxesfontsize'   ,  14     , ...
'DefaultTextVerticalAlignment'  , 'bottom', ...
'DefaultTextHorizontalAlignment', 'left'  , ...
'DefaultTextFontSize'           ,  12     , ...
'DefaultFigureWindowStyle','docked');

figRes = figure('units','normalized'); %Visualisation
nbFigs = {3,1};

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
epsilon = 0.01;
iepsi = 5;
par = [t0; tf; x0; xf; epsilon];

n   = length(x0); % Dimension de l'état

tspan = [t0 tf];

% Définitions des options
%
optionParDefaut = 1;
if(optionParDefaut)
    optionsODE          = odeset; %('AbsTol',1e-6,'RelTol',1e-3);
else
    optionsODE          = odeset('AbsTol',1e-3,'RelTol',1e-3);
end;
optionsNLE              = optimoptions('fsolve','display','iter');%,'PlotFcn',@plotOptim);
options.odeset          = optionsODE;
options.optimoptions    = optionsNLE;

% Grille
NbPoints = 200;
yspan = linspace(0.0,1.5,NbPoints); % p0 in [0, 1.5]

%-------------------------------------------------------------------------------------------------------------
% Exercice 2.3
%-------------------------------------------------------------------------------------------------------------
% Jacobienne de la fonction de tir par différences finies avants
%
disp(tirets);
disp('Exercice 2.3 : Jacobienne de la fonction de tir par différences finies avants');

fun = @(y) sfun(y,optionsODE,par);

jacFinite = [];
for j=1:NbPoints
    jacFinite(j) = sjac(yspan(j),optionsODE,par,'finite');
    fprintf(1, '\b\b\b\b\b\b%3.1f%% ', 100*(j)/(NbPoints));
end;
fprintf(1,'\n');

subplot(nbFigs{:},1); plot(yspan, jacFinite, 'b', 'LineWidth', LW); hold on; xlabel('p_0'); ylabel('Jacobian of sfun'); title('Finite');

drawnow;

%-------------------------------------------------------------------------------------------------------------
% Exercice 2.4
%-------------------------------------------------------------------------------------------------------------
% Jacobienne de la fonction de tir par différentiation interne de Bock
%
disp(tirets);
disp('Exercice 2.4 : Jacobienne de la fonction de tir par différentiation interne de Bock');

jacIND    = [];
for j=1:NbPoints
    jacIND(j)    = sjac(yspan(j),optionsODE,par,'ind');
    fprintf(1, '\b\b\b\b\b\b%3.1f%% ', 100*(j)/(NbPoints));
end;
fprintf(1,'\n');

subplot(nbFigs{:},2); plot(yspan,    jacIND, 'b', 'LineWidth', LW); hold on; xlabel('p_0'); ylabel('Jacobian of sfun'); title('IND');

drawnow;

%-------------------------------------------------------------------------------------------------------------
% Exercice 2.5
%-------------------------------------------------------------------------------------------------------------
% Jacobienne de la fonction de tir par les équations variationnelles
%
disp(tirets);
disp('Exercice 2.5 : Jacobienne de la fonction de tir par les équations variationnelles');

jacVAR    = [];
for j=1:NbPoints
    jacVAR(j)    = sjac(yspan(j),optionsODE,par,'eqvar');
    fprintf(1, '\b\b\b\b\b\b%3.1f%% ', 100*(j)/(NbPoints));
end;
fprintf(1,'\n');

subplot(nbFigs{:},3); plot(yspan,    jacVAR, 'b', 'LineWidth', LW); hold on; xlabel('p_0'); ylabel('Jacobian of sfun'); title('EQ VAR');

drawnow;
