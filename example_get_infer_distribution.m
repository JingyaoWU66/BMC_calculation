

x = [0:0.001:1]; %resultion of estimating the PDF
alpha = [0.01:0.01:1]; %resolution of the alphas
%% Prepare all possible Beta parameters for computing the all posteriors to infer PDF from ground truth ratings
resolution = 200;
alp = zeros(resolution,resolution);
bet = zeros(resolution,resolution);
x_mu = linspace(0,1,resolution);
x_sd = linspace(0,1,resolution);
for i = 1:size(alp,1)
    for j = 1:size(alp,1)
        if x_sd(j)^2 < x_mu(i) * (1- x_mu(i))
            [alp(i,j),bet(i,j)] = mu_sigma_to_beta(x_mu(i),x_sd(j));
        end
    end
end
alp(:,1) = 0;
bet(:,1) = 0;
alp(alp < 1) = 0;
bet(bet < 1) = 0;
%%
for u = 1:9 %u: utterance index
    %for i = 1:length(pred_alp{u,1})
        if pred_alp{u,1}(i) > 1 & pred_bet{u,1}(i) > 1 %check the beta distribution is bell shape     
        %compute inferred distributions
        all_pdf{u,1}{i,1} = compute_inferred_distribution(alp,bet,proir,arousal_dev{u}(i,2:7)*0.4975+0.5, x, alpha, resolution)
    %else
    %    BMC{u,1}(i) = -100;
    %end
    end
end
%%
function all_pdf = compute_inferred_distribution(alp,bet,proir,gt_ratings, x, alpha, resolution)
%resolution= 200;
%x = [0:0.001:1]; %resultion of estimating the PDF
%alpha = [0.01:0.01:1]; %resolution of the alphas
post_prob_toy = zeros(resolution,resolution);
for i = 1:size(alp,1)
       for j = 1:size(alp,1)
           if alp(i,j) > 1 & bet(i,j) > 1
               ppdf = betapdf(x,alp(i,j),bet(i,j));
               px = my_calculate_px(gt_ratings,x,ppdf);
               %post_prob_t_few_new{dr,1}{u,1}{t,1}(i,j) = prod(betapdf(rating,alp(i,j),bet(i,j)))*proir(i,j);%p_alp(a)*p_bet(b);
               post_prob_toy(i,j) = prod(px)*proir(i,j);
           end
       end
end
all_pdf = my_all_post_calculation(post_prob_toy,x,alp,bet);
end