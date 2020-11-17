set_input;

ks = [0.001, 0.1, 0.3, 0.9];
Ts = linspace(1, 30, 30);

tic;
for i = 1:length(Ts)
    T = Ts(i);
    for j = 1:length(ks)
        k = ks(j);
        [t, y] = ode45(@HodgkinHuxley, t_span, y0);

        if save_data
            writematrix(["t", "V", "m", "h", "n", "phi"; t, y], ...
                fullfile(datadir, ...
                    ['tVmhnPhi', '_t-', num2str(t_span(2)), ...
                     '_Itstop-', num2str(t_stop), '_T-', num2str(T), ...
                     '_k-', num2str(k), '.csv']));
        end
    end
end
toc;