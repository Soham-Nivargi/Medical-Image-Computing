function fin = discont_huber(X, gamma)
    fin = sum(gamma * abs(X) - gamma^2 * log(1 + abs(X)/gamma), "all");
end