function hh_ode = HodgkinHuxley(t, y)
    global E_Na E_K E_L gbar_Na gbar_K gbar_L C_m T
    V = y(1);
    m = y(2);
    h = y(3);
    n = y(4);
    
    hh_ode = [
        1/C_m * (I(t) - gbar_Na*h*m^3*(V-E_Na) - gbar_K*n^4*(V-E_K) - gbar_L*(V-E_L));
        temp_scaler(T) * (alpha_m(V)*(1-m) - beta_m(V)*m);
        temp_scaler(T) * (alpha_h(V)*(1-h) - beta_h(V)*h);
        temp_scaler(T) * (alpha_n(V)*(1-n) - beta_n(V)*n)
        ];