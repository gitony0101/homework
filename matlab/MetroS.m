% METROPOLIS SAMPLING EXAMPLE
randn('seed',12345);
  
% DEFINE THE TARGET DISTRIBUTION
p = inline('(1 + x.^2).^-1','x'); % ����Ŀ��ֲ�
  
% SOME CONSTANTS
nSamples = 5000; % ��ȡ5000������
burnIn = 500;
nDisplay = 30; % ��չʾǰ30����������
sigma = 1; % ����ֲ��ı�׼���Ϊ1
minn = -20; maxx = 20;
xx = 3*minn:.1:3*maxx; % ����������
target = p(xx); % Ŀ�꺯���������ϵ�ȡֵ���������滭����ͼ
pauseDur = .8; % ��̬չʾ������ÿ��������Ҫ��ͣ0.8��
  
% INITIALZE SAMPLER
x = zeros(1 ,nSamples); % ��ʼ����������
x(1) = randn; % ��ʼ����һ������
t = 1; % �������
  
% RUN SAMPLER
while t < nSamples % ��û�г���ָ����Ŀ������ʱ
    t = t+1;
  
    % SAMPLE FROM PROPOSAL
    xStar = normrnd(x(t-1) ,sigma); % ���ս�������������в���
    proposal = normpdf(xx,x(t-1),sigma); % ����������������������ϵ�ȡֵ
  
    % CALCULATE THE ACCEPTANCE PROBABILITY
    alpha = min([1, p(xStar)/p(x(t-1))]); % ���ܸ���
  
    % ACCEPT OR REJECT?
    u = rand; % Metropolis �����ĺ��Ĳ��֣����ս��ܸ��ʾ����Ƿ���ܵ�ǰ����
    if u < alpha
        x(t) = xStar;
        str = 'Accepted';
    else
        x(t) = x(t-1);
        str = 'Rejected';
    end
  
    % DISPLAY SAMPLING DYNAMICS
    if t < nDisplay + 1 % ��̬չʾǰ nDisplay ����������
        figure(1);
        subplot(211);
        cla
        plot(xx,target,'k'); % Ŀ�꺯��ͼ��
        hold on;
        plot(xx,proposal,'r'); % ���麯��ͼ��
        line([x(t-1),x(t-1)],[0 p(x(t-1))],'color','b','linewidth',2) % Ŀ�꺯������һ��������ĺ���ֵ
        scatter(xStar,0,'ro','Linewidth',2) % ����ǰ�������ʾ��x����
        line([xStar,xStar],[0 p(xStar)],'color','r','Linewidth',2) % Ŀ��ֲ������ڵ�ǰ������ĺ���ֵ
        plot(x(1:t),zeros(1,t),'ko') % ���Ѿ��������ĵ��ʾ��x����
        legend({'Target','Proposal','p(x^{(t-1)})','x^*','p(x^*)','Kept Samples'})
  
        switch str
            case 'Rejected'
                scatter(xStar,p(xStar),'rx','Linewidth',3) %����ܾ�������x��ʾ�����
            case 'Accepted'
                scatter(xStar,p(xStar),'rs','Linewidth',3) %������ܣ��÷����ʾ�����
        end
        scatter(x(t-1),p(x(t-1)),'bo','Linewidth',3) % Ŀ�꺯������һ��������ĺ���ֵ
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