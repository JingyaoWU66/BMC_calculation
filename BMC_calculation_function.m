% This is the final function to compute BMC
% Inputs
% pred_alp,pred_bet: Predicted Beta parameters, if you used Gaussian
% distribution of others, it can be easily changed in
% my_toy_find_rejection_index function to compute the area under the PDF
% curve, you can manually modify the codes
% proir: A proper Prior distribution you determined
% gt_ratings: multiple ratings at one frame

% Outputs
% BMC: the Belief Mismatch Coefficient
% all_pdf: inferred PDF from gt_ratings


% Reference:
% [1] J. Wu, T. Dang, V. Sethu, and E. Ambikairaja, "Belief Mismatch Coefficient (BMC): A Novel
% Interpretable Measure of Prediction Accuracy for Ambiguous Emotion States," in 11th International Conference on Affective
% Computing and Intelligent Interaction (ACII). IEEE, 2023

%% Programmed by:
% Jingyao wu (jingyao.wu@unsw.edu.au)
% University of New South Wales, 29th June, 2023


function [all_pdf,BMC] = BMC_calculation_function(pred_alp,pred_bet,proir,gt_ratings)

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
    
    %% Start computing
    if pred_alp > 1 & pred_bet > 1 %check the beta distribution is bell shape
        y_pdf = betapdf(x,pred_alp,pred_bet);
        
        %Find P_alpha and alpla-likely region given predicted Beta distribution
        [p_alpha_predcted,alpha_likely_index] = my_toy_find_rejection_index(alpha,x,y_pdf,pred_alp,pred_bet);
        
        %Find P_hat_alpha based on ground truth ratings
        %gt_ratings = ave_test_labels;
        [all_pdf,p_hat_alpha_inferred] = my_likely_area_inferred(resolution,alpha,alpha_likely_index,x,alp,bet,proir,gt_ratings);
        
        %Calculate BMC at each time frame given the two above P_alphas
        [BMC] = my_BMC_calculation(p_alpha_predcted,p_hat_alpha_inferred);
    end

end