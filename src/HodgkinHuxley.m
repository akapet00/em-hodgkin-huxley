function hh_ode = HodgkinHuxley(t, y)
% The Hodgkin-Huxley model describes the initialization and propagation
% of action potential using a set of four coupled ordinary differential
% equations.
%
% Arguments
%   t : scalar [1xN], discrete simulation time [ms]
%   y : vector [1xN], initial conditions for membrane voltage, `V` [mV], 
%       and activation parameters, `m`, `h` and `n`, respectively
% 
% Returns
%   hh_ode: matrix [4, length(t)] where the first row stands for the
%           membrane potential change over time and the following three
%           rows  outline the change of activation parameters describing
%           the nature of the opening and closing ion channels gates
%
% Author
%   Ante Lojic Kapetanovic
%
    % global variables defined in the `run.m` script
    global E_Na E_K E_L gbar_Na gbar_K gbar_L C_m T
    V = y(1);
    m = y(2);
    h = y(3);
    n = y(4);
    
    hh_ode = [
        1/C_m * (I(t) - gbar_Na*h*m^3*(V-E_Na) - gbar_K*n^4*(V-E_K) ...
                 - gbar_L*(V-E_L));
        temp_scaler(T) * (alpha_m(V)*(1-m) - beta_m(V)*m);
        temp_scaler(T) * (alpha_h(V)*(1-h) - beta_h(V)*h);
        temp_scaler(T) * (alpha_n(V)*(1-n) - beta_n(V)*n)
        ];
end