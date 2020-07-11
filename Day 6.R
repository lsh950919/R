library(tidyverse)
library(readxl)
getwd()
setwd('C:/R_Data/Nano Degree/data')
list.files(pattern = 'KBO')
stat = read_xlsx('2019_KBO_Win.xlsx')
stat = stat %>% rename(이름 = 선수명)

# changing from long -> wide data and wide -> long data
### wide data has the names of values in columns, whereas long data has the names of values in rows
stat %>% slice(1:10) %>% 
  select(이름, 경기, 타석, 타수, 안타, 홈런) %>% 
  gather('구분', '스탯', -이름, na.rm = T) %>% 
  arrange(이름, 구분) -> longDf
# originally wide since 이름, 경기, etc. are in columns, and we convert to long data using gather
# -이름 signifies that this will be the dividing name that contains the repeats of the names of values

longDf = longDf[-1,] 
# erase one row in long data (1 cell in wide data type) to see how NA is inserted during conversion from long to wide

wideDf = longDf %>% 
  spread('구분', '스탯', NA)
# spread is used to convert from long type to wide type

# Practice
longDf = stat %>% 
  slice(11:20) %>% 
  select(이름, 타율, 출루율, 장타율, OPS) %>% 
  gather('스탯', '점수', -이름, na.rm = T) %>% 
  arrange(이름, 스탯)
wideDf = longDf %>% 
  spread('스탯', '점수', fill = NA)

# purrr
set.seed(1234)
nums = sample(1:10, 100, T)
locs = sample(1:100, 10, F)
nums[locs] = NA
mean(nums, na.rm = T) # even 1 NA in data gives NA
sum(nums, na.rm = T)
# because NA values give NA for all statistical summaries, na.rm = T tells R to remove all NA values while computing

# map that return lists
map(stat[,3:19], mean, na.rm = T)
stat %>% 
  select(3:19) %>% # select takes 3-19 rows from table
  map(mean, na.rm = T) # equivalent as above

lapply(stat[,3:19], mean, na.rm = T) # equivalent as above

map_if(stat[,3:19], is.numeric, mean, na.rm = T)
# the condition in map_if (is.numeric)checks for the type of the columns and performs on columns that give T

map_at(stat, 3:19, mean, na.rm = T)
# map_at is not much different from map: it only separates the table itself and the part we want to perform function on

# map that returns vector
map_lgl(stat, is.numeric) # returns vector with logical values
map_int(stat, is.numeric) # returns vector with int values
map_dbl(stat, is.numeric) # returns vector with float values
map_chr(stat, is.numeric) # returns vector with character values
map_chr(stat, class)
map_int(stat, class) # error
### depending on what type of value the function returns, we must use distinct functions (map_int for a function that returns character would give error)


map_df(stat[,3:19], mean, na.rm = T)
# returns results of repeated function in data frame

map_dbl(stat[,3:19], mean, na.rm = T)
map_int(stat[,3:19], mean, na.rm = T) # error because all values are floats and cannot be printed in integer form

# rarely used
map(stat[,3:19], mean, na.rm = T) %>% 
  map_dfc(.f = ~ .) # df by column - wide type
map(stat[,3:19], mean, na.rm = T) %>% 
  map_dfr(.f = ~ data.frame(평균 = .)) # df by row - long type

stat$팀명 = as.factor(stat$팀명)
stat$팀명
map_chr(stat, class)
# since 팀명 column is converted to factor, map(class) gives factor for that column instead of original character

stat[,3:12] = map_df(stat[,3:12], as.integer)
str(stat)
# columns 3-12 were originally in numeric form, but we convert the columns to integer type using map, returning the result as a data frame using map_df, and then replace the result to the original table

# stringr - str_c (combine), str_split (split), str_detect (search), 
str_c(stat$팀명, stat$이름) # combines each corresponding values
str_c(stat$팀명, stat$이름, sep = '-') # combines with - inbetween
str_c(stat$이름, collapse = ' ') # same as paste: given a single vector and collapse, returns a single item vector with all values in table attached with collapse
### different from paste in that it can take other types than single strings (ex. data frame)

stat$선수 = str_c(stat$팀명, stat$이름, sep = ' ')
stat$선수
# create new column with team name and name combined

str_split(stat$선수, pattern = ' ') 
# returns a list with lists containing the split values
str_split(stat$선수, pattern = ' ', simplify = T) %>% 
  as.data.frame() ############## REMEMBER TO TEST as.data.frame
# we can convert the resulting list into a data frame using as.data.frame

# str_detect - searching for string and giving logical for all values
str_detect(stat$팀명, pattern = 'SK')
str_detect(stat$팀명, pattern = '와이번스')
str_detect(stat$이름, pattern = '^최') %>% sum()
str_detect(stat$이름, pattern = '^김') %>% sum()
str_detect(stat$이름, pattern = '^이') %>% sum()
str_detect(stat$이름, pattern = '^박') %>% sum()
# ^ start with
str_detect(stat$이름, pattern = '정$') %>% sum()
str_detect(stat$이름, pattern = '국$') %>% sum()
# $ end with

# str_sub - cutting out parts of string, similar to substr in SQL
str_sub(stat$이름, 1,1) %>% table() %>% sort(desc = T)

# str_remove/_all - removing specified part from string
sen = c('가나다', '나가라', '다나가', '마바사')
str_remove_all(sen, pattern = '가')
str_remove_all(sen, pattern = '나')
str_remove_all(sen, pattern = '[가나]')
str_remove_all(sen, pattern = '[가나다]')
str_remove_all(sen, pattern = '[가-다]') # equivalent as above
str_remove_all(sen, pattern = '[가-힣]') # 한글 다 지움
# '[]' is a part of regular expression: at the end of this lecture

str_remove(stat$이름, pattern = '[가-힣]') %>% 
  table() %>% sort(desc = T)
# since we only used str_remove, it removes any first appearing korean character in each value in the vector

sen = '오늘 오전 내용은 쉽고 오후 내용은 어렵습니다'
str_remove(sen, pattern = ' ')
str_remove_all(sen, pattern = ' ')
# str_remove only removes the first value, so if we want to remove all corresponding values inside the string, str_remove_all must be used

# str_replace - replaces specified string with another string
str_replace(stat$이름, '^양', '강')
str_replace(stat$이름, '^김', '곰')

str_replace(sen, pattern = ' ', '_')
str_replace_all(sen, pattern = ' ', '_')
### however, if we perform remove or replace on vectors, it processes the function on each item in the vector (ex. if name is '김김김', replace would make '곰김김' while replace_all would give '곰곰곰')

# str_extract - returns out values that correspond with specified string
str_extract(stat$이름, pattern = '[가-힣]') # since str_extract is used, it returns the first korean character in each value in vector
str_extract(sen, '내용') # only returns the first 내용
str_extract_all(sen, '내용')
# str_extract_all returns all the corresponding strings, but it returns the result as a list
str_extract_all(sen, '내용', simplify = T)
# simplify is used to return as a vector/matrix
str_extract_all(sen, '오전|오후', simplify = T)
str_extract_all(sen, '오[전후]', simplify = T)
str_extract_all(sen, '오.', simplify = T)
# above are examples of regular expressions at use

# str_count - gives number of occurances of specified string in the string
str_count(sen, '내용')
str_length(sen) # str_length is unnecessary since we have nchar
nchar(sen)

sen = '\n 오늘 오전 내용은 쉽고 오후 내용은 어렵습니다.\t'
cat(sen)
# str_trim - same as trim in SQL - removes all spaces at the ends
str_trim(sen)

# Practice
table(stat$팀명)
stat$팀명 = str_replace(stat$팀명, 'Hero', '키움')
stat$팀명 = as.factor(stat$팀명)

print(stat$이름)
'[가-힣]*' # 없는거부터 무제한까지
str_extract(sen, '[가-힣]')
str_extract(sen, '[가-힣 ]+') # 있는것부터 끝까지
str_extract(sen, '[가-힣 ]*')

# Practice - there are some unnecessary characters attached to the names of the players, and we want to remove those characters
stat$이름 = str_remove(stat$이름, '\\*$') # \\ - 문자 그대로, $ - 끝나는것
# removes * at the end of the name (\\* specifies that we are talking about * as a character itself)
stat$이름 = str_remove(stat$이름, '(타)') # only removes 타 because () are meta characters
stat$이름 = str_remove(stat$이름, '\\(\\)') # \\ must be added to each meta characters to tell R to search for the character itself
stat$이름 = str_remove(stat$이름, '\\(타\\)')
# two commands above combined

# duplicated - returns logical of whether its occurance is first or repeated
nums = c(1,2,3,1,3,4,2,4,5,6,3,5) 
duplicated(nums) # returns 9 logical values
duplicated(nums) %>% sum()
# sum gives total number of TRUE since TRUE = 1 and FALSE = 0
### application: 본문이 몇번이나 중복 되는가를 볼 수 있음

# removing duplicates
imsi = unique(stat) # removes duplicates by row
imsi = stat %>% filter(duplicated(stat) == F) # can go by column as well
imsi = stat %>% filter(duplicated(stat$팀명) == F)
# this tells R to give only the first occuring values, thus removing all the duplicates
####### useful

saveRDS(stat, '2019_KBO_Hitter_Stats.RDS')

# Regular Expressions ****** HARD AF ******
strs = c('abCD', '1234', '가나다라', 'ㅋㅎㅜㅠ', 
         '\r\n\t\\', '-_,./?')
nchar(strs)

str_extract_all(strs, '.', simplify = T) # 모든 글자 뽑아오기 (except for \r\n)
str_extract_all(strs, '\\w')
str_extract_all(strs, '\\d')
str_extract_all(strs, '\\s')
str_extract_all(strs, 'a|b')
str_extract_all(strs, '[ab]')
str_extract_all(strs, '[a-z]')
str_extract_all(strs, '[A-Z]')
str_extract_all(strs, '[0-9]')
str_extract_all(strs, '[ㄱ-ㅎ]')
str_extract_all(strs, '[ㅏ-ㅣ]') #ㅙ 등 포함
str_extract_all(strs, '[ㄱ-ㅣ]')
str_extract_all(strs, '[가-힣]')
str_extract_all(strs, '[^가-힣]')

nums = c('1', '23', '456', '7890')
str_extract(nums, '\\d+')
str_extract(nums, '\\d*')
str_extract(nums, '\\d{2}')
str_extract(nums, '\\d{3,4}')
str_extract(nums, '\\d{4,}')
# 4글자 이상

str = '<p>이것은<br>HTML<br>입니다</p>'
str_extract_all(str, '<.+>')
str_extract_all(str, '<.+?>')

str = '우리집 강아지는 (복슬강아지)입니다.'
str_extract(str, '(.+)')
# () is a meta character
str_extract(str, '\\(.+\\)')

strs = c('가나다', '나가다', '다나가')
str_extract(strs, '가')
str_extract(strs, '^가')
str_extract(strs, '가$')
