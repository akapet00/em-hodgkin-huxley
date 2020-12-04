function hh_ode = HodgkinHuxley(t, y, basic_params, induction_params, ...
    periodic_current)
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
%   basic_params : vector [1x10], Hodgkin-Huxley model parameters -
%       injected currend amplitude [uA/cm^2], finish time point of injected
%       current influence [ms], Na ion channel reversal potential [mV], K
%       ion channel reversal potential [mV], leakage channel reversal
%       potential [mV], Na ion channel conductance [mS/cm^2], K ion channel
%       conductance [mS/cm^2], leakage channel conductance [mS/cm^2]
%       membrane capacitance [F/cm^2], neuron ambient temperature [°C]
%   induction_params : vector [1x5], additional induction-based parameters,
%       induction coefficient, memristor parameters a & b, magnetic flux
%       potential-based change scaler, magnetic flux leakage scaler
%   periodic_current, optional : scalar [1x1], 0 or 1 for constant or
%       low-high frequency current, respectively
%
% Returns
%   hh_ode : matrix [5, length(t)] where the first row stands for the
%           membrane potential change over time and the following three
%           rows outline the change of activation parameters describing
%           the nature of the opening and closing ion channels gates, the
%           last row represents the magnetic flux and its change in time
    
    % H-H model parameters unpacking
    A = basic_params(1);
    t_stop = basic_params(2);
    E_Na = basic_params(3);
    E_K = basic_params(4);
    E_L = basic_params(5);
    gbar_Na = basic_params(6);
    gbar_K = basic_params(7);
    gbar_L = basic_params(8);
    C_m = basic_params(9);
    T = basic_params(10);
    
    % induction parameters unpacking
    k = induction_params(1);
    a = induction_params(2);
    b = induction_params(3);
    k1 = induction_params(4);
    k2 = induction_params(5);
    
    % initial conditions unpacking
    V = y(1);
    m = y(2);
    h = y(3);
    n = y(4);
    phi = y(5);
    
    % current
    if (~(exist('periodic_current', 'var')) || periodic_current==0)
        current = Iinj(A, t, t_stop);
    elseif periodic_current==1
        w_hf = 1/t_stop;
        w_lf = w_hf*100;
        current = Iinj_periodic(A/10, A/2, A/2, w_hf, w_lf, t, t_stop);
    end
    
    % ode system additionally considering the effect of the temperature and
    % magnetic flux
    hh_ode = [
        1/C_m * (current - gbar_Na*h*m^3*(V-E_Na) ...
                - gbar_K*n^4*(V-E_K) - gbar_L*(V-E_L) - k*(a+3*b*phi^2)*V);
        temp_scaler(T) * (alpha_m(V)*(1-m) - beta_m(V)*m);
        temp_scaler(T) * (alpha_h(V)*(1-h) - beta_h(V)*h);
        temp_scaler(T) * (alpha_n(V)*(1-n) - beta_n(V)*n);
        k1*V - k2*phi
        ];
end