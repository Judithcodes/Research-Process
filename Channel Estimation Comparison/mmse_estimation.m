function output=mmse_estimation(input,pilot_inter,pilot_sequence,trms,t_max,var)

%����256��*120�е��źž��󣬵�Ƶ���5����Ƶ����Xp��256��*1�У�snr������ȵ���ֵ
%trmsΪ�ྭ�ŵ���ƽ����ʱ���˴����е�ʱ�䶼���Ѿ��Բ���������˹�һ����Ľ����ֵΪ0.4937
%t_maxΪ�����ʱ,�˴����е�ʱ�䶼���Ѿ��Բ���������˹�һ����Ľ����ֵΪ1.5744

j=sqrt(-1);%---------------------------------------------------------------����j
[N,NL]=size(input);%-------------------------------------------------------�����źž���Ĵ�С��N=256���У���NL=120���У�
Rhh=zeros(N,N);%---------------------------------------------------------����ؾ���Ϊһ��120��*120�еķ���

%%%%%%%%%%%%%%%%%%%%%%%%%%%����LS�ŵ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
count=1;
while i<=NL
    Hls(:,count)=input(:,i)./pilot_sequence;%------------------------------���LS�ŵ�����
    count=count+1;
    i=i+pilot_inter+1;
end

%%%%%%%%%%%%���븺ָ���ֲ�ʱ��������ŵ��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:N
    for l=1:N%------------------------------------------------------------�������غ���Rhh
        Rhh(k,l)=(1-exp((-1)*t_max*((1/trms)+j*2*pi*(k-l)/N)))./(trms*(1-exp((-1)*t_max/trms))*((1/trms)+j*2*pi*(k-l)/N));
    end
end

weiner_coeff=Rhh*inv(Rhh+(var)*eye(N));
output=weiner_coeff*Hls;
%%%%%%%%%%%%%%���ݹ�ʽHmmse=Rhh*Hls*inv(Rhh+var*inv(Xp'Xp))%%%%%%%%%%%%%%%%%%%%%%
