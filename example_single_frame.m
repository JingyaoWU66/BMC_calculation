% This is an example of calculating the BMC of a single frame and plot

[all_pdf,BMC] = BMC_calculation_function(pred_alp,pred_bet,proir,gt_ratings);

%% You can plot your inferred and predicted distributions 
% % see how they are differred as a comparion using the codes below
% and then plot the corresponding BMF using the codes in the next section
% This is what I did in Figure 5,6,7 of the paper

figure
x = [0:0.001:1];
y = betapdf(x,pred_alp,pred_bet);
plot(x,y,'linewidth',2)
hold on
plot(x,y_gt,'LineWidth',2)
hold on
plot(x,all_pdf,'linewidth',2)
hold on
scatter(ave_test_labels,zeros(1,6),'filled') %I have 6 ratings per frame
legend('Predicted PDF','Inferred ALl posteroir PDF')

%% BMF plot of a single frame 
% This is the Figure 3 in the paper
figure
plot(1-p_alpha_predcted,1-p_hat_alpha_inferred,'LineWidth',1)
hold on
plot([0:0.01:1],[0:0.01:1],'LineWidth',1)
title('Belief Mismatch Function (BMF)')
xlabel('Belief of predicted distribution with different alpha')
ylabel('Belief of inferred distribution with different alpha')
