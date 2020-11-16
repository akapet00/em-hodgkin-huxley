clear;

%% global constants 
global E_Na E_K E_L gbar_Na gbar_K gbar_L C_m T

%% HH model electrical constants setup
E_Na = 50.0;        % reversal potential in Na ion channel [mV]
E_K = -77.0;        % reversal potential in K ion channel [mV]
E_L = -54.387;      % leakage reversal potential [mV]
gbar_Na = 120.0;    % Na conductance [mS/cm^2]
gbar_K = 36.0;      % K conductance [mS/cm^2]
gbar_L = 0.3;       % leakage conductance [mS/cm^2]
C_m = 1.0;          % membrane capacitance [F/cm^2]
T = 6.3;            % temperature [°C]

%% ode system time and initial conditions setup
t_span = [0, 120];
V0 = -65.0;
m0 = alpha_m(V0) / (alpha_m(V0)+beta_m(V0));
h0 = alpha_h(V0) / (alpha_h(V0)+beta_h(V0));
n0 = alpha_n(V0) / (alpha_n(V0)+beta_n(V0));
y0 = [V0; m0; h0; n0];

%% solution of the ode system via RK45 method
[t, y] = ode45(@HodgkinHuxley, t_span, y0);

%% visualization
figure('renderer', 'painters', 'position', [100, 200, 800, 600]);
subplot(3,1,1)
iinj = I(t);
plot(t, iinj, 'b-');
xlabel('t [ms]'), ylabel('I [uA/cm^2]');
title('applied current, I(t)');
ylim([min(iinj) - 0.1*max(iinj), 1.1*max(iinj)]);
grid on;

subplot(3,1,2)
plot(t, y(:,1), 'b-');
xlabel('t [ms]'), ylabel('V [mV]');
title('action potential in time, V(t)');
ylim([min(y(:,1)) - 0.1*max(y(:,1)), 1.1*max(y(:,1))]);
grid on;

subplot(3,1,3)
plot(t, y(:,2), 'r-', t, y(:,3), 'g--', t, y(:,4), 'b-.');
xlabel('t [ms]'), ylabel('n');
title('activation parameters dynamics');
ylim([min(y(:,2)) - 0.1*max(y(:,2)), 1.1*max(y(:,2))]);
legend('m(t)', 'h(t)', 'n(t)');
grid on;