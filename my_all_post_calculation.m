function all_pdf = my_all_post_calculation(post,x,alp,bet)
    %post = post_prob_t_few_new{dr,1}{u,1}{t,1};
    post = (post/sum(sum(post))); %* resolution^2;
    %post_area1_new = post_area1 .* post_prob_t;
    for i = 1:size(alp,1)
        for j = 1:size(alp,1)
            if alp(i,j) > 1 & bet(i,j) > 1
                ppp{i,j} = betapdf(x,alp(i,j),bet(i,j)).* post(i,j);%prod(betapdf(rating,alp(i,j),bet(i,j)))*proir(i,j);%p_alp(a)*p_bet(b);
            end
        end
    end
    all_pdf = zeros(1,1001);
    for i = 1:size(alp,1)
        for j = 1:size(alp,1)
            if alp(i,j) > 1 & bet(i,j) > 1
                all_pdf = ppp{i,j} + all_pdf;
            end
        end
    end
end