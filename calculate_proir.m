%% MAP estimation Training set
% Calculate porior P(mu) and P(sigma)
resolution = 200;
a = linspace(0,1,resolution)
total_mu = cell2mat(ar_test.mu);
total_sd = cell2mat(ar_test.sigma);
[p_mu, x_mu] = ksdensity(total_mu,a); %x_mu & x_sd are the grid values
[p_sd,x_sd] = ksdensity(total_sd,a);
figure
subplot(2,1,1)
plot(x_mu, p_mu)
title('Prior PDF P(mean)')
xlabel("Arosual")
subplot(2,1,2)
plot(x_sd, p_sd)
title('Prior PDF P(SD)')
xlabel("Arosual")
%%
a = linspace(0,1,resolution);
%total_alp = cell2mat(ar_train.alp);
%total_bet = cell2mat(ar_train.bet);
%[p_alp, x_alp] = ksdensity(total_alp,a);
%[p_bet,x_bet] = ksdensity(total_bet,a);

%proir = p_alp.*p_bet;
%p_mu = p_mu/length(a);
%p_sd = p_sd/length(a);
for ai = 1:length(a)
    for bi = 1:length(a)
        proir(ai,bi) = p_mu(ai)*p_sd(bi);
    end
end
figure
imagesc(x_mu,x_sd,proir);
set(gca,'YDir','normal') 
xlabel("Sd")
ylabel("Mean")
title("Proir P(mu, sigma)")
proir = proir/(length(a)^2);