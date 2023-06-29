function [BMC] = my_BMC_calculation(pred_reject_area_toy,gt_all_post_reject_area_toy)
    AA1 = 1-pred_reject_area_toy;
    AA2 = 1-gt_all_post_reject_area_toy;
    %area = trapz(AA1,AA1-AA2);
    BMC = AA2/AA1;
end