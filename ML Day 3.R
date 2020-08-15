library(tidyverse)

wine = read.csv(file = 'https://bit.ly/white_wine_quality', sep = ';')
glimpse(wine)

# shows the cumulative sum of proportion of each quality score
wine$quality %>% 
  table() %>% 
  prop.table() %>% 
  cumsum() %>% 
  round(4) * 100 

# table of count of each quality score
tbl = table(wine$quality)

# barplot of count by quality score
bp = barplot(height = tbl,
             ylim = c(0, 2400),
             xlab = 'Quality Score',
             main = 'White Wine Quality',
             # col = 'gray70'
             # col = c(rep('gray70', 4), rep('red', 3)) # 색 분할
             col = myPal3 # we can create our own color palette
             )
text(x = bp, y = tbl, labels = tbl, pos = 3, font = 2) # text showing count

# dividing range of quality to binary variable (3-6: good, 7-9: best)
wine$grade = ifelse(test = wine$quality <= 6, 'good', 'best')
wine$grade = as.factor(wine$grade)
table(wine$grade, wine$quality)
wine$quality = NULL
### We must remove the original data once new y variable has been created in order to avoid high correlation between x and y

boxplot(alcohol ~ grade, wine) # shows boxplot of alcohol by new binary variable

# creating train and test variables
set.seed(1234)
n = nrow(wine)
index = sample(n, n * 0.7, replace = F)
trainSet = wine %>% slice(index)
testSet = wine %>% slice(-index)

trainSet$grade %>% table() %>% prop.table()
testSet$grade %>% table() %>% prop.table()

install.packages('kknn')
library(kknn)

# defining number for k (usually use sqrt of # of data)
k = trainSet %>% nrow() %>% sqrt() %>% ceiling()
k

# KNN Model
fitN = kknn(formula = grade ~ .,
            train = trainSet,
            test = testSet,
            k = k,
            kernel = 'rectangular')
str(fitN)
### fitted values represent the predicted result, CL are the actual corresponding values to the factor, and prob represents the probability that the value is positive (the target value)

# defining real vs predicted values
real = testSet$grade
fitN$fitted.values -> predN

# packages for confusion matrix
install.packages('caret')
install.packages('e1071')
library(caret)

# Confusion Matrix
confusionMatrix(data = predN, reference = real, positive = 'best')
### accuracy: 0.817, sensitivity: 0.3535, precision: 0.62712

# package for f1 score
install.packages('MLmetrics')
library(MLmetrics)

# F1 Score
F1_Score(y_true = real, y_pred = predN, positive = 'best') # 0.45214

# package for ROC curve
library(pROC)

probN = fitN$prob[, 1]
### since ROC curve is drawn based on the probability that each value is positive, we must extract the probabilities from the model result

# ROC Curve
roc(response = real, predictor = probN) %>% plot() # *** 추정확률로 구하는것

# AUC (Area Under Curve)
auc(response = real, predictor = probN) # 0.8269

# Sample Balancing
# packages for SMOTE
install.packages('DMwR')
library(DMwR)

# SMOTE
set.seed(1234)
trainBal = SMOTE(form = grade ~.,
                 data = trainSet,
                 perc.over = 200, # 200% reproduce
                 k = 10,
                 perc.under = 150) # cut down number of majority value down to 150% of number of minority values

trainSet$grade %>% table() # original proportion of values
trainBal$grade %>% table() # adjusted proportion of values (always 50:50 for balanced set)
### when the number of values of target variable are not in proportion (in this case, 78:22 for good:best), the predictions always incline towards the majority (usually the value we are not interested in) just because there are more of them, so in order to avoid this we balance out the number of values for each binary

levels(trainSet$grade)
levels(trainBal$grade) # checking for correct order of binary data since it may change

# KNN using balanced values
fitB = kknn(formula = grade ~ .,
            train = trainBal,
            test = testSet,
            k = k,
            kernel = 'rectangular')

# Model Evaluation Process (confusion matrix -> sensitivity & precision -> F1)
predB = fitB$fitted.values
confusionMatrix(data = predB,
                reference = real, 
                positive = 'best') # lower precision, higher sensitivity
### accuracy: 0.6524, sensitivity: 0.8917, precision: 0.3699
### lower accuracy and precision, but higher sensitivity
F1_Score(y_true = real, y_pred = predB, positive = 'best') # 0.52288, higher score compared to unbalanced, thus better

# ROC Curve
probB = fitB$prob[, 1]
roc(response = real, predictor = probB) %>% plot()

# two plots at once
roc(response = real, predictor = probN) %>% 
  plot(main = 'ROC 곡선', col = 'red')
roc(response = real, predictor = probB) %>% 
  plot(col = 'blue', add = T)
### we include add = T at the end in order to display plot on top of the plot printed beforehand

# Change in AUC from balancing
auc(response = real, predictor = probN) # 0.8269 for unbalanced
auc(response = real, predictor = probB) # 0.8318 for balanced

# Weighted KNN
fitW = kknn(formula = grade ~ .,
            train = trainSet,
            test = testSet,
            k = k,
            kernel = 'triangular') # changed from rectangular

# Model Evaluation
predW = fitW$fitted.values
confusionMatrix(data = predW, reference = real, positive = 'best')
### accuracy: 0.8435 > 0.817, sensitivity: 0.4713 > 0.3535, precision: 0.6981 >   0.62712, all values are higher since we have given weights depending on distance
F1_Score(real, predW, positive = 'best') # 0.56274 > 0.45214, significantly higher

# ROC Curve
probW = fitW$prob[, 1]
roc(response = real, predictor = probW) %>% 
  plot(main = 'ROC 곡선', col = 'black', lwd = 2, add = T)
auc(response = real, predictor = probW) # 0.8656 > 0.8269

# Weighted KNN with balanced target variable
fitWB = kknn(formula = grade ~ .,
            train = trainBal,
            test = testSet,
            k = k,
            kernel = 'triangular')

# Model Evaluation
predWB = fitWB$fitted.values
confusionMatrix(predWB, real, positive = 'best')
F1_Score(y_true = real, y_pred = predWB, positive = 'best')

# ROC Curve
probWB = fitWB$prob[, 1]
roc(response = real, predictor = probWB) %>% 
  plot(col = 'orange', lwd = 3, lty = 2, add = T)
auc(response = real, predictor = probWB)

# Cross-Validation for finding the optimal k
kvec = seq(3, 159, by = 2) # k values must be odd to avoid dividing up 50:50

library(kknn)
library(MLmetrics)
# good habit to call packages during the process just in case it is not called above

result = c() # stores f1 scores for each model with different k
for (k in kvec) {
  cat('현재', k, '로 작업중!\n', sep = '') # process check
  
  # KNN Model for each k
  fit = kknn(formula = grade ~ .,
               train = trainSet,
               test = testSet,
               k = k,
               kernel = 'triangular')
  
  # variables for calculating F1 score (actual vs predicted values)
  real = testSet$grade
  pred = fit$fitted.values
  
  f1 = F1_Score(y_true = real, y_pred = pred, positive = 'best')
  result = c(result, f1) # this adds the new score into the vector of scores
}

print(result)

# Plot of F1 scores by k
plot(kvec, result, type = 'b', col = 'red')
### we can see that k = 7 gives the highest F1 score
which(result == max(result)) # finding index of highest F1 score
### this gives 3, but we must we remember that the actual k value is 3 + 2*index

# Lines to indicate the k value with highest F1 score
abline(h = max(result), col = 'black', lty = 3)
abline(v = 7, col = 'black', lty = 3)
text(x = 7, y = 0.65, labels = str_c('k는', kvec[3]), font = 2, col = 'blue')

# KNN Model with k = 7
fitW7 = kknn(formula = grade ~ .,
            train = trainSet,
            test = testSet,
            k = 7,
            kernel = 'triangular')

# Model Evaluation
predW7 = fitW$fitted.values
confusionMatrix(data = predW7, reference = real, positive = 'best')
F1_Score(real, predW7, positive = 'best')

# ROC Curve
probW7 = fitW7$prob[, 1]
roc(response = real, predictor = probW7) %>% 
  plot(main = 'ROC 곡선', col = 'black', lwd = 2)
auc(response = real, predictor = probW7)



# SIDE: creating color palette
install.packages('RColorBrewer')
library(RColorBrewer)
display.brewer.all()
display.brewer.pal(n = 7, name = 'Reds')
myPal1 = brewer.pal(n = 7, name = 'Reds')
myPal1 # color codes
myPal2 = gray(level = seq(0.8, 0.2, length = 7))
myPal2
myPal3 = colorRampPalette(colors = c('red', 'yellow', 'purple'))(7)
