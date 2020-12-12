set_input;

A = 20;
T = 15;
k1 = 0.001;
ks = linspace(0.0, 5, 100);

mean_isis = zeros(length(ks), 1);
V_min = zeros(length(ks), 1);
V_max = zeros(length(ks), 1);

for i = 1:length(ks)
    k = ks(i);
    basic_params = [A, t_start, t_stop, ...
        E_Na, E_K, E_L, gbar_Na, gbar_K, gbar_L, ...
        C_m, T];
    induction_params = [k, a, b, k1, k2];
    y0 = [V0, m0, h0, n0, phi0];
    t_span = [0, t_stop];
    [t, y] = ode45(@(t, y) HodgkinHuxley(...
        t, y, basic_params, induction_params), ...
        t_span, y0);
    V = y(:, 1);
    V_min(i) = min(V(1500:end));
    V_max(i) = max(V(1500:end));
    [V_spike, t_spike] = findpeaks(V, t);
    isi = diff(t_spike);
    mean_isis(i) = mean(isi);
end
fig1 = figure('renderer', 'painters', 'position', [100, 200, 900, 500]);
hold on;
plot(ks, V_min, 'sb-', 'displayname', 'min');
plot(ks, V_max, 'or-', 'displayname', 'max');
xlabel('k');
ylabel('V [mV]');
title('Bifurcation diagram, V(k)');
legend;
grid on;
hold off;