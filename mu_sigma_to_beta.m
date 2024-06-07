function [alp,bet] = mu_sigma_to_beta(x_mu,x_sd)
   
        v = (x_mu * (1- x_mu))/x_sd^2 - 1;
        alp = x_mu * v;
        bet = (1- x_mu) * v;
end