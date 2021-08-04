%% Understanding your data
%%
% Assuming you are measuring a quantity $x$ by $N$ times, each measurement 
% is labeled by $x_1$, $x_2$, ..., $x_N$. 
%% Using MATLAB on data analysis
% Though MATLAB provides a lot of handy functions for you to avoid typing
% complicated equations by hand, you still need to organize your data in
% the way that MATLAB can read. The most convenient way is using vectors to 
% store your measurements. For example, remind yourself how to construct a
% vector *|x|* which contains five measurements of the quantity $x$:
x
%%
% where $x_1 = 9.5717$, $x_2 = 10.0570$, .... 
%
% The total number of measurements is just the length of vector *|x|*:
length(x)
%%
% Therefore, $N=5$ in this example.
%% Summation and Average
% The best answer is then calculated by adding all values and dividing that
% sum by the number of measurements:
%
% $\langle x \rangle = \frac{1}{N}\left(x_1 + x_2 + ... + x_N\right)$,
%
% which is the same as the average value of x. In MATLAB, instead of typing
% |x(1)+x(2)+...|, you can use the internal function *|sum|*:
sum(x)
%%
% and the average value is
sum(x)/length(x)
%%
% Actually, MATLAB provides another internal function *|mean|* to quickly 
% calculate the mean value of a vector:
mean(x)
%% Standard deviation
% The standard deviation of your measurements basically tells you how well
% your data agree with each other and the mean:
%
% $\sigma_x = \sqrt{ \sum _{i=1}^N \left(x_i - \langle x \rangle\right)^2 /
% \left(N-1\right)}$.
%
% The smaller the value, the less error in your individual measurements.
% Despite the long equation, in MATLAB simply type
std(x)
%%
% 
