% Run this script after changing the electrical constants and induction% parameters in order to obtain the figure with the following plots: (1)% the applied current over defined simulation time that initiates the% neuron activity; (2) the activation potential dynamics in time; (3) the% change of activation parameters in time which ultimately affect the% dynamics of Na, K and other ions in and out of the neuron cell%% The importance here lies in the fact that the user is able to change and% observe the influence of the temperature and the total effect of the% external magnetic field by means of the total change of magnetic flux.%% author: Ante Lojic Kapetanovicclear; clc;save_data = 0;save_figures = 0;%% global constants global E_Na E_K E_L gbar_Na gbar_K gbar_L C_m Tglobal k a b k1 k2%% HH model electrical constants setupE_Na = 50.0;        % reversal potential in Na ion channel [mV]E_K = -77.0;        % reversal potential in K ion channel [mV]E_L = -54.387;      % leakage reversal potential [mV]gbar_Na = 120.0;    % Na conductance [mS/cm^2]gbar_K = 36.0;      % K conductance [mS/cm^2]gbar_L = 0.3;       % leakage conductance [mS/cm^2]C_m = 1.0;          % membrane capacitance [F/cm^2]T = 6.3;            % temperature [°C]%% induction parameters setupk = 0.900;          % induction coefficient -- feedback gain of the mediuma = 0.400;          % memristor parameterb = 0.020;          % memeristor parameterk1 = 0.001;         % scaler for potential-based change on magnetic fluxk2 = 0.010;         % scaler for the leakage of magnetic flux%% ode system time and initial conditions setupt_span = [0, 120];V0 = -65.0;m0 = alpha_m(V0) / (alpha_m(V0)+beta_m(V0));h0 = alpha_h(V0) / (alpha_h(V0)+beta_h(V0));n0 = alpha_n(V0) / (alpha_n(V0)+beta_n(V0));rho0 = 0.1;y0 = [V0; m0; h0; n0; rho0];%% solution of the ode system via RK45 methoddatadir = fullfile('output', 'data');[t, y] = ode45(@HodgkinHuxley, t_span, y0);if save_data    writematrix(["t", "V", "m", "h", "n", "phi"; t, y], ...        fullfile(datadir, ...            ['tVmhnPhi', '_T-', num2str(T), '_k-', num2str(k), '.csv']));end%% visualization of activation potentialfigdir = fullfile('output', 'figures');fig1 = figure('renderer', 'painters', 'position', [100, 200, 800, 800]);subplot(3,1,1)iinj = I(10, t, 100);plot(t, iinj, 'b-');xlabel('t [ms]'), ylabel('I [uA/cm^2]');title('applied current, I(t)');ylim([min(iinj) - 0.1*max(iinj), 1.1*max(iinj)]);grid on;subplot(3,1,2)plot(t, y(:,1), 'b-');xlabel('t [ms]'), ylabel('V [mV]');title('action potential in time, V(t)');ylim([min(y(:,1)) - 0.1*max(y(:,1)), 1.1*max(y(:,1))]);grid on;subplot(3,1,3)plot(t, y(:,2), 'r-', t, y(:,3), 'g--', t, y(:,4), 'b-.');xlabel('t [ms]'), ylabel('n');title('activation parameters dynamics');ylim([min(y(:,2)) - 0.1*max(y(:,2)), 1.1*max(y(:,2))]);legend('m(t)', 'h(t)', 'n(t)');grid on;if save_figures    savefig(fig1, fullfile(figdir, ['V', '_t-', num2str(t_span(2)), ...        '_T-', num2str(T), '_k-', num2str(k), '.fig']));end%% visualization of activation parametersfig2 = figure('renderer', 'painters', 'position', [100, 200, 950, 400]);subplot(1,3,1)plot(y(:,1), y(:,2), 'b-');xlabel('V [mV]'), ylabel('m');title('m(V)');grid on;subplot(1,3,2)plot(y(:,1), y(:,3), 'b-');xlabel('V [mV]'), ylabel('h');title('h(V)');grid on;subplot(1,3,3)plot(y(:,1), y(:,4), 'b-');xlabel('V [mV]'), ylabel('n');title('n(V)');grid on;if save_figures    savefig(fig2, fullfile(figdir, ['mhn_V', '_t-', num2str(t_span(2)), ...        '_T-', num2str(T), '_k-', num2str(k), '.fig']));end