library(tidyverse)

set.seed(1234)
hgts = rnorm(1000, 170, 15) # rnorm - gives random numbers following a normal distribution given mean and sd
range(hgts)
breaks = seq(115, 220, 1)
hist(hgts, breaks = breaks)

hgts = rnorm(100000, 170, 15) # more numbers generated, better shape toward normal distribution
hgts = rnorm(100000, 170, 10)
hgts = rnorm(100000, 170, 5)
range(hgts)
breaks = seq(100, 230, 1)
hist(hgts, breaks = breaks)

# pnorm - given value, returns probability of that value in given mean and sd
pnorm(180, 170, 15)
pnorm(180, 170, 10)
pnorm(180, 170, 5)
pnorm(189, 175.6, 5.3)

# qnorm - given probability, returns value (opposite of pnorm)
qnorm(0.7475075, 170, 15)

# dnorm - density (밀도값) - height of point in distribution
dnorm(180, 170, 15)
dnorm(180, 170, 10)
### lower sd, higher density

# scale - gives z score of a specific value given mean and sd
scale(180, 170, 15)

# 수학 vs 영어
scale(90, 75, 15)
scale(55, 40, 10)

# Practice
df = read.csv('https://bit.ly/toyota_price', header = T)
str(df)
summary(df)
head(df, 10)

df[, c(4, 6:7)] = map_df(df[, c(4, 6:7)], as.factor)
### because CNG only has 17 values, it might be better to throw it away, and diesel needs more numbers as well
### there are only 80 manual cars compared to 1356, so might be better to not use it

hist(df$Price)
boxplot(df$Price, horizontal = T)
plot(x = df$Age, 
     y = df$Price)

plot(formula = Price ~ Age, # formula can be used instead of specifying x and y
     data = df,
     pch = 19,
     col = 'gray70')

plot(formula = Price ~ KM,
     data = df,
     pch = 19,
     col = 'gray70')

plot(formula = Price ~ Weight,
     data = df,
     pch = 19,
     col = 'gray70')
abline(v = 1350, col = 'red', lty = 3) # putting line to separate by in plot

plot(formula = Price ~ HP,
     data = df,
     pch = 19,
     col = 'gray70')
avg = df %>% 
  group_by(HP) %>% 
  summarize(m = mean(Price)) # creating mean values to put into plot
points(avg$HP, avg$m, pch = 19, col = 'red', cex = 1.2) # putting mean in scatterplot/boxplot

plot(formula = Price ~ CC,
     data = df,
     pch = 19,
     col = 'gray70')
avg = df %>% 
  group_by(CC) %>% 
  summarize(m = mean(Price))
points(avg$CC, avg$m, pch = 19, col = 'red', cex = 1.2)

plot(formula = Price ~ Doors,
     data = df,
     pch = 19,
     col = 'gray70')
avg = df %>% 
  group_by(Doors) %>% 
  summarize(m = mean(Price))
points(avg$Doors, avg$m, pch = 19, col = 'red', cex = 1.2)

boxplot(formula = Price ~ FuelType, data = df)
avg = df %>% 
  group_by(FuelType) %>% 
  summarize(m = mean(Price))
points(avg$FuelType, avg$m, pch = 19, col = 'red', cex = 1.2)

boxplot(formula = Price ~ MetColor, data = df)
avg = df %>% 
  group_by(MetColor) %>% 
  summarize(m = mean(Price))
points(avg$MetColor, avg$m, pch = 19, col = 'red', cex = 1.2)

boxplot(formula = Price ~ Automatic, data = df)
avg = df %>% 
  group_by(Automatic) %>% 
  summarize(m = mean(Price))
points(avg$Automatic, avg$m, pch = 19, col = 'red', cex = 1.2)

df = df %>% 
  filter(HP <= 120 & Weight <= 1350 & Doors >= 3)
df
### All the steps above are a process to determine which variable may be correlated well with the dependent variable - thus fit to create regression models

t.test(Price ~ MetColor,
       data = df,
       alternative = 'two.sided',
       paired = F,
       var.equal = F)
