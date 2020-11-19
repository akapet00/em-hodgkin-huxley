set_input;

%% run 1: multiple temperatures for several induction coeffs
ks = [0.03, 0.09, 0.27, 0.81];
Ts = linspace(1.0, 30.0, 30);
tic;
for i = 1:length(Ts)
    T = Ts(i);
    for j = 1:length(ks)
        basic_params = [A, t_stop, E_Na, E_K, E_L, ...
            gbar_Na, gbar_K, gbar_L, C_m, T];
        induction_params = [k, a, b, k1, k2];
        y0 = [V0, m0, h0, n0, phi0];
        t_span = [0, t_stop];
        k = ks(j);
        [t, y] = ode45(@(t, y) ...
            HodgkinHuxley(t, y, basic_params, induction_params), ...
            t_span, y0);

        if save_data
            writematrix(["t", "V", "m", "h", "n", "phi"; t, y], ...
                fullfile(datadir, ['tVmhnPhi', ...
                    '_tsim-', num2str(t_span(2)), ...
                    '_tIinjstop-', num2str(t_stop), ...
                    '_T-', num2str(T), ...
                    '_k-', num2str(k), '.csv']));
        end
    end
end
disp('Run 1: multiple temperatures for several induction coefficients');
toc;


%% run 2: multiple induction coeffs for several temps
ks = linspace(0.0, 5.0, 100);
Ts = [5.0, 10.0, 15.0, 20.0];
tic;
for i = 1:length(Ts)
    T = Ts(i);
    for j = 1:length(ks)
        basic_params = [A, t_stop, E_Na, E_K, E_L, ...
            gbar_Na, gbar_K, gbar_L, C_m, T];
        induction_params = [k, a, b, k1, k2];
        y0 = [V0, m0, h0, n0, phi0];
        t_span = [0, t_stop];
        k = ks(j);
        [t, y] = ode45(@(t, y) ...
            HodgkinHuxley(t, y, basic_params, induction_params), ...
            t_span, y0);

        if save_data
            writematrix(["t", "V", "m", "h", "n", "phi"; t, y], ...
                fullfile(datadir, ['tVmhnPhi', ...
                    '_tsim-', num2str(t_span(2)), ...
                    '_tIinjstop-', num2str(t_stop), ...
                    '_T-', num2str(T), ...
                    '_k-', num2str(k), '.csv']));
        end
    end
end
disp('Run 2: multiple induction coefficients for several temperature');
toc;