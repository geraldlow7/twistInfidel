%% General analysis of load case 2 on the horizontal stabiliser
clear
clc
close all

%% Enter geometry of tailplane horizontal stabiliser

% rootChordLen - root chord length [m]
% tipChordLen - tip chord length [m]
% wingSemiSpan - wing semi-span [m]
% takeOffWeight - Take-off weight of entire aircraft [N]
% N - Number of stations [-]
% n - Load factor [-]
% fuelTankLen - Length of fuel tank wrt half span [m]
[vals, names] = xlsread('geometryVariables.xlsx', 'Data', 'B:C');
geoParams = containers.Map(names(2:end,1), vals);
rootChordLen_h = geoParams('rootChordLen_h');
tipChordLen = geoParams('tipChordLen_h');
aspectRatio_h = geoParams('aspectRatio_h');
MAC_h = geoParams('MAC_h');
wingSemiSpan = aspectRatio_h*MAC_h/2;
weightStabilizer_h = geoParams('weightStabilizer_h'); % get from AVD report
N = 100; % according to lecturer 
n = 1.5;

%% Enter operating conditions and pitch aerodyamic moment
CM0_h = geoParams('CM0_h'); % pitch aerodynamic moment from airofoil data
cruiseVelocity = 232.78; 
rho = 0.350085776097978;

%% Function call to get shear forces and bending moments (Left Wing)
leftWingLift = 75*10^3; % N
[x_l, chord_l, distLift_l, distWeightWing_l, shearForceWing_l, bendingMomentWing_l] = ...
    horizontal_stabilizer_load(rootChordLen_h, tipChordLen , wingSemiSpan , ...
    leftWingLift,weightStabilizer_h, N , n);

flexAxis = 0.45*chord_l; % Flex axis is 25 to 65 of chord
ac = 0.25*chord_l; % aerodynamic center
a = flexAxis - ac; % distence between the flex axis and AC
cgWing = 0.55*chord_l;
b = cgWing - flexAxis; % difference between cg with respect to chord of wing and FA

% load distributions
distLoad_l = distLift_l+distWeightWing_l;

figure;
hold on
grid on; grid minor;
title('Distributed Loads on Horizontal Stabilizer (Left)');
xlabel('Span along Wing [m]');
ylabel('Load per unit meter [N/m]');
plot(x_l,distLift_l,'b', 'LineWidth', 2) % lift
plot(x_l,distWeightWing_l,'r', 'LineWidth', 2) % self weight
plot(x_l,distLoad_l,'k', 'LineWidth', 2) % total load
legend('Elliptical Lift Distribution', 'Distributed Weight due to Self-Weight', ...
    'Total Load (including Engine Loads)');
hold off

% moment distribution
figure;
hold on;
grid on; grid minor;
title('Bending Moment Distribution across Horizontal Stabilizer (Left)');
xlabel('Span along wing [m]');
ylabel('Moment per unit meter [N]');
plot(x_l,bendingMomentWing_l,'k', 'LineWidth', 2) % all
legend('Bending Moment on the Horizontal Stabilizer (Left) due to self-weight and lift');
hold off

% shear force:
figure;
hold on;
grid on; grid minor;
title('Shear Force Distribution across Horizontal Stabilizer (Left)');
xlabel('Span along wing [m]');
ylabel('Shear Force per unit meter [N/m]');
plot(x_l, shearForceWing_l,'k', 'LineWidth', 2)
legend('Shear Force on the Horizontal Stabilizer (Left) due to self-weight and lift');
hold off

M_0_l = 0.5*rho*cruiseVelocity^2.*chord_l.^2*CM0_h;
T_l = distLift_l.*a-(distLoad_l-distLift_l).*b-M_0_l;

figure;
hold on
grid on; grid minor;
title('Torque Distribution across Horizontal Stabilizer (Left)');
xlabel('Span along Horizontal Stabilizer [m]');
ylabel('Torque per unit meter [N]');
plot(x_l,T_l, 'LineWidth', 2) % torque along span
hold off

%% Function call to get shear forces and bending moments (Right Wing)
rightWingLift = 25*10^3; % N
[x_r, chord_r, distLift_r, distWeightWing_r, shearForceWing_r, bendingMomentWing_r] = ...
    horizontal_stabilizer_load(rootChordLen_h, tipChordLen , wingSemiSpan , ...
    rightWingLift,weightStabilizer_h, N , n);

flexAxis = 0.45*chord_r; % Flex axis is 25 to 65 of chord
ac = 0.25*chord_r; % aerodynamic center
a = flexAxis - ac; % distence between the flex axis and AC
cgWing = 0.55*chord_r;
b = cgWing - flexAxis; % difference between cg with respect to chord of wing and FA

% load distributions
distLoad_r = distLift_r+distWeightWing_r;

figure;
hold on
grid on; grid minor;
title('Distributed Loads on Horizontal Stabilizer (Right)');
xlabel('Span along Wing [m]');
ylabel('Load per unit meter [N/m]');
plot(x_r,distLift_r,'b', 'LineWidth', 2) % lift
plot(x_r,distWeightWing_r,'r', 'LineWidth', 2) % self weight
plot(x_r,distLoad_r,'k', 'LineWidth', 2) % total load
legend('Elliptical Lift Distribution', 'Distributed Weight due to Self-Weight', ...
    'Total Load (including Engine Loads)');
hold off

% moment distribution
figure;
hold on;
grid on; grid minor;
title('Bending Moment Distribution across Horizontal Stabilizer (Right)');
xlabel('Span along wing [m]');
ylabel('Moment per unit meter [N]');
plot(x_r,bendingMomentWing_r,'k', 'LineWidth', 2) % all
legend('Bending Moment on the Horizontal Stabilizer (Right) due to self-weight and lift');
hold off

% shear force:
figure;
hold on;
grid on; grid minor;
title('Shear Force Distribution across Horizontal Stabilizer (Right)');
xlabel('Span along wing [m]');
ylabel('Shear Force per unit meter [N/m]');
plot(x_r, shearForceWing_r,'k', 'LineWidth', 2)
legend('Shear Force on the Wing due to self-weight and lift');
hold off


M_0_r = 0.5*rho*cruiseVelocity^2.*chord_r.^2*CM0_h;
T_r = distLift_r.*a-(distLoad_r-distLift_r).*b-M_0_r;

figure;
hold on
grid on; grid minor;
title('Torque Distribution across Horizontal Stabilizer (Right)');
xlabel('Span along Horizontal Stabilizer [m]');
ylabel('Torque per unit meter [N]');
plot(x_r,T_r, 'LineWidth', 2) % torque along span
hold off
