fs = 500;
tmax = 1;
nch = 21;

nt = fs*tmax;
t = (0:nt-1)/fs;
data = randn(nt,nch);

figure('Position',[1 1 500 800])
h = stackedplot(t,data,'k','DisplayLabels',"EEG"+(1:nch));
set(h.AxesProperties,'YLimits',[-3 3])