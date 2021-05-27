%% Pulse simulation
%
% Simple implementation of pulse behaviour
%
%% Code
%
% First load the laser parameters (these include the width of the guide)

%% 
% The param structure contains the following fields. Edit the
% line if you want to change any of the values

param.yn = 1;           % carrier recombination rate (1/tau_N)
param.kp = 326.7974;	% cavity loss rate (1/(2*tau_p))
param.aH = 2;           % Linewidth enhancement factor
param.kinj = 0;         % Injection level rate (K_inj/tau_N)
param.DWA = 0;          % Free-running minus laser A angular frequency 
param.DWB = 0;          % Free-running minus laser B angular frequency 
param.DWinj = 0;        % Injection detuning (W_inj - W)
param.QA = 10;          % Normalised pumping rate in guide A    
param.QB = 10;          % Normalised pumping rate in guide A 
param.etaAB = 0.53383;	% Amplitude of coupling coefficient AB (asymmetric)
param.etaBA = 0.53383;	% Amplitude of coupling coefficient BA (asymmetric) 
param.theta = 0.0;      % Phase of coupling coefficient 


% Save initial pump values for use after pulse
QA = param.QA;
QB = param.QB;

% Number of simulation points over a time interval (set to zero for
% variable step routine
sim_pts = 4000;

%%
% Next, set the initial conditions and simulation time 

% Initial conditions (type 'help getInitial' in the command window for
% details)
N0 = getInitial(param);

tsim1 = 50;         % Simulation time (in units of 1/yn)

if (sim_pts == 0)
    
    dt = 0.0;
    
else
    
    dt = tsim1/sim_pts;
    
end

%%
% Call the routine to calculate temporal dynamics (type 'help runSimulation
% for details).

[tout1, Nout1] = runSimulation(tsim1, N0, param, dt);

%%
% This runs the simulation for tsim*tau_N nanoseconds.
%
% Next, save the dynamic variables at the end of the simulation to use as
% initial values for the next run.

N0 = Nout1(end,:);   % End values of simulation
N0 = transpose(N0); % Transpose array to be in 6 x 1 form

%%
% Enter new simulation and pump values (edit these)

t_pulse = 3;        % Simulation time (short pulse)
QA_pulse = 20;      % Normalised pump power in laser A
QB_pulse = 5;       % Normalised pump power in laser B

param.QA = QA_pulse;
param.QB = QB_pulse;

if (sim_pts == 0)
    
    dt = 0.0;
    
else
    
    dt = t_pulse/sim_pts;
    
end

%%
% Run simulation again, this time with intial values and pulse pump

[tout2, Nout2] = runSimulation(t_pulse, N0, param, dt);

%%
% Again, get end values for initial values of next run

N0 = Nout2(end,:);   % End values of simulation
N0 = transpose(N0); % Transpose array to be in 5 x 1 form

%%
% Enter new simulation time

tsim2 = tsim1 - t_pulse;    % Total simulation time will be 2*tsim1

% Set pump values back to original
% Save initial pump values for use after pulse
param.QA = QA;
param.QB = QB;

if (sim_pts == 0)
    
    dt = 0.0;
    
else
    
    dt = tsim2/sim_pts;
    
end

% Call simulation one more time with original pump values

[tout3, Nout3] = runSimulation(tsim2, N0, param, dt);

%%
% Concatonate time and dynamic variables together

t1 = tout1(end);        % End time of tout1
tout2 = tout2 + t1;     % Add to tout2
t2 = tout2(end);        % End time of tout2
tout3 = tout3 + t2;     % Add to tout3

t = cat(1, tout1, tout2, tout3);
N = cat(1, Nout1, Nout2, Nout3);

%%
% Output values (uncomment any others you want to plot)
% MA  = N(:,1);
% MB  = N(:,2);
YA  = N(:,3);
YB  = N(:,4);
phiA = N(:,5);
phiB = N(:,6);

%%
% Calculate intensities from optical fields
IA = YA.*YA;
IB = YB.*YB;

%%
% Plot results

lw = 1.5;       % graph linewidth
figure;
hold on;
plot(t, IA, 'LineWidth', lw);
plot(t, IB, 'LineWidth', lw);
title('Intensities');
ylabel('Optical intensity');
xlabel('Simulation time (\tau_{N})');
legend('I_{A}','I_{B}');
grid on;

%
% Zoom in on pulse

xlim([47 56]);

% Second figure

figure;
hold on;
plot(t, phiA, 'LineWidth', lw);
plot(t, phiB, 'LineWidth', lw);
title('Phases');
ylabel('Optical phases');
xlabel('Simulation time (\tau_{N})');
legend('\Phi_{1}','\Phi_{2}');
grid on;

%%
% Zoom in on pulse

xlim([47 56]);
