%This is the function to compute alpha-likely region
% Input
% x: resolution of the PDF
% y: predicted PDF
% pred_alp & pred_bet: Beta distribution parameters (alpha, beta) of
% predicted distribution

% Output:
% arousal_index: alpha likely region, i.e., refer to y1 and y2 in figure 2 of the paper
% min_area: the area under the predicted PDF within the region, refer to
% P_alpha in figure 2
function [min_area,arousal_index] = my_toy_find_rejection_index(alpha,x,y_pdf,pred_alp,pred_bet)
    [~,max_id] = max(y_pdf);
    %save_id = 1;
    for p = 1:max_id
        %[~,id] = min(abs(y_pdf(1:max_id)-th(p)));
        %x1 = x(id);
        x1(p) = x(p);
        [~,id] = min(abs(y_pdf(max_id+1:end)-y_pdf(p)));
        x2(p) = x(id+max_id);
        area1 = cdf('Beta',x1(p),pred_alp,pred_bet);
        area2 = cdf('Beta',x2(p),pred_alp,pred_bet);
        total_area(p) = area1 + (1-area2);
    end
    for n = 1:length(alpha)
        [~,min_id(n)] = min(abs(total_area-alpha(n)));
        arousal_index(n,1) = x1(min_id(n));
        arousal_index(n,2) = x2(min_id(n));
        min_area(n) = total_area(min_id(n));
        %save_id = p;
    end
end