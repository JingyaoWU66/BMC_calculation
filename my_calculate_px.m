function px = my_calculate_px(rating,x,ppdf)
    %rating = ar_test_delay_u{u}(i,:);
    for r = 1:length(rating)
        [~,idx(r)] = min(abs(rating(r) - x));
    end
    %ppdf = ppdf/length(x);
    px = ppdf(idx);
end