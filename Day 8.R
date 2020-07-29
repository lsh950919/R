getwd()
stat = readRDS(file = './data/2019_KBO_Hitter_Stats.RDS')
stat50 = stat %>% filter(타석 > 50)

# box plot
boxplot(stat50$OPS, main = '상자수염그림', horizontal = T)
abline(v = quantile(x = stat50$OPS), col = 'red', lty = 3) # line for each quartile
boxplot.stats(x = stat50$OPS) # shows quartiles, count, confidence interval, and OUTLIERS

# showing quartile values in plot as table
qnts = data.frame(stats = quantile(x = stat50$OPS)) %>% t() 
# converts the quartile values to dataframe, and transpose it to make it a single row
colnames(qnts) = c('Min', 'Qr1', 'Med', 'Qr3', 'Max') 
# give names to the values
qnts

par(mar = c(6, 4, 4, 2)) # changes the size of margin of plot
boxplot(stat50$OPS, main = 'Boxplot of OPS', horizontal = T)

# creating the table
install.packages('plotrix')
library(plotrix)
addtable2plot(x = 0.30,
              y = 0.03,
              table = qnts,
              bty = 'o',
              cex = 1,
              xpad = 0.2,
              ypad = 0.4,
              display.rownames = T,
              hlines = T,
              vlines = T)
### x & y - starting place in plot, table - values of table, bty - border type, cex - text size, xpad & ypad - margin of table in plot, display.rownames - adding row names to table, hlines & vlines - 

# Multiple boxplots
boxplot(formula = OPS ~ 팀명,
        data = stat50,
        main = '팀별 OPS 분포')
abline(h = median(stat50$OPS), col = 'red', lwd = 2)
### line displays the median of all OPS

# quartiles of OPS for each team
qnts = stat50 %>% 
  group_by(팀명) %>% 
  summarize(Min = quantile(OPS, 0.00),
            Qr1 = quantile(OPS, 0.25),
            Med = quantile(OPS, 0.50),
            Qr3 = quantile(OPS, 0.75),
            Max = quantile(OPS, 1.00))

# need to be edited
qnts[,2:6] %>% 
  map_df(qnts[, 2:6], function(x)round(x, 3L))

qnts = t(qnts) # t transposes the table that has values for each team in row to table that has values for each team in column
qnts
colnames(qnts) = qnts[1,] # give names to columns
qnts = qnts[-1,] # remove first row that contains team name

# displaying plot and table of quartiles
boxplot(formula = OPS ~ 팀명,
        data = stat50,
        xaxt = 'n',
        xlab = NULL,
        main = '팀별 OPS 분포')
addtable2plot(x = -0.5,
              y = -1.5,
              table = qnts,
              bty = 'o',
              cex = 0.6,
              xpad = 0.2,
              ypad = 0.4,
              display.rownames = T,
              hlines = T,
              vlines = T)

# showing boxplot and histogram at the same time
install.packages('packHV')
library(packHV)
par(mar = c(5, 4, 4, 2))
hist_boxplot(stat50$OPS, freq = T)
dev.off() # reset settings of plot
### dev.off() must be done since hist_boxplot changes the settings of plot display

# Scatter Plot
plot(stat50$출루율, 
     stat50$장타율, 
     pch = 19, 
     cex = 0.8,
     col = 'gray70',
     main = '출루율 vs 장타율')

# highlighting certain points in scatter plot
ops09 = stat50 %>% filter(팀명 == 'LG') # create basis for which points to highlight
points(ops09$출루율,
       ops09$장타율,
       pch = 19, # dot shape
       cex = 0.6,
       col = 'red') # display the points on plot 
text(ops09$출루율, 
     ops09$장타율,
     labels = ops09$이름, # what text to display
     pos = 2, # 1 - below, 2 - left, 3 - above, 4 - right of point
     cex = 0.7,
     font = 2, # bold
     col = 'darkblue') # display name of point

# mean of x and y axis
abline(v = mean(stat50$출루율),
       h = mean(stat50$장타율),
       col = 'red',
       lty = 2) # line type: 1 - solid, 2 - dotted line

# showing regression line in plot
reg = lm(장타율~출루율, stat50) # linear regression

abline(reg = reg, col = 'darkgreen', lwd = 2) # displaying regression line on plot

# Scatter Plot Matrix
pairs(stat[, 5:11])

panel.cor = function(x,y) {
  par(usr = c(0, 1, 0, 1)) # size of each matrix
  corr = cor(x, y, use = 'complete.obs') %>% round(2L) # use = 'complete.obs' tells R to take out NA values
  text(0.5, 0.5, corr, cex = 2*abs(corr)) # place text at 0.5, 0.5 place (middle of plot) with text size according to the value
}

pairs(stat[, 5:11],
      cex.labels = 2, # text size
      upper.panel = panel.cor)

# more visualized scatter plot matrix
install.packages('corrplot')
library(corrplot)

corr = cor(stat50[, 5:11])
corrplot(corr, 'ellipse')
corrplot(corr, 'pie')
corrplot.mixed(corr) # shows both values and visualization

# Line Graph
plot(sort(stat50$OPS),
     type = 'l', # l for line, p for point, b for
     ylab = 'OPS',
     main = 'Line graph of OPS')

# showing quartiles on graph
qnts = quantile(stat50$OPS, probs = c(.9, .75, .5, .25, .05))
for (i in 1:length(qnts)) {
  abline(h = qnts[i], col = 'red', lty = 3) # each line for each loop
  text(x = 0, y = qnts[i], labels = str_c(names(qnts), ':', qnts[i]),
       pos = 3, cex = 0.8, font = 2) # show value of line
}

# 8-3
stat %>% group_by(팀명) %>% 
  summarize(인원 = n(), 팀안타 = sum(안타)) %>% 
  mutate(평균안타 = round(팀안타/인원, 2L)) %>% 
  arrange(desc(평균안타)) -> teamHits

range(teamHits$평균안타)
# bar plot of avg hits by team
bp = barplot(height = teamHits$평균안타,
             names.arg = teamHits$팀명,
             col = 'orange',
             ylim = c(0, max(teamHits$평균안타) * 1.1), # must be done in case text needs to be added above the bars
             main = '팀별 평균안타 비교')

# showing values on the bar
text(bp, teamHits$평균안타, labels = teamHits$평균안타, pos = 3, cex = 0.8, col = 'black', font = 2)

# NA values
is.na(stat) %>% sum()
### count of NA values

is.na(stat$BABIP) %>% sum()
map_int(stat, function(x) is.na(x) %>% sum())
# count by column

is.na(stat) %>% mean()
map_dbl(stat, function(x) is.na(x) %>% mean())
# % of NA values in each column

install.packages('mice')
library('mice') # helps dealing with NA values

md.pattern(stat, rotate.names = T)
### visualization of NA values in each column, each block corresponds to a specific number of NA values, additional blocks correspond to additional number of NA values compared to other columns

# finding percentage of NA values in each column
NApcnt = map_dbl(stat, function(x) is.na(x) %>% mean())
locs = which(NApcnt >= 0.05) # gives index number of columns that contain NA values more than 5%
stat = stat %>% select(-locs) # takes out columns which NA values take up more than 5% of the values

# Single Imputation
varClass = map_chr(stat, class) # returns vector that tells what class each column is
locs = which(varClass %in% c('integer', 'numeric')) # returns index of columns that are integer or numeric type
locs
### %in% is same as in in SQL

imputation = function(x) {
  x[is.na(x)] = median(x, na.rm = T) # x[is.na(x)]: for NA values in column x
  return(x)
} # function that replaces NA with median

impute1 = map_df(stat[, locs], imputation) # for each integer and numeric columns, process imputation function (removing NA values with median)
is.na(impute1) %>% sum() # since all NA values are replaced, this gives 0


impute2 = stat %>% filter(complete.cases(stat)) # complete.cases - all rows that contain NA
impute2 = stat %>% filter(is.na(stat$타율) == F) # or !is.na()

# Multiple Imputation
mulimp = mice(stat, 
              5, # give 5 cases
              'pmm', # pmm: Predictive Mean Matching, method of multiple imputation
              seed = 1234) 
summary(mulimp)
mulimp$imp$타율 # gives 5 choices
impute3 = complete(mulimp, action = 1)
