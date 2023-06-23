%% use the recola mean and sd to create beta distributions
u = 2
rating_mean = mean(ar_test_delay_u{u}(1:5000,:)');
rating_sd = std(ar_test_delay_u{u}');
toy_ratings = ar_test_delay_u{u}(1:5000,:);

for r = 1:6
temp = reshape(toy_ratings(:,r), 25, []);
toy_ratings_chunck(:,r) = mean(temp)';
end
toy_mean = mean(toy_ratings_chunck');
toy_sd = std(toy_ratings_chunck');

figure
plot(toy_mean,'r','LineWidth',2)
hold on
plot(toy_ratings_chunck,'--')

my_plot_shaded_sd([1:length(toy_mean)],toy_mean,toy_sd,toy_ratings_chunck)
%%
for i = 1:length(toy_mean)
    [toy_alp(i),toy_bet(i)] = mu_sigma_to_beta(toy_mean(i),toy_sd(i));
end
%% Plot the PDF and see
x = [0:0.01:1]
for i = 1:20
    t = i * 10;
    y_toy = betapdf(x,toy_alp(t),toy_bet(t));
    figure
    plot(x,y_toy)
    hold on
    scatter(toy_ratings_chunck(t,:),zeros(1,6),'filled')
    legend()
end
%% Draw samples from the PDFs
num_rating = [3,4,5,6,7,8,9,10,11,12];
for num = 1:length(num_rating)
    for i = 1:length(toy_alp)
       rating_toy{num,1}(i,:) = betarnd(toy_alp(i),toy_bet(i),[1,num_rating(num)]);
    end
end
%% Plot the PDF Vs drawn samples
close all
for i = 9:9
    t = i * 10;
    y_toy = betapdf(x,toy_alp(t),toy_bet(t));
    figure
    plot(x,y_toy)
    hold on
    scatter(rating_toy{10}(t,:),0,'filled')
    legend()
end
%%
resolution = 200;
alp = zeros(resolution,resolution);
bet = zeros(resolution,resolution);
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

%% --------------Make up Simulate different scenarios at t = 150
% Original
t = 150;
toy_mean_edit(1) = toy_mean(t);
toy_sd_edit(1) = toy_sd(t);  
% Shift to the left
toy_mean_edit(2) = toy_mean_edit(1) - 0.15;
toy_sd_edit(2) = toy_sd_edit(1);
% Shift to the right
toy_mean_edit(3) = toy_mean_edit(1) + 0.15;
toy_sd_edit(3) = toy_sd_edit(1);
% no change center, make it broader
toy_mean_edit(4) = toy_mean_edit(1);
toy_sd_edit(4) = toy_sd_edit(1) * 2;  
% no change center, make it narrower
toy_mean_edit(5) = toy_mean_edit(1);
toy_sd_edit(5) = toy_sd_edit(1) * 0.5;  


% Shift to the left further
toy_mean_edit(6) = toy_mean_edit(1) - 0.05;
toy_sd_edit(6) = toy_sd_edit(1);
% Shift to the right
toy_mean_edit(7) = toy_mean_edit(1) + 0.05;
toy_sd_edit(7) = toy_sd_edit(1);

% Shift to the further broader
toy_mean_edit(8) = toy_mean_edit(1);
toy_sd_edit(8) = toy_sd_edit(1) * 1.5;
% Shift to the right
toy_mean_edit(9) = toy_mean_edit(1);
toy_sd_edit(9) = toy_sd_edit(1) * 0.75;

for i = 1:length(toy_sd_edit)
[toy_alp_edit(i),toy_bet_edit(i)] = mu_sigma_to_beta(toy_mean_edit(i),toy_sd_edit(i));
end
%%
for i = 8:8
y_pdf = betapdf(x,toy_alp_edit(i),toy_bet_edit(i));
[pred_reject_area_edit{i,1},arousal_index] = my_toy_find_rejection_index(alpha,x,y_pdf,toy_alp_edit(i),toy_bet_edit(i));
[all_pdf_edit{i,1},gt_all_post_reject_area_edit{i,1}] = my_likely_area(resolution,alpha,arousal_index,x,alp,bet,proir,toy_ratings_chunck(t,:));
[area_edit(i),ratio_edit(i)] = my_area_ratio(pred_reject_area_edit{i,1},gt_all_post_reject_area_edit{i,1});
end
%%
close all
title_name = ["Original simulated prediction","Left shifted distribution","Right shifted distribution","Broader distribution","Narrower distribution","Right less shift","left less shifted","more broader","more narrower"]
for i = 1:9
  %  gt_all_post_reject_area_edit{i}(end) = 1;
%pred_reject_area_edit{i,1}(end) = 1;
my_makeup_pdf_area_plot(x,toy_alp_edit(i),toy_bet_edit(i),all_pdf_edit{i,1},toy_ratings_chunck(150,:),pred_reject_area_edit{i,1},gt_all_post_reject_area_edit{i,1},area_edit(i),ratio_edit(i),title_name(i));
end



%% Simulate different scenarios at t = 90 (broad distribution)
% Original
t = 90;
toy_mean_edit2(1) = toy_mean(t);
toy_sd_edit2(1) = toy_sd(t);  
% Shift to the left
toy_mean_edit2(2) = toy_mean_edit2(1) - 0.1;
toy_sd_edit2(2) = toy_sd_edit2(1);
% Shift to the right
toy_mean_edit2(3) = toy_mean_edit2(1) + 0.15;
toy_sd_edit2(3) = toy_sd_edit2(1);
% no change center, make it broader
toy_mean_edit2(4) = toy_mean_edit2(1)+0.05;
toy_sd_edit2(4) = toy_sd_edit2(1) * 1.3;  
% no change center, make it narrower
toy_mean_edit2(5) = toy_mean_edit2(1);
toy_sd_edit2(5) = toy_sd_edit2(1) * 0.5;  

toy_mean_edit2(6) = toy_mean_edit2(1) - 0.05;
toy_sd_edit2(6) = toy_sd_edit2(1);
% Shift to the right
toy_mean_edit2(7) = toy_mean_edit2(1) + 0.1;
toy_sd_edit2(7) = toy_sd_edit2(1);


% Shift to the further broader
toy_mean_edit2(8) = toy_mean_edit2(1);
toy_sd_edit2(8) = toy_sd_edit2(1) * 1.1;
% Shift to the right
toy_mean_edit2(9) = toy_mean_edit2(1);
toy_sd_edit2(9) = toy_sd_edit2(1) * 0.2;

for i = 8:9%length(toy_sd_edit2)
[toy_alp_edit2(i),toy_bet_edit2(i)] = mu_sigma_to_beta(toy_mean_edit2(i),toy_sd_edit2(i));
end
%%
for i = 8:8
y_pdf = betapdf(x,toy_alp_edit2(i),toy_bet_edit2(i));
[pred_reject_area_edit2{i,1},arousal_index] = my_toy_find_rejection_index(alpha,x,y_pdf,toy_alp_edit2(i),toy_bet_edit2(i));
[all_pdf_edit2{i,1},gt_all_post_reject_area_edit2{i,1}] = my_likely_area(resolution,alpha,arousal_index,x,alp,bet,proir,toy_ratings_chunck(t,:));
[area_edit2(i),ratio_edit2(i)] = my_area_ratio(pred_reject_area_edit2{i,1},gt_all_post_reject_area_edit2{i,1});
end

%%
close all
title_name = ["Baseline","Left shifted distribution","Right shifted distribution","Broader distribution","Narrower distribution","Further left","Further right","more broad","More narrow"]
for i = 1:9
  %  gt_all_post_reject_area_edit{i}(end) = 1;
%pred_reject_area_edit{i,1}(end) = 1;
my_makeup_pdf_area_plot(x,toy_alp_edit2(i),toy_bet_edit2(i),all_pdf_edit2{i,1},toy_ratings_chunck(t,:),pred_reject_area_edit2{i,1},gt_all_post_reject_area_edit2{i,1},area_edit2(i),ratio_edit2(i),title_name(i));
end

%%
save('simulated_diff_scenarios.mat')





%% ---------- Drawn different number of raters
x = [0:0.001:1];      
alpha = [0.01:0.01:1];

num_rating = [3,4,5,6,7,8,9,10,11,12];
for num = 1:length(num_rating)
    for i = 1:length(toy_alp)
       rating_toy{num,1}(i,:) = betarnd(toy_alp(i),toy_bet(i),[1,num_rating(num)]);
    end
end
%%
for t = 1:100%length(toy_alp)
   
    y_pdf = betapdf(x,toy_alp(t),toy_bet(t));
    [pred_reject_area_toy{t,1},arousal_index{t,1}] = my_toy_find_rejection_index(alpha,x,y_pdf,toy_alp(t),toy_bet(t));
    for dr = 1:8%length(num_rating)% 先造出6个来，造不同的情况写到第一个部分，然后再弄不同数量的
        post_prob_toy{dr,1}{t,1} = zeros(resolution,resolution);
        for i = 1:size(alp,1)
           for j = 1:size(alp,1)
               if alp(i,j) > 1 & bet(i,j) > 1
                   ppdf = betapdf(x,alp(i,j),bet(i,j));
                   px = my_calculate_px(rating_toy{dr}(t,:),x,ppdf);
                   %px = my_calculate_px(toy_ratings_chunck(t,:),x,ppdf);
                   %post_prob_t_few_new{dr,1}{u,1}{t,1}(i,j) = prod(betapdf(rating,alp(i,j),bet(i,j)))*proir(i,j);%p_alp(a)*p_bet(b);
                   post_prob_toy{dr,1}{t,1}(i,j) = prod(px)*proir(i,j);
               end
           end
        end
        all_pdf_toy{dr,1}{t,1} = my_all_post_calculation(post_prob_toy{dr,1}{t,1},x,alp,bet);
        gt_all_post_reject_area_toy{dr,1}{t,1} = my_area_under_posteriors_main(alpha,arousal_index{t,1},post_prob_toy{dr,1}{t,1},alp,bet);
 
    end
     
 end

%%
t = 40
dr = 2
%AA1 = 1-pred_reject_area_toy{t,1};
%AA2 = 1-gt_all_post_reject_area_toy{dr,1}{t,1};
%area = trapz(AA1,AA1-AA2);
%ratio = AA2/AA1;

%dr = 10
figure
subplot(2,2,1)
y_toy = betapdf(x,toy_alp(t),toy_bet(t));
plot(x,all_pdf_toy{dr,1}{t,1},'LineWidth',2)
hold on
%for dr = 1:1
plot(x,y_toy,'LineWidth',2)
hold on
%end
scatter(rating_toy{dr}(t,:),zeros(1,num_rating(dr)),'filled','k')
legend('Inferred','Predicted')
xlabel('Arousal','FontSize',14)
ylabel('PDF','FontSize',14)
title(" frame = " + t )

subplot(2,2,2)
%for dr = 4:4
plot(pred_reject_area_toy{t,1},gt_all_post_reject_area_toy{dr,1}{t,1},'LineWidth',2)
hold on
%end
plot([0:0.01:1],[0:0.01:1],'LineWidth',2)
%legend()
xlabel('Alpha','FontSize',14)
ylabel('Alpha','FontSize',14)
title("Ratio = " + ratio + "Area in between is " + area)

%%
clear area_between_toy ratio_between_toy
for dr = 1:length(num_rating)
    for t = 1:100%length(gt_all_post_reject_area_toy{dr,1})
        AA1 = 1-pred_reject_area_toy{t,1};
        AA2 = 1-gt_all_post_reject_area_toy{dr,1}{t,1};
        area_between_toy(t,dr) = trapz(AA1,AA1-AA2);
        ratio_between_toy(t,dr) = AA2/AA1;
    end
end
figure
subplot(2,1,1)
plot(area_between_toy)
title("Area between the curve utt = " + u)
subplot(2,1,2)
for dr = 1:length(num_rating)
    [A,B] = ksdensity(area_between_toy(:,dr));
    if dr == 10
        plot(B,A,'LineWidth',2)
    else
        plot(B,A,'--','LineWidth',2)
    end
    hold on
end
title('Distribution of the Areas');
legend('3 ratings','4 ratings','5 ratings','6 ratings','7 ratings','8 ratings','9 ratings','10 ratings','11 ratings','12 ratings')
figure
subplot(2,1,1)
plot(ratio_between_toy,'LineWidth',2)
title('Ratio between the curve')
subplot(2,1,2)
for dr = 1:length(num_rating)
    [A,B] = ksdensity(ratio_between_toy(:,dr));
    if dr == 10
        plot(B,A,'LineWidth',2)
    else
        plot(B,A,'--','LineWidth',2)
    end
hold on
end
title('Distribution of the Ratios');
legend('3 ratings','4 ratings','5 ratings','6 ratings','7 ratings','8 ratings','9 ratings','10 ratings','11 ratings','12 ratings')
%%
save('simulated_diff_num_ratings_12ratings.mat')

%%
figure
subplot(2,1,1)
plot(num_rating,mean(area_between_toy),'*--','LineWidth',2)
title('Mean of the area-in-between')
xlabel('Number of ratings')
ylabel('Area')
subplot(2,1,2)
plot(num_rating,mean(ratio_between_toy),'*--','LineWidth',2)
title('Mean of the ratio-in-between')
xlabel('Number of ratings')
ylabel('Ratio')
%%
gamma = 0.75;
Bx = linspace(0.02,2,100);
my_gamma_boxplot(ratio_between_toy(:,1),gamma,Bx);
my_gamma_boxplot(ratio_between_toy(:,10),gamma,Bx);
%%
for dr = 1:length(num_rating)
[BMR_interval{dr,1},BMR_maxID(dr)] = my_BMR_interval(ratio_between_toy(:,dr),gamma,Bx);
end
%%
figure
plot([1:length(num_rating)],BMR_maxID,'*--')
hold on
box = [BMR_interval{1}'];
box_x = 3*ones(size(BMR_interval{1}'));
for dr = 2:length(num_rating)
box = [box; BMR_interval{dr}'];
box_x = [box_x; (dr+2)*ones(size(BMR_interval{dr}'))];
  %  boxplot(BMR_interval{dr,1},dr*ones(size(BMR_interval{dr,1})))
  %  hold on
end

for dr = 1:length(num_rating)
    BMR_mode(dr) = median(BMR_interval{dr});
end
%%
figure
plot([1:length(num_rating)],BMR_maxID,'*','Color','r','LineWidth',2)

%plot([1:length(num_rating)],BMR_mode,'*--','Color','r','LineWidth',2)
%plot([1:length(num_rating)],mean(ratio_between_toy),'*--','Color','r','LineWidth',2)
xlabel('Number of ratings','FontSize',14)
ylabel('BMR','FontSize',14)
hold on
bh = boxplot(box,box_x)
set(bh,'LineWidth', 2);
h = findobj(gca,'Tag','Median');
set(h,'Visible','off');
hold on
yline(1,'--','LineWidth',2,'Color','k')
legend('BMR when PDF is MAX')
%legend('Median of BMR')
%%
figure
subplot(2,1,1)
for dr = 1:length(num_rating)
    [A,B] = ksdensity(ratio_between_toy(:,dr));
    if dr == 10
        plot(B,A,'LineWidth',2)
    else
        plot(B,A,'--','LineWidth',2)
    end
hold on
end
title('Distribution Belief Mismatch Coefficient at different number of ratings');
legend('3 ratings','4 ratings','5 ratings','6 ratings','7 ratings','8 ratings','9 ratings','10 ratings','11 ratings','12 ratings')
xlabel('BMC')
ylabel('PDF')
%%

save('simulated_data_all_paper_plot.mat')



%%
pred_reject_area_toy = reverse_order(pred_reject_area_toy);
post_prob_toy = reverse_order(post_prob_toy);
all_pdf_toy = reverse_order(all_pdf_toy);
gt_all_post_reject_area_toy = reverse_order(gt_all_post_reject_area_toy);

%%
function rating_toy = reverse_order(rating_toy)
    rating_toy_new = rating_toy;
    for i = 1:8
        rating_toy{9-i} = rating_toy_new{i};
    end
end