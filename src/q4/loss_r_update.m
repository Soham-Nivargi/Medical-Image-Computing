function loss = loss_r_update(x, r, D, params)
    p = params.p;
    loss = norm(x - D * r, 2)^2 + norm(r, p)^p;
end