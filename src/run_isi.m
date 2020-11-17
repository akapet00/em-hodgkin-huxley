clear;

%% read simulated data
data = readmatrix(fullfile('output', 'data', ...
    'tVmhnPhi_t-1000_Itstop-1000_T-6.3_k-0.3.csv'));
t = data(:, 1);
V = data(:, 2);

%% find spikes and associated spike times
[V_spike, t_spike] = findpeaks(V, t);

fig1 = figure('renderer', 'painters', 'position', [100, 200, 800, 800]);
plot(t, V, 'b-', t_spike, V_spike, 'rx');
xlabel('t [ms]'), ylabel('V [mV]');
ylim([min(V) - 0.1*max(V), 1.1*max(V)]);
title('action potential in time, V(t)');
legend('V(t)', 'local maxima');
grid on;


%% calculate inter-spike interval
isi = diff(t_spike);
mean_isi = mean(isi);

fig2 = figure('renderer', 'painters', 'position', [100, 200, 900, 500]);
subplot(1, 2, 1)
h = histogram(isi, 'binmethod', 'fd', ...
    'edgecolor', 'k', 'facecolor', 'r');
xlabel('inter-spike interval [ms]'), ylabel('N');
title('ISI histogram');

subplot(1, 2, 2)
p = histogram(isi, 'binmethod', 'fd', 'normalization', 'probability', ...
    'edgecolor', 'k', 'facecolor', 'r');
pmf = p.Values(p.Values>0);
entropy = -sum(pmf .* log2(pmf));
xlabel('inter-spike interval [ms]'), ylabel('p');
title(['ISI PMF, entropy=', num2str(entropy)]);