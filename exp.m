% situation we discussed right now 
pr_a = 5/6; % Outcome 6
pr_b = 1/6; % Outcome 1
H_X = -(pr_a * log2(pr_a) + pr_b * log2(pr_b));
% cases
simulations = [1000, 50000, 1000000];
num_sims = length(simulations);

fprintf('Theoretical Entropy H(X): %.5f bits/symbol\n', H_X);

figure;
hold on;
colors = ['r', 'g', 'b'];
for k = 1:num_sims
    N = simulations(k);

    % generate i.i.d. uniform random numbers
    randomRolls = rand(1, N);
    % vectorized assignment
    is_event_a = randomRolls < pr_a;
    counter_a = sum(is_event_a);
    counter_b = N - counter_a;
    p_hat_a = counter_a / N;
    p_hat_b = counter_b / N;
    cum_counter_a = cumsum(is_event_a);
    cum_counter_b = (1:N) - cum_counter_a;
    cum_sample_entropy = - (cum_counter_a .* log2(pr_a) + cum_counter_b .* log2(pr_b)) ./ (1:N);

    final = cum_sample_entropy(end);
    fprintf('  Event A count: %d (%.4f%%)\n', counter_a, p_hat_a * 100);
    fprintf('  Event B count: %d (%.4f%%)\n', counter_b, p_hat_b * 100);
    fprintf('  Sample Entropy: %.5f bits/symbol\n', final);
    fprintf('  Absolute Error from H(X): %.5f\n\n', abs(final - H_X));
    step = max(1, floor(N / 10000));
    plot(1:step:N, cum_sample_entropy(1:step:N), 'Color', colors(k), ...
        'LineWidth', 1.2, 'DisplayName', sprintf('N = %d', N));
end
yline(H_X, 'k--', 'LineWidth', 2, 'DisplayName', sprintf('H(X) = %.5f bits', H_X));
grid on;
set(gca, 'XScale', 'log'); % Log scale
xlabel('Sequence Length (N)');
ylabel('Entropy [bits]');
title('Entropy \rightarrow H(X)');
legend('Location', 'northeast');
hold off;
