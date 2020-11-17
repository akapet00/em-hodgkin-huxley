function hh_ode = HodgkinHuxley(t, y)
%% Hodgkin-Huxley neuron model
% The Hodgkin-Huxley model describes the initialization and propagation
% of action potential using a set of four coupled ordinary differential
% equations.
%
% Arguments
%   t : scalar [1xN], discrete simulation time [ms]
%   y : vector [1x5], initial conditions for membrane voltage, `V` [mV], 
%       activation parameters, `m`, `h` and `n`, respectively and for
%       magnetic flux, `phi`
% 
% Returns
%   hh_ode : matrix [5, length(t)] where the first row stands for the
%           membrane potential change over time and the following three
%           rows outline the change of activation parameters describing
%           the nature of the opening and closing ion channels gates, the
%           last row represents the magnetic flux and its change in time

    % global variables defined in the `run.m` script
    global A t_stop E_Na E_K E_L gbar_Na gbar_K gbar_L C_m T
    global k a b k1 k2
    
    % initial conditions unpacking
    V = y(1);
    m = y(2);
    h = y(3);
    n = y(4);
    phi = y(5);
    
    % ode system additionally considering the effect of the temperature and
    % magnetic flux
    hh_ode = [
        1/C_m * (I(A, t, t_stop) - gbar_Na*h*m^3*(V-E_Na) ...
                - gbar_K*n^4*(V-E_K) - gbar_L*(V-E_L) - k*(a+3*b*phi^2)*V);
        temp_scaler(T) * (alpha_m(V)*(1-m) - beta_m(V)*m);
        temp_scaler(T) * (alpha_h(V)*(1-h) - beta_h(V)*h);
        temp_scaler(T) * (alpha_n(V)*(1-n) - beta_n(V)*n);
        k1*V - k2*phi
        ];
end