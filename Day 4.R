# Apply function
# vectorization - putting each element in vector through a function
# however, for lists or data frames, each column must be put through individually to find the result of these functions, and thus apply() is used instead of putting them in a for loop

str(iris)
vec = iris[, 1:4] # remove factor column since apply cannot be used on factors/has no meaning from results of factors
apply(X = vec, MARGIN = 1, FUN = sum)
apply(vec, 2, sum)
# apply(object, by row or column, function)
### 인자 must be in capital letters for apply

apply(vec, 1, mean)
apply(vec, 2, mean)
# a lot faster using apply than a for loop

# sapply/lapply - apply for lists & dataframes
lst = list(iris$Sepal.Length, iris$Petal.Length)
sapply(X = vec, FUN = mean)
lst1 = sapply(X = vec, FUN = mean, simplify = F)
### since sapply or lapply is used on lists, which is in 1D, there is no need to specify row or column. The process is applied to each item in the list
# simplify = T (default) gives the result as either a vector or a matrix depending on how many categories are printed. simplify = F returns the result in list form, which is the same as using lapply
# Extra
tolower(LETTERS)
unlist(lst1)

df1 = cars
str(cars)

lapply(X = lst, FUN = mean)
# sapply returns a vector/matrix whereas lapply returns a list

sapply(X = vec, FUN = range) # range gives min and max instead of their difference
lapply(X = vec, FUN = range)

sapply(X = iris[, 1:4], FUN = function(x)length(x = x[x >= 5]))
# this brings each column in iris from col 1 to 4 and puts them through the function behind

# process of defined functions code
x = iris[, 1]
x >= 5
x[x >= 5]
length(x[x >= 5])

#tapply
tapply(X = iris$Sepal.Length, INDEX = iris$Species, FUN = mean)
# takes a vector, a factor, and puts them through the function by each factor level
### the result is the function applied onto values in X grouped by INDEX
sapply(X = iris[, 1:4], FUN = function(x) {
  tapply(X = x,
         INDEX = iris$Species,
         FUN = mean)
  }
)
### the data used after function(x) must ALWAYS be x because the process takes out a vector x from data specified beforehand and applies the function to that specific x
### since tapply only takes a vector, we can put it through sapply to have it go through an object with more dimensions

set.seed(1234)
univ = data.frame(math = sample(50:99, 20, T)
                  , eng = sample(50:99, 20, T)
                  , kor = sample(50:99, 20, T)
                  , com = sample(50:99, 20, T))
# random test scores by subject

system.time(expr = for (i in 1:4) print(mean(univ[,i])))
system.time(expr = sapply(X = univ, FUN = mean))
# system.time gives how much time it takes to process the command inside

sapply(X = univ, FUN = function(x) {
  ifelse(x <= 69, 'Yes', 'No')
})
# using an ifelse statement as function
# for each columns in univ, each item in column is checked if it is lower than 69 and gives Yes if T and No if F

getGrade = function(x) {
  if (x >= 90) {
    grade = 'A'
  } else if (x >= 80) {
    grade = 'B'
  } else if (x >= 70) {
    grade = 'C'
  } else {
    grade = 'F'
  }
  return (grade)
}

sapply(univ, function(x) {
  grade = c()
  for (i in 1:length(x)) {
    grade[i] = getGrade(x[i])
  }
  return(grade)
})
# example of using a user made function in sapply
### there must be a for loop inside the function since getGrade function takes a single value instead of a vector
### Thus, we first divide the dataset using sapply, then have each vector go through a for loop that finds the letter grade for each score, store it as a vector and return it at the end

# data import & export
getwd() # prints the default directory
setwd(dir = 'C/R_Data/Nano Degree/data') # absolute directory
setwd(dir = './data') # relative directory
# for relative directory, ./ is the current directory and ../ is the directory before the current one
### while relative directory can be used, using absolute directory is usually recommended, ESPECIALLY IN ANY AUTOMATING CODE, since the working directory might change in the middle, creating error

install.packages('writexl') # required for saving as excel file

writexl::write_xlsx(x = iris, path = 'test.xlsx') # size is large
write.csv(iris, 'test.csv') # csv - comma separated values
write.table(iris, 'test.txt')
saveRDS(iris, 'test.RDS') # for a single object
save(list = c('iris'), file = 'test.RDA') # for multiple objects
# R files keep the characteristics of the objects
### if multiple objects is needed to be saved using sa

install.packages("readxl")

obj = readxl::read_xlsx(path = 'test.xlsx') # last column is in chr type instead of factor
obj = read.csv('test.csv') # extra row is created (row names)
obj = read.table('test.txt') # last column in chr
# difference between csv and txt: csv files always have column names and used , as separator, where as txt files used to read column names as data and uses ' ' as separator
obj = readRDS('test.RDS') 
load('test.RDA') # cannot assign to object since it is the same as opening a zip file with multiple objects
### R files are the best if the receiver also uses R because it is smaller in size and keeps all the data types (factor is kept instead of converting to char)

# Encoding
install.packages('readr')
readr::guess_encoding(file = 'https://bit.ly/apt_price_2019_csv')
# encoding on left, confidence on right
### encode with the encoding that had the highest confidence

readr::guess_encoding(file = 'https://www.naver.com')
readr::guess_encoding(file = 'https://www.daum.net')
readr::guess_encoding(file = 'https://www.president.go.kr')
readr::guess_encoding(file = 'https://www.assembly.go.kr')
readr::guess_encoding(file = 'https://finance.naver.com')
# all of the above have UTF-8 with confidence of 1, but finance.naver.com has EUC-KR

apt = read.csv(file = 'https://bit.ly/apt_price_2019_csv', fileEncoding = 'UTF-8')
# fileEncoding must be done, especially for Windows users, because a lot of the files are encoded using UTF-8

write.csv(apt, 'Apt_Price_2019.csv', fileEncoding = 'UTF-8')
# we have to specify that the file is originally encoded with UTF

install.packages('data.table')
library(data.table)

fread(file = 'huge.csv', stringsAsFactors = F, data.table = F)
# stringsAsFactors = F does not convert each column with char type to factor, and data.table = F reads the file as a data frame instead of a data table
system.time(expr = huge <- read.csv('huge.csv'))
system.time(expr = huge <- fread('huge.csv'))
# time comparison for reading a big file with read.csv and fread

option('max.print')
option('max.print' = 100)
iris
# changes the settings where maximum values printed becomes 100 instead of default 1000

# dplyr
library(dplyr)
iris %>%
  select(-Sepal.Length, -Petal.Length) %>%
  slice(1:10)
  group_by (Species) %>%
  summarise(avg = mean(Sepal.Width))

list.files(pattern = '2019_KBO') 
# this function lists all files in wd, pattern can specify files that has pattern as a part of the name

stat = readRDS(file = '2019_KBO_win.RDS')
class(stat)
str(stat)
dim(stat)
nrow(stat)
ncol(stat)

print(stat)
head(stat, n = 5) # n = number of first rows to print
tail(stat, n = 5) # n = number of last rows to print
View(stat)

rownames(stat)
colnames(stat)
rownames(stat) = NULL # resets all row names to null

imsi = stat[-c(1:5), ] # makes the row numbers start from 6 instead of 1
rownames(imsi) = NULL
# if a new data frame is made from original, rownames = NULL must be called to reset the rownames of the new object

colnames(stat)[1] = '이름' # changing name of column

summary(stat)
# gives different result for each type
### gives number of NAs as well if exists
### for factor type, gives count of 6 factor levels in desc order

table(stat$팀명) # frequency
prop.table(table(stat$팀명)) # percentage
round(prop.table(table(stat$팀명)), 3)

# %>% shift ctrl m
install.packages('tidyverse')
library(tidyverse)
stat$팀명 %>% 
  table() %>% 
  prop.table() %>% 
  round(digits = 4L) * 100
# <- Alt -
### pipe operators are used to write code like a flow of thought
### variables can come first, then functions can come after with any constraints required except for the data itself