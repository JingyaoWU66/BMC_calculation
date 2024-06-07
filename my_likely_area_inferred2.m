% This is the function to find the area under the alpha-likely region from
% the inferred distribution

% Input
% alpha_likely_index: alpha likely region
% gt_ratings: ground truth ratings from multiple raters
% alp&bet: estimated all possible Beta parameters
% proir: estimated proir distribution from training data, refer to P(theta)
% in Equation (2)
% x: resolution of the PDF

%Output
% p_hat_alpha_inferred: the area under the inferred PDF within the region, refer to
% P^hat_alpha in figure 2
% all_pdf_toy: inferred distribution in Equation (1) 

function [p_hat_alpha_inferred] = my_likely_area_inferred2(resolution,alpha,alpha_likely_index,x,alp,bet,proir,gt_ratings)
  %y_pdf = betapdf(x,toy_alp(t),toy_bet(t));
  %[pred_reject_area_toy{t,1},arousal_index] = my_toy_find_rejection_index(alpha,x,y_pdf,toy_alp(t),toy_bet(t));
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
    %all_pdf_toy = my_all_post_calculation(post_prob_toy,x,alp,bet);
    p_hat_alpha_inferred = my_area_under_posteriors_main(alpha,alpha_likely_index,post_prob_toy,alp,bet);
    
end


%%
function A3 = my_area_under_posteriors_main(alpha,arousal_index,post_prob_t,alp,bet)
    for n = 1:length(alpha)
        [A1,A2] = area_under_posteriors(post_prob_t,arousal_index(n,1),arousal_index(n,2),alp,bet);
        A3(n) = A1 + (1 - A2);
    end
end
%%
function [A1,A2] = area_under_posteriors(post_prob_t,x1,x2,alp,bet)
    resolution = size(post_prob_t,1);
    post_area1 = zeros(resolution,resolution);
    post_area2 = zeros(resolution,resolution);
    %G = 40000/sum(sum(post_prob_t));

    post_prob_t = (post_prob_t/sum(sum(post_prob_t))); %* resolution^2;
    for a = 1:size(post_prob_t,1)
        for b = 1:size(post_prob_t,2)
            if alp(a,b) ~= 0 & bet(a,b) ~= 0 & alp(a,b) > 1 & bet(a,b) > 1
                post_area1(a,b) = cdf('Beta',x1,alp(a,b),bet(a,b));
                post_area2(a,b) = cdf('Beta',x2,alp(a,b),bet(a,b));
            end
        end
    
    end
    post_area1_new = post_area1 .* post_prob_t;
    post_area2_new = post_area2 .* post_prob_t;
    A1 = sum(sum(post_area1_new));
    A2 = sum(sum(post_area2_new));
end