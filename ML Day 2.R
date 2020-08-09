library(tidyverse)
library(psych)

getwd()
setwd('../data')
list.files()
df = readRDS('Toyota.RDS')

describe(df) # 데이터가 잘 들어와있는지 확인
df %>% 
  select(-c(FuelType, Automatic)) -> df

# separating into train and test sets
set.seed(1234)
index = sample(x = nrow(df), 
               size = nrow(df) * 0.7, 
               replace = F)
trainSet = df %>% slice(index)
testSet = df %>% slice(-index)

trainSet$Price %>% mean()
testSet$Price %>% mean() # 차이가 클 경우 문제가 생길 수 있음

# linear regression
fit1 = lm(Price ~ Age, trainSet)
summary(fit1)

# par(mfrow = c(1,1)) - sets the dimension for the plots
plot(x = fit1)

# Residuals (errors)
hist(fit1$residuals, freq = F)
lines(density(fit1$residuals), col = 'red', lwd = 2)
shapiro.test(fit1$residuals) # test for normality

# package for tests for errors
install.packages('car')
library(car)

ncvTest(fit1) # test for homoscedascity (등분산성)
durbinWatsonTest(fit1) # test for independence (상관성)
crPlots(fit1) # test for linearity, need more independent variables since pink and blue lines do not match (선형성)
influencePlot(fit1) # search for outliers, if Cook's distance > 1, considered an outlier

# Problem of Autocorrelation
fit2 = lm(formula = Price ~ Age + I(x = Age^2), data = trainSet)
summary(fit2)
crPlots(fit2) # better fit, but no usage because age^2 has, in reality, no meaning
vif(fit2) # test for autocorrelation between variables, > 10 means yes

avg = mean(trainSet$Age)
fit3 = lm(formula = Price ~ Age + I(x = (Age-avg)^2), data = trainSet)
summary(fit3)
crPlots(fit3)
vif(fit3) # solves the issue, but not recommended

rm(fit2, fit3) # removing objects from environment

# 모델 성능 평가
real = testSet$Price
pred1 = predict(object = fit1, newdata = testSet, type = 'response')
error1 = real - pred1 # error = actual value - predicted values

# MSE
error1^2 %>% mean()
# RMSE
error1^2 %>% mean() %>% sqrt()
# MAE
error1 %>% abs() %>% mean()
# MAPE
(abs(error1)/abs(real)) %>% mean() # 11%

# k 교차검증
crossValidation = function(x, y, data, k = 5, seed = 1234) {
  # x for independent variable, y for dependent variable, k = 5 specifies 5-fold
  set.seed(seed = seed)
  index = sample(x = 1:5, size = nrow(x = data), replace = T) # assigns index from 1-5 to each row
  formula = str_glue('{y} ~ {x}') %>% parse(text = .) %>% eval() # 표현식으로 만들어 줘야 formula로 인식하여 작동을 함, %>% 후 .는 그 전의 것을 뜻함
  errors = c() # empty vector for the errors of each test to go into
  for (i in 1:k) {
    train = data %>% filter(index != i) # index != 1 returns a vector with same length as the data with each value being True or False, and filter returns only the rows that correspond to True
    valid = data %>% filter(index == i)
    fit = lm(formula = formula, data = train)
    real = str_glue('valid${y}') %>% parse(text = .) %>% eval()
    pred = predict(object = fit, newdata = valid, type = 'response')
    errors[i] = (real - pred)^2 %>% mean() %>% sqrt()
  }
  return(mean(x = errors))
}

# SIDE: str.glue() puts variables into a string in given format, and parse and eval together converts the string into an expression that can be used
x = 'Age'
y = 'Price'
str_glue('{y} ~ {x}')

crossValidation(x = 'Age', y = 'Price', data = trainSet)
crossValidation(x = 'KM', y = 'Price', data = trainSet)
crossValidation(x = 'CC', y = 'Price', data = trainSet)
crossValidation(x = 'Doors', y = 'Price', data = trainSet)
crossValidation(x = 'HP', y = 'Price', data = trainSet)
crossValidation(x = 'Weight', y = 'Price', data = trainSet)

# Linear Regression with Multiple Independent Variables
full = lm(formula = Price ~., data = trainSet) # regression with all variables
null = lm(formula = Price ~ 1, data = trainSet) # regression with only y (y avg)
fit2 = step(object = null,
            scope = list(lower = null, upper = full),
            direction = 'both') # compares AIC starting from the bottom (no independent variables) and chooses the one with lower AIC until there is no ore choice that lowers AIC
summary(fit2)

plot(fit2)
shapiro.test(fit2$residuals) # normality
ncvTest(fit2) # homoscedascity
durbinWatsonTest(fit2) # independence
crPlots(fit2) # linearity
influencePlot(fit2) # outlier

vif(fit2) # over 10, remove

round(fit2$coefficients, 4) # shows all coefficients
# since all their scales are different, we cannot compare between coefficients
# we must standardize the values according to their scales in order to make a comparison

######## continued on 28 JUL
# Standardizing values
# package
install.packages('reghelper')
library(reghelper)

# Standardizing the coefficients
std = beta(model = fit2)
std
round(std$coefficients[, 1], 4)

# 모델 성능 평가
real = testSet$Price
pred2 = predict(object = fit2, newdata = testSet, type = 'response')
error2 = real - pred2 # error = actual value - predicted values

# MSE
error2^2 %>% mean()
# RMSE, used most often
error2^2 %>% mean() %>% sqrt()
# MAE
error2 %>% abs() %>% mean()
# MAPE
(abs(error2)/abs(real)) %>% mean() # 11%
