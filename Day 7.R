# Basis
library(tidyverse)
getwd()
list.files('.RDS')
stat = readRDS('./data/2019_KBO_Hitter_Stats.RDS')

stat %>% group_by(팀명) %>% 
  summarize(인원 = n(), 팀안타 = sum(안타)) %>% 
  mutate(평균안타 = round(팀안타/인원, 2L)) %>% 
  arrange(desc(평균안타)) -> teamHits

# mean function
mean(stat$안타)
mean(stat$안타, na.rm = T) # remove NA values
mean(stat$안타, trim = 0.05) # trimmed mean - removes top & bottom n% of the data and calculates the mean - removes outliers
mean(stat$안타, trim = 0.1)

# weighted mean
install.packages('matrixStats')
library(matrixStats)
weighted.mean(teamHits$평균안타, teamHits$인원)
# first is the values, second is the weight to take mean by

# median function
median(stat$안타)
median(stat$안타, na.rm = T)

# mode: no function, so must calculate using tables
tbl = table(stat$안타); print(tbl)
names(tbl) # returns in string
tbl == max(tbl)
names(tbl)[tbl == max(tbl)]

# range function
range(stat$안타)
min(stat$안타)
max(stat$안타)
max(stat$안타) - min(stat$안타) # basic way to get range
range(stat$안타) %>% diff() # statistical range: max - min
### since range gives min and max instead of the statistical mean

obj = stat$타율
range(obj, na.rm = T) # replace by highlighting phrase and using find to replace each item
min(obj, na.rm = T)
max(obj, na.rm = T)
max(obj, na.rm = T) - min(obj, na.rm = T) # basic way to get range
range(obj, na.rm = T) %>% diff() # statistical range: max - min

# quantile function: gives all quartiles (% can be specified)
quantile(stat$안타) # NOT QUARTILE
quantile(stat$안타, probs = seq(0, 1, 0.25)) # default form
quantile(stat$안타, probs = 0)
quantile(stat$안타, probs = 1)
quantile(stat$안타, probs = 0.5)
quantile(stat$안타, probs = 0.9)
quantile(stat$안타, probs = c(0.1, 0.9))
quantile(stat$안타, probs = seq(0, 1, 0.1))
### if we give another range in probs, R will calculate the sections and give values for each percentile point

# Interquartile Range (Q3 - Q1)
IQR(stat$안타)
### IQR is used for identifying outliers: Q1 - 1.5 * IQR -> lower fence, Q3 - 1.5 * IQR -> upper fence. In box and whisker plot, if outliers exist, the tip of the whiskers will represent the fences instead of the min/max

# variance & standard deviation
var(stat$안타) # sum of (xi - mean)^2 * 1/n (1/n-1 for samples)
sd(stat$안타) # variance ^ 1/2

# Median Absolute Deviation
mad(stat$안타)
### stat that also describes spread (median of |xi - median|). Since median is less affected by outliers, it can be said that MAD is sometimes more statistically robust than sd

# install moments package that contains skewness and kurtosis
install.packages('moments')
library(moments)

# Skewness: describes how slanted the distribution is
skewness(stat$안타)
### + means that the data is skewed to the right (positive skew, more values on left side), and - means that the data is skewed to the left (negative skew, more values on the right side)

# Kurtosis: describes how sharp the hill is
kurtosis(stat$안타)
### a normal distribution has a kurtosis of 3. If kurtosis > 3 then the top is sharper than normal distribution, and kurtosis < 3 means the top is flatter

# Application
set.seed(1234)
kurtosis(rnorm(n = 10000, mean = 0, sd = 1))
# rnorm gives random values following the distribution created by the specified mean and standard deviation

# Practice
heights = rnorm(n = 5000, mean = 172.4, sd = 5.7) # height stat
skewness(heights)
kurtosis(heights)
shapiro.test(heights) # test for normality of distribution

# perform mean & sd on every column and return as float
map_dbl(stat[, 3:19], mean, na.rm = T)
map_dbl(stat[, 3:19], sd, na.rm = T)

summary(stat) # length for character, frequency for factors, descriptive stats for number vector columns

# install psych package that contains describe
install.packages('psych')
library(psych)

# describe function
describe(stat[, 3:19]) 
# n gives count excluding NA, 0.1 for trimmed mean

cov(stat$타수, stat$안타)
cov(stat$타수, stat$안타, use = 'complete.obs') # complete.obs is in place of na.rm
cor(stat$타수, stat$안타, use = 'complete.obs')

# plots
range(stat$타석)
breaks = seq(0, 650, 50)
breaks

cuts = cut(stat$타석, 
           breaks = breaks, 
           include.lowest = T)
cuts # factor type, ( - 초과, ] - 이하
stat$타석[1:10]
cuts[1:10]
table(cuts)
cuts %>% 
  table() %>% # frequency
  prop.table() %>% # proportion table
  round(4L) * 100 # in percentages

stat50 = stat %>% filter(타석 > 50)

par(family = 'AppleGothic') # for Mac
# plot 창 설정
# freq = T -> frequency, freq = F -> proportion
hist(stat50$타석,
     freq = T,
     breaks = breaks,
     ylim = c(0, 40),
     col = 'blue',
     border = 'yellow',
     labels = T,
     main = '히스토그램',
     xlab = '타석',
     ylab = '빈도수')

range(stat50$OPS)
breaks2 = seq(0.2, 1.1, 0.05)
hist(stat50$OPS, 
     breaks = breaks2,
     col = 'gray90',
     labels = T,
     ylim = c(0))

hist(stat50$OPS, breaks = breaks2)
lines(density(stat50$OPS), col = 'red', lwd = 2)

hist(stat50$OPS, breaks = breaks2, freq = F)
lines(density(stat50$OPS), col = 'red', lwd = 2)
# unit must be in frequency to be in right size according to the axis