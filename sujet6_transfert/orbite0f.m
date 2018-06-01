%
% Script pour tracer les orbites initiale et finale
% x0 et v0 = position et vitesse en t_0
% rf = rayon de l'orbite geostationnaire
% mu = constante gravitationnelle
%
% orbite initiale
% Calcul des parametres de l'ellipse
figure;
mu = 398600.47 * 3600 * 3600 ;
rf = 42165 ;
% valeurs initiales etat
x0 = [ -44000 0 0 -10279] ;
%x0 = [ -42272.67 0 0 -5796.72] ;
%
r0=norm(x0(1:2))
V0=norm(x0(3:4))
a=1/(2/r0-V0*V0/mu)
t1=r0*V0*V0/mu - 1;    % formule page 43 Zarrouati
t2=(x0(1:2)*x0(3:4)')/sqrt(a*mu);
e=norm([t1 t2])
p=a*(1-e^2)

npas=100;
pas=2*pi/npas;
for i=1:npas
    theta=(i-1)*pas;
    r=p/(1+e*cos(theta));
    x1(i)= r*cos(theta) ;
    x2(i)=r*sin(theta);
end
x1(npas+1)=x1(1);
x2(npas+1)=x2(2);
plot(x1,x2);
hold on
% orbite finale circulaire
%
npas=100;
pas=2*pi/npas;
for i=1:npas
    theta=(i-1)*pas;
    x1(i)= rf*cos(theta) ;
    x2(i)=rf*sin(theta);
end
x1(npas+1)=x1(1);
x2(npas+1)=x2(2);
plot(x1,x2,'g');
plot(z(1,:),z(2,:));

axis('square')     ;
