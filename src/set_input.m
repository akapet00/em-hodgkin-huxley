clear;

%% save output
save_data = 0;
save_figures = 0;

if save_data
    datadir = fullfile('output', 'deterministic_model', 'data');
end
if save_figures
    figdir = fullfile('output', 'deterministic_model', 'figures');
end

%% HH model electrical constants
A = 10.0;           % amplitude of injected current density [uA/cm^2]
t_stop = 300.0;     % finish time point of injected current influence
E_Na = 50.0;        % reversal potential in Na ion channel [mV]
E_K = -77.0;        % reversal potential in K ion channel [mV]
E_L = -54.387;      % leakage reversal potential [mV]
gbar_Na = 120.0;    % Na conductance [mS/cm^2]
gbar_K = 36.0;      % K conductance [mS/cm^2]
gbar_L = 0.3;       % leakage conductance [mS/cm^2]
C_m = 1.0;          % membrane capacitance [F/cm^2]
T = 6.3;            % temperature [°C]

%% induction parameters
k = 0.100;          % induction coefficient -- feedback gain of the medium
a = 0.400;          % memristor parameter
b = 0.020;          % memeristor parameter
k1 = 0.001;         % scaler for potential-based change on magnetic flux
k2 = 0.010;         % scaler for the leakage of magnetic flux

%% ode system initial conditions
V0 = -65.0;
m0 = alpha_m(V0) / (alpha_m(V0)+beta_m(V0));
h0 = alpha_h(V0) / (alpha_h(V0)+beta_h(V0));
n0 = alpha_n(V0) / (alpha_n(V0)+beta_n(V0));
phi0 = 0.1;