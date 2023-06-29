% This is an example of calculating the BMCs of the entire dataset and
% evaluate it with the boxplot in Figure 10 in the paper

for u = 1:9 %u: utterance index
    for i = 1:length(pred_alp{u,1}) %i: frame index within one utterance
     if pred_alp{u,1}(i) > 1 & pred_bet{u,1}(i) > 1 %check the beta distribution is bell shape
       
        [all_pdf{u,1}{i,1},BMC{u,1}(i)] = BMC_calculation_function(pred_alp{u,1}(i),pred_bet{u,1}(i),proir,gt_ratings{u,1}(i));
     else
        BMC{u,1}(i) = -100;
     end
    end
end
% Remove the samples when the distribution is not bell shape
BMC{1} = double(ratio_temp);
for u = 1:9
BMC{u}(BMC{u} == -100) = [];
end
BMC_total = cell2mat(BMC'); %Cat all BMCs of the entire dataset
%% This is the Figure 10 in the paper
Bx = linspace(0.02,2,100);%resolution when you estimating the distribution of BMC
gamma = 0.75; % quartiles of the boxplot you are interested in
my_gamma_boxplot(BMC_total,gamma,Bx);
%% You can plot your inferred and predicted distributions 
% % see how they are differred as a comparion using the codes below
% and then plot the corresponding BMF using the codes in the next section
% This is what I did in Figure 5,6,7 of the paper
u = 1
t = 1
figure
x = [0:0.001:1];
y = betapdf(x,pred_alp{u,1}(t,1),pred_bet{u,1}(t,1));
%y_gt= betapdf(x,MAP_BETA_t{u,1}(t,1),MAP_BETA_t{u,1}(t,2));
%y_gt_few_dr{dr,1}= betapdf(x,MAP_BETA_t_few_dr{dr,1}{u,1}(t,1),MAP_BETA_t_few_dr{dr,1}{u,1}(t,2));
plot(x,y,'linewidth',2)
hold on
plot(x,y_gt,'LineWidth',2)
hold on
plot(x,all_pdf{u,1}{t,1},'linewidth',2)
hold on
scatter(gt_ratings{u}(t,:),zeros(1,6),'filled') %I have 6 ratings per frame
title("utt = " + u + " frame = " + t)
legend('Predicted PDF','Inferred ALl posteroir PDF')

%% BMF plot of a single frame 
% This is the Figure 3 in the paper
figure
plot(1-p_alpha_predcted{u,1}{t,1},1-p_hat_alpha_inferred{u,1}{t,1},'LineWidth',1)
hold on
plot([0:0.01:1],[0:0.01:1],'LineWidth',1)
title('Belief Mismatch Function (BMF)')
xlabel('Belief of predicted distribution with different alpha')
ylabel('Belief of inferred distribution with different alpha')
