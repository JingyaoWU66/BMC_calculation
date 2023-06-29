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