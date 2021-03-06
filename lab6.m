clear;clc;close all;
%% Import and Label Data for each setup
%-------------------- Setup 1 Data Import -----------------
Ri1 =  19649;
Rf1 = 196960;
G1 = Rf1/Ri1;
dG1 = G1 * sqrt( (Rf1*.01/Rf1)^2 + (Ri1*.01/Ri1)^2 );
dataSetup1 = xlsread('RawData.xlsx','Setup1');
f1 = dataSetup1(:,1);
ch1vdiv1 = dataSetup1(:,2);
dei1 = dataSetup1(:,3);
ei1 = dataSetup1(:,4)/1000;
ch2vdiv1 = dataSetup1(:,5);
deo1 = dataSetup1(:,6);
eo1 = dataSetup1(:,7)/1000;
H1 = dataSetup1(:,8);
dH1 = H1 .* sqrt( (deo1./eo1).^2 + (dei1./ei1).^2 );

%-------------------- Setup 2 Data Import -----------------
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
%-------------------- Setup 1 f0 and Delta ----------------
i = 1;
while H1(i) >= G1*.707
    i=i+1;
end
f01  = .5 * ( f1(i) + f1(i+1) ); 
df01 = .5 * abs( f1(i) - f1(i+1) );
f1_sub = f1(i-5:i+5);
H1_sub = H1(i-5:i+5);
dH1_sub = dH1( i-5:i+5);

%-------------------- Setup 2 f0 and Delta ----------------
i = 1;
while H2(i) >= G2*.707
    i=i+1;
end
f02  = .5 * ( f2(i) + f2(i+1) );
df02 = .5 * abs( f2(i) - f2(i+1) );
f2_sub = f2(i-7:i+3);
H2_sub = H2( i-7:i+3);
dH2_sub = dH2( i-7:i+3);

%% Build Analytical Model. 
GBP1 = f01*G1;
GBP2 = f02*G2;
dk1 = GBP1 * sqrt( (df01/f01)^2 + (dG1/G1)^2 ); 
dk2 = GBP2 * sqrt( (df02/f02)^2 + (dG2/G2)^2 ); 
f_theo = [100:100:1000000]';
H_theo1 = G1 ./ sqrt( 1 + (f_theo/GBP1*G1).^2 );
H_theo2 = G2 ./ sqrt( 1 + (f_theo/GBP1*G2).^2 );

%% Plot
% ==========================  Low Gain Plot ================
figure(1)
set(gca,'xscale','log','yscale','log','defaulttextinterpreter','Latex')
ylim([0 110])
hold on
p1s = scatter(f1,H1,'o','MarkerFaceColor','b');
errorbar(f1,H1,dH1,'vertical','LineStyle','none')
p1p = plot(f_theo,H_theo1,'k','LineWidth',1.5);
cutoff1 = xline(f01,'--r');
xlabel('$f[Hz]$','FontSize',12)
ylabel('$|H|$','FontSize',12)
legend([p1s cutoff1 p1p],{'Experimental Data','Cutoff Frequency','Semi-Theoricial'})
% ------------------- Minor-Plot for Figure 1 --------------
ax1 = axes('Position',[.45 .25 .2 .2]);
box on;hold on
set(gca,'xscale','log','yscale','log','defaulttextinterpreter','Latex')
plot(f1_sub,H1_sub,'o','MarkerSize',6,'MarkerFaceColor','b')
errorbar(f1_sub,H1_sub,dH1_sub,'vertical','LineStyle','none')
xline(f01,'--r');
plot(f_theo,H_theo1,'k','LineWidth',1.5);
xlabel('','FontSize',10,'Interpreter','latex')
ylabel('','FontSize',10,'Interpreter','latex')
xlim([f1_sub(1) f1_sub(end)])

% ==========================  High Gain Plot ==============
figure(2)
set(gca,'xscale','log','yscale','log','defaulttextinterpreter','Latex')
ylim([0 110])
hold on
p2s = scatter(f2,H2,'o','MarkerFaceColor','b');
errorbar(f2,H2,dH2,'vertical','LineStyle','none')
p2p = plot(f_theo,H_theo2,'k','LineWidth',1.5);
cutoff2 = xline(f02,'--r');
xlabel('$f[Hz]$','FontSize',12)
ylabel('$|H|$','FontSize',12)
legend([p2s cutoff2 p2p],{'Experimental Data','Cutoff Frequency','Semi-Theoricial'})
% ------------------- Minor-Plot for Figure 2 -------------
ax2 = axes('Position',[.25 .6 .2 .2]);
box on;hold on
set(gca,'xscale','log','yscale','log','defaulttextinterpreter','Latex')
plot(f2_sub,H2_sub,'o','MarkerSize',6,'MarkerFaceColor','b')
errorbar(f2_sub,H2_sub,dH2_sub,'vertical','LineStyle','none')
plot(f_theo,H_theo2,'k','LineWidth',1.5)
xline(f02,'--r');
xlabel('','FontSize',10,'Interpreter','latex')
ylabel('','FontSize',10,'Interpreter','latex')
xlim([f2_sub(1) f2_sub(end)])