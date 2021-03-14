% METROPOLIS SAMPLING EXAMPLE
randn('seed',12345);
  
% DEFINE THE TARGET DISTRIBUTION
p = inline('(1 + x.^2).^-1','x'); % 定义目标分布
  
% SOME CONSTANTS
nSamples = 5000; % 抽取5000个样本
burnIn = 500;
nDisplay = 30; % 将展示前30个抽样过程
sigma = 1; % 建议分布的标准差定义为1
minn = -20; maxx = 20;
xx = 3*minn:.1:3*maxx; % 抽样的区间
target = p(xx); % 目标函数在区间上的取值，用于下面画函数图
pauseDur = .8; % 动态展示过程中每个抽样需要暂停0.8秒
  
% INITIALZE SAMPLER
x = zeros(1 ,nSamples); % 初始化抽样序列
x(1) = randn; % 初始化第一个抽样
t = 1; % 抽样编号
  
% RUN SAMPLER
while t < nSamples % 当没有抽满指定数目的样本时
    t = t+1;
  
    % SAMPLE FROM PROPOSAL
    xStar = normrnd(x(t-1) ,sigma); % 按照建议抽样函数进行采样
    proposal = normpdf(xx,x(t-1),sigma); % 建议抽样函数在整个区间上的取值
  
    % CALCULATE THE ACCEPTANCE PROBABILITY
    alpha = min([1, p(xStar)/p(x(t-1))]); % 接受概率
  
    % ACCEPT OR REJECT?
    u = rand; % Metropolis 采样的核心部分，按照接受概率决定是否接受当前采样
    if u < alpha
        x(t) = xStar;
        str = 'Accepted';
    else
        x(t) = x(t-1);
        str = 'Rejected';
    end
  
    % DISPLAY SAMPLING DYNAMICS
    if t < nDisplay + 1 % 动态展示前 nDisplay 个采样过程
        figure(1);
        subplot(211);
        cla
        plot(xx,target,'k'); % 目标函数图像
        hold on;
        plot(xx,proposal,'r'); % 建议函数图像
        line([x(t-1),x(t-1)],[0 p(x(t-1))],'color','b','linewidth',2) % 目标函数在上一个采样点的函数值
        scatter(xStar,0,'ro','Linewidth',2) % 将当前采样点表示在x轴上
        line([xStar,xStar],[0 p(xStar)],'color','r','Linewidth',2) % 目标分布函数在当前采样点的函数值
        plot(x(1:t),zeros(1,t),'ko') % 将已经采样过的点表示在x轴上
        legend({'Target','Proposal','p(x^{(t-1)})','x^*','p(x^*)','Kept Samples'})
  
        switch str
            case 'Rejected'
                scatter(xStar,p(xStar),'rx','Linewidth',3) %如果拒绝，就用x表示这个点
            case 'Accepted'
                scatter(xStar,p(xStar),'rs','Linewidth',3) %如果接受，用方块表示这个点
        end
        scatter(x(t-1),p(x(t-1)),'bo','Linewidth',3) % 目标函数在上一个采样点的函数值
        title(sprintf('Sample % d %s',t,str))
        xlim([minn,maxx])
        subplot(212);
        hist(x(1:t),50); colormap hot;
        xlim([minn,maxx])
        title(['Sample ',str]);
        drawnow
        pause(pauseDur);
    end
end
  
% DISPLAY MARKOV CHAIN
figure(1); clf
subplot(211);
stairs(x(1:t),1:t, 'k');
hold on;
hb = plot([-10 10],[burnIn burnIn],'b--');
ylabel('t'); xlabel('samples, x');
set(gca , 'YDir', 'reverse');
ylim([0 t]);
axis tight;
xlim([-10 10]);
title('Markov Chain Path');
legend(hb,'Burnin');
  
% DISPLAY SAMPLES
subplot(212);
nBins = 200;
sampleBins = linspace(minn,maxx,nBins);
counts = hist(x(burnIn:end), sampleBins);
bar(sampleBins, counts/sum(counts), 'k');
xlabel('samples, x' ); ylabel( 'p(x)' );
title('Samples');
  
% OVERLAY ANALYTIC DENSITY OF STUDENT T
nu = 1;
y = tpdf(sampleBins,nu);
%y = p(sampleBins);
hold on;
plot(sampleBins, y/sum(y) , 'r-', 'LineWidth', 2);
legend('Samples',sprintf('Theoretic\nStudent''s t'))
axis tight
xlim([-10 10]);