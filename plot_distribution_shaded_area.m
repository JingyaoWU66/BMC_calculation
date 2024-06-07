load('BMC_sample_data.mat')
close all
for u = 2:2
    ratings = arousal_dev{u}(:,2:7)*0.4975+0.5;
  %  test_sd{u}(1:50) = zeros(50,1);
    figure
x = [0:length(ratings)-1]/25;
y = mean(ratings'); %change this to your predicted mean
%y = Smu';
%y = Sw';
std_dev = std(ratings'); %change this to your predicted SD
%std_dev = Ssigma';
curve1 = y + 2*std_dev;
curve2 = y - 2*std_dev;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];

fill(x2, inBetween, [7 7 7]/8,'LineStyle','none');
hold on
plot(x,0.4975*arousal_dev{u}(:,2:7)+0.5,'LineWidth',2)
%hold on
%plot(y,'Linewidth',1,'color','r')
%cc_sd(u) = corr(movmean(gt_test_sd{u},10),movmean(test_sd{u},10));
%cc_mu(u) = corr(gt_test_mu{u},movmean(test_mu{u},10));
%ccc_sd(u) = ccc_calculation2(movmean(gt_test_sd{u},10),movmean(test_sd{u},10));
%title("CC sigma = " + cc_sd(u) + " CC mu = " + cc_mu(u))
end