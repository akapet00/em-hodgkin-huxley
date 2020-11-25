set_input;

var_percents = [5., 10., 20., 50.];
sc_points = [3, 5, 7, 9];
for vp_idx = 1:numel(var_percents)
    var_percent = var_percents(vp_idx);
    for sp_idx = 1:numel(sc_points)
        sc_point = sc_points(sp_idx);
        filename = [num2str(var_percent), '_perCent_DoE_SC_', ...
            num2str(sc_point), '.mat'];
        filepath =  fullfile('sensitivity_analysis', 'sc_input', filename);
        load(filepath);
        gbar_Na_list = DoE(:,1); % maximum sodium ion channel conductance
        gbar_K_list = DoE(:,2); % maximum potassium ion channel conductance
        gbar_L_list = DoE(:,3); % maximum leakage ion channel conductance

        T = 15; % fixed temperature
        ks = linspace(0.0, 2.0, 50); % multiple induction coeffs
        mean_isi_per_k_per_gbar = zeros(numel(ks), numel(gbar_Na_list));
        tic;
        for gbar_idx = 1:length(gbar_Na_list)
            gbar_Na = gbar_Na_list(gbar_idx);
            gbar_K = gbar_K_list(gbar_idx);
            gbar_L = gbar_L_list(gbar_idx);
            mean_isi_per_k = zeros(length(ks), 1);
            for k_idx = 1:length(ks)
                k = ks(k_idx);
                basic_params = [A, t_stop, E_Na, E_K, E_L, ...
                    gbar_Na, gbar_K, gbar_L, C_m, T];
                induction_params = [k, a, b, k1, k2];
                y0 = [V0, m0, h0, n0, phi0];
                t_span = [0, t_stop];
                [t, y] = ode45(@(t, y) HodgkinHuxley(...
                    t, y, basic_params, induction_params), t_span, y0);
                V = y(:, 1);
                [V_spike, t_spike] = findpeaks(V, t);
                isi = diff(t_spike);
                mean_isi_per_k(k_idx) = mean(isi);
            end
            mean_isi_per_k_per_gbar(:, gbar_idx) = mean_isi_per_k;
        end
        filename = ['mean_ISI', ...
            '_tsim-', num2str(t_span(2)), ...
            '_tIinjstop-', num2str(t_stop), ...
            '_T-', num2str(T), ...
            '_k-', num2str(ks(1)), '-', num2str(ks(end)), ...
            '_SC-', num2str(sc_point), ...
            '_var-', num2str(var_percent), '.mat'];
        filepath =  fullfile('sensitivity_analysis', 'sc_output', filename);
        save(filepath, 'mean_isi_per_k_per_gbar');
        toc;
    end
end