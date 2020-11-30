set_input;

ks = linspace(0.0, 5.0, 100);
T = 15;

mean_isis = zeros(length(ks), 1);
V_min = zeros(length(ks), 1);
V_max = zeros(length(ks), 1);

for i = 1:length(ks)
    k = ks(i);
    filename= ['tVmhnPhi', ...
        '_tsim-', num2str(t_stop), ...
        '_tIinjstop-', num2str(t_stop), ...
        '_T-', num2str(T), ...
        '_k-', num2str(k), '.csv'];
    filepath = fullfile('output', 'deterministic_model', 'data', filename);
    data = readmatrix(filepath);
    t = data(:, 1);
    V = data(:, 2);
    V_min(i) = min(V(floor(length(V)/2):end));
    V_max(i) = max(V(floor(length(V)/2):end));
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

ks = [0.03, 0.09, 0.27, 0.81];
k = 0;
Ts = linspace(1.0, 30.0, 30);

mean_isis = zeros(length(Ts), 1);
V_min = zeros(length(Ts), 1);
V_max = zeros(length(Ts), 1);

for i = 1:length(Ts)
    T = Ts(i);
    filename= ['tVmhnPhi', ...
        '_tsim-', num2str(t_stop), ...
        '_tIinjstop-', num2str(t_stop), ...
        '_T-', num2str(T), ...
        '_k-', num2str(k), '.csv'];
    fullfile('output', 'deterministic_model', 'data', filename);
    data = readmatrix(filepath);
    t = data(:, 1);
    V = data(:, 2);
    V_min(i) = min(V);
    V_max(i) = max(V);
    [V_spike, t_spike] = findpeaks(V, t);
    isi = diff(t_spike);
    mean_isis(i) = mean(isi);
end

V_min(V_min < (V_min(1)*1.1)) = V0;
T_critical = Ts(V_min == V_max);
hopf_bifurcation_point = T_critical(1);

fig2 = figure('renderer', 'painters', 'position', [100, 200, 900, 500]);
hold on;
plot(Ts, V_min, 'sb-', 'displayname', 'min');
plot(Ts, V_max, 'or-', 'displayname', 'max');
xlabel('T [°C]');
ylabel('V [mV]');
title(['Bifurcation diagram, V(T); Hopf bifurcation point, T ~ ', num2str(hopf_bifurcation_point), ' °C']);
legend;
grid on;
hold off;