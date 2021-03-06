function output=ls_DFT_estimation(input,pilot_inter,pilot_sequence,num)%---输入256行*120列的信号矩阵，导频间隔5，导频符号Xp是256行*1列，num是循环前缀长度为16
%%%%%%%%%%此方法用的是LS_DFT信道估计法，可以去除循环前缀以外的噪声%%%%%%%%%%%%%
%在LS中Hls=Yp/Xp;之后使用ZF迫零均衡，s(k)=r(k).c(k),其中c(k)=1/Hls;所以s(k)=r（k）/Hls

[N,NL]=size(input);%-------------------------------------------------------待估计信号矩阵的大小，N=256（行），NL=120（列）
i=1;%----------------------------------------------------------------------用来找导频符号所在的列数
count=1;%------------------------------------------------------------------用来统计导频符号的个数
while i<=NL
   Hi=input(:,i)./pilot_sequence;%-----------------------------------------导频位置的LS信道估计，得到每一个位置的Hls=Yp/Xp，这里的Hls矩阵是256行*1列
   Rx_symbols_dft=ifft(Hi);%-----------------------------------------------直接做iFFT，将频域的导频位置处的信道估计值变换到时域，这里的Rx_symbols_dft是时域信号，256行*1列
   Rx_symbols_ifft_dft=zeros(N,1);%----------------------------------------先生成一个128*1的矩阵，
   Rx_symbols_ifft_dft(1:num,:)=Rx_symbols_dft(1:num,:);%------------------只保留循环前缀长度CP=16以内（前16行）的信道估计值，将循环前缀长度以外的信道估计值置为0
   Rx_training_symbols_dft=fft(Rx_symbols_ifft_dft);%----------------------将处理之后的时域信号的值变换到频域内，得到这一列的信号估计值
   output(:,count)=Rx_training_symbols_dft;%-------------------------------得到是输出矩阵的第count列，共需要完成20列的处理
   count=count+1;
   i=i+pilot_inter+1;
  end