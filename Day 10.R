library(tidyverse)
getwd()
df = readRDS(file = './data/Toyota.RDS')

cor(x = df$Age, y = df$Price, method = 'pearson')
cor(x = df$Age, y = df$Price, method = 'spearman')
corrtest = cor.test(x = df$Age, y = df$Price, method = 'pearson') # r이 0.1이라도, p가 0.05보다 작으면 상관관계가 있다 라고 할 수 있음
corrtest
corrtest$p.value

cor.test(x = df$KM, y = df$Price)
cor.test(x = df$HP, y = df$Price)
cor.test(x = df$CC, y = df$Price)
cor.test(x = df$Doors, y = df$Price)
cor.test(x = df$Weight, y = df$Price)

varClass = map_chr(df, class)
varClass
locs = which(varClass %in% c('integer', 'numeric'))
locs # contains index numbers of which above condition returns True

df[, locs]
map(df[, locs], function(x) cor.test(x, df$Price))

pvals = c()
for (i in locs) {
  corrtest = cor.test(df[,i], df$Price)
  pvals[i] = corrtest$p.value
}
pvals

result = data.frame(id = locs,
                    corr = NA,
                    pvals = NA)
result

imsi = df[, locs]
imsi # numerical columns only
for (i in 1:length(locs)) {
  corrtest = cor.test(imsi[,i], df$Price)
  result$corr[i] = corrtest$estimate
  result$pvals[i] = corrtest$p.value
}
locs = which(result$pval < 0.05)
imsi = imsi %>% select(locs)

# t test
table(df$MetColor)

by(df$Price, df$MetColor, shapiro.test)
wilcox.test(Price ~ MetColor, df) # use wilcox since both do not satisfy normality requirement
var.test(Price ~ MetColor, df) # p < 0.05, variances are different
t.test(Price ~ MetColor, df, var.equal = F)

by(df$Price, df$Automatic, shapiro.test)
var.test(Price ~ Automatic, df) # variances are equal
wilcox.test(Price ~ Automatic, df)
t.test(Price ~ Automatic, df)

# ANOVA
table(df$FuelType)
by(df$Price, df$FuelType, shapiro.test) # data, indices, function
kruskal.test(Price ~ FuelType, df)

install.packages('lawstat')
library(lawstat) # package for levene test
levene.test(y = df$Price, group = df$FuelType, location = 'mean') # different variances between groups
by(df$Price, df$FuelType, sd)
oneway.test(Price ~ FuelType, df, var.equal = F)

TukeyHSD(aov(Price ~ FuelType, df))

# Chi-squared test
install.packages('gmodels')
library(gmodels)
require(gmodels) # if package is installed, it brings the package in. If the package is not installed, require() == T returns F
if (require(gmodels) == F){
  install.packages('gmodels')
  require(gmodels)
} else {
  require(gmodels)
}

CrossTable(x = df$MetColor, y = df$Automatic)
chisq.test(x = df$MetColor, y = df$Automatic)

df = df %>% select(-FuelType, -Automatic)
saveRDS(df, file = './data/Toyota.RDS')
