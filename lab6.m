clear;clc;close all
format short
%% Import and Label Data for each setup
Ri1 =  19649;
Rf1 = 196960;
G1 = Rf1/Ri1;
dG1 = G1 * sqrt( (Rf1*.01/Rf1)^2 + (Ri1*.01/Ri1)^2 );
dataSetup1 = xlsread('RawData.xlsx','Setup1');
f1 = dataSetup1(:,1);
ch1vdiv1 = dataSetup1(:,2);
dei1 = dataSetup1(:,3);
ei1 = dataSetup1(:,4);
ch2vdiv1 = dataSetup1(:,5);
deo1 = dataSetup1(:,6);
eo1 = dataSetup1(:,7);
H1 = dataSetup1(:,8);
dH1 = H1 .* sqrt( (deo1./eo1).^2 + (dei1./ei1).^2 );

Ri2 =  1958;
Rf2 = 196960;
G2 = Rf2/Ri2;
dG2 = G2 * sqrt( (Rf2*.01/Rf2)^2 + (Ri2*.01/Ri2)^2 );
dataSetup2 = xlsread('RawData.xlsx','Setup2');
f2 = dataSetup2(:,1);
ch1vdiv2 = dataSetup2(:,2);
dei2 = dataSetup2(:,3);
ei2 = dataSetup2(:,4);
ch2vdiv2 = dataSetup2(:,5);
deo2 = dataSetup2(:,6);
eo2 = dataSetup2(:,7);
H2 = dataSetup2(:,8);
dH2 = H2 .* sqrt( (deo2./eo2).^2 + (dei2./ei2).^2 );

%% Determine Cutoff Frequency and Uncertainty
i = 1;
while H1(i) >= G1*.707
    i=i+1;
end
f01  = .5 * ( f1(i) + f1(i+1) );
df01 = .5 * abs( f1(i) - f1(i+1) );

i = 1;
while H2(i) >= G2*.707
    i=i+1;
end
f02  = .5 * ( f2(i) + f2(i+1) );
df02 = .5 * abs( f2(i) - f2(i+1) );
%% Build Analytical Model. 
% k represents the constant associated with the Op-Amp A/(2*pi*mu)
k1 = f01*G1;
k2 = f02*G2;
dk1 = k1 * sqrt( (df01/f01)^2 + (dG1/G1)^2 ); 
dk2 = k2 * sqrt( (df02/f02)^2 + (dG2/G2)^2 ); 
f_theo = [100:100:1000000]';
H_theo1 = G1 ./ sqrt( 1 + (f_theo/k1*G1).^2 );
H_theo2 = G2 ./ sqrt( 1 + (f_theo/k2*G2).^2 );
%% Plot
figure(1)
set(gca,'xscale','log','yscale','log','defaulttextinterpreter','Latex')
ylim([0 110])
hold on
scatter(f1,H1,'o','MarkerFaceColor','b')
errorbar(f1,H1,dH1,'vertical','LineStyle','none')
plot(f_theo,H_theo1,'k','LineWidth',1.5)
xlabel('$f[Hz]$','FontSize',12)
ylabel('$|H|$','FontSize',12)

figure(2)
set(gca,'xscale','log','yscale','log','defaulttextinterpreter','Latex')
ylim([0 110])
hold on
scatter(f2,H2,'o','MarkerFaceColor','b')
errorbar(f2,H2,dH2,'vertical','LineStyle','none')
plot(f_theo,H_theo2,'k','LineWidth',1.5)
xlabel('$f[Hz]$','FontSize',12)
ylabel('$|H|$','FontSize',12)