% Define the X range for plotting
X = linspace(-3, 3, 100);  % Values for X (scalar inputs)
gamma = 1;  % Gamma value for the Huber function

% Compute the Huber function values for each point in X
huber_vals = arrayfun(@(x) discont_huber(x, gamma), X);

% Plot the Huber function values
figure;
plot(X, huber_vals, 'LineWidth', 2);
xlabel('X');
ylabel('Discontinuous Function Value');
title('Discontinuous Function');
grid on;