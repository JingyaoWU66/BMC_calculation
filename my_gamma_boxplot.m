function my_gamma_boxplot(ratio_temp,gamma,Bx)

    %ratio_temp = ratio_SMC;
    %Bx = linspace(0.02,2,100);
    %delta = 0.02;
    delta = Bx(2)-Bx(1);
    figure
    histogram(ratio_temp,'Normalization','pdf')
    hold on
    [A_pdf,Bx] = ksdensity(ratio_temp,Bx);
    plot(Bx,A_pdf,'LineWidth',2)
    xlabel('Belief Mismatch Ratio','FontSize',14)
    ylabel('PDF')
%%
%gamma = 0.75
[~,max_id] = max(A_pdf);
%save_id = 1;

for p = 1:max_id
    %[~,id] = min(abs(y_pdf(1:max_id)-th(p)));
    %x1 = x(id);
    x1(p) = p;
    [~,id] = min(abs(A_pdf(max_id+1:end)-A_pdf(p)));
    x2(p) = id+max_id;
    total_area(p) = sum(A_pdf(x1(p):x2(p)))*delta;
    %cdf 可能不是area?只是在那个点上的cdf值，应该要把前面所有值的cdf算一遍然后加起来才是面积？
   % total_area = (x2(p) - x1(p))*delta
    %area1 = cdf('Beta',x1(p),pred_alp,pred_bet);
    %area2 = cdf('Beta',x2(p),pred_alp,pred_bet);
    %total_area(p) = area1 + (1-area2);
end
figure
subplot(1,2,1)
plot(total_area)
[~,min_id] = min(abs(total_area-gamma));
BMR_index(1) = Bx(x1(min_id));
BMR_index(2) = Bx(x2(min_id));
BMR_interval = Bx(x1(min_id):x2(min_id));
figure
%histogram(ratio_temp,'Normalization','pdf')
%hold on
subplot(2,2,1)
[A_pdf,Bx] = ksdensity(ratio_temp,Bx);
area(BMR_interval,A_pdf(x1(min_id):x2(min_id)),0,'EdgeColor','none','FaceColor',[0.7,0.7,0.7]);
hold on
plot(Bx,A_pdf,'b','LineWidth',2)
xlabel('Belief Mismatch Ratio','FontSize',14)
title('Distribution of Belief Mismatch Ratio')
ylabel('PDF')
subplot(2,2,2);
bh = boxplot(BMR_interval);
set(bh,'LineWidth', 2);
ylabel('BMR')
title("BMR range under 75% confident interval")
%min_area(n) = total_area(min_id(n));


end