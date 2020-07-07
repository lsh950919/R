install.packages('tidyverse')
library(tidyverse)
library(readxl)

getwd()
list.files()
list.files(pattern = 'xlsx')

####### select a block and press ctrl + shift + c to make the block a comment
# setwd(dir = 'C:/R_Data/Nano Degree/')

stat = read_xlsx('./data/2019_KBO_Win.xlsx')

iris %>% 
  select(Sepal.Length, Petal.Length, Species)  %>% 
  filter(Species %in% c('setosa', 'versicolor')) %>%
  #slice(n = 1:50) %>% 
  group_by(Species) %>% 
  summarise(Count = n()) %>% 
  arrange(desc(Count))
# select chooses which columns to print, filter specifies any conditions to filter under, slice controls how many rows to print, group by groups the results into specific items, summarise gives a statistical result of the items printed, and arrange prints out the result in specific order

stat %>%  select(팀명, 선수명, 경기)
# no need to put the column names into a string or a vector

stat %>%  select(팀명, 선수명, 경기) -> imsi
# opposite direction of assignment is also possible using pipe

stat %>%  select(1:3)
stat %>%  select(2, 1, 3)
# column numbers can be used for select, and we can also choose in which order the columns should be printed by

stat %>% slice(1:10)
stat %>% head(10)
stat %>% slice(11:20)
stat %>% slice(seq(1, 300, 3))
stat %>% slice(팀명 = 'SK')
# slice/head can specify number of results to print (by row number), but slice is used more often because it can start from the middle while head must start from the top down
### if we specify a condition instead of row numbers, it will give an error because conditions must go under filter instead of slice

stat %>% distinct(팀명) # prints only the target column
stat %>% distinct(팀명, .keep_all = T)
# distinct prints only the unique values of a specific column

stat %>% filter(팀명 == 'SK')
# must use dplyr::filter() in case there is another library that is called with filter function (ex. stats) or detach the other package with detach('package:stats')
stat %>% filter(팀명 == 'SK' & 경기 >= 100)
stat %>% filter(홈런 >= 20 & 도루 >= 20)
stat %>% filter(홈런 >= 20 | 도루 >= 20)
# multiple conditions can be used using & (and) and | (or)

stat %>% filter(between(x = 타율, left = .330, right = .350))
# or
stat %>% filter(타율 >= .330 & 타율 <= .350)
stat %>% filter(between(x = 홈런, left = 20, right = 50))
# between can be used inside the filter, but both methods can be used depending on preferences

stat = stat %>% rename(이름 = 선수명) # 변경후 = 변경전
# we can rename columns inside the dataframe, but the changed name comes first then the target comes after

stat %>% 
  rename(경기횟수 = 경기, 타석횟수 = 타석, 안타횟수 = 안타) %>% 
  select(이름, 경기횟수, 타석횟수, 안타횟수)
# we can change column names of multiple columns

stat %>% arrange(경기)
stat %>% arrange(경기, 타석)
stat %>% arrange(desc(경기), 타석)
stat %>% arrange(desc(경기), desc(타석))
stat %>% arrange(desc(홈런), 삼진)
# arranging by multiple columns first orders the result by the first column, then out of the same values in the first column, the second column is ordered
### desc is used to print out the result in descending order

stat %>% 
  group_by(팀명) %>% summarize(선수 = n()) %>% arrange(desc(선수))
# n() - count
# when a group is made, summarise must be used in order to print any statistical values regarding each group. Grouping by itself does not change the printed result - prints all values

stat %>% 
  group_by(팀명) %>% summarize(팀홈런 = sum(홈런)) %>% arrange(desc(팀홈런))
stat %>% 
  group_by(팀명) %>% summarize(최다홈런 = max(홈런)) %>% 
  arrange(desc(최다홈런))
stat %>% 
  group_by(이름, 팀명) %>% summarize(최다삼진 = max(삼진)) %>% 
  arrange(desc(최다삼진))
# we can assign new names to the statistical results in summarize and even order by the statistical result

stat %>% select(팀명, 이름, 삼진) %>% arrange(desc(삼진)) %>% distinct(팀명, .keep_all = T)
# this is the same as above, but this way is correct because grouping by two columns like above prints all results instead of the unique results - it is just that it is printed in the correct order due to arrange

stat %>% filter(팀명 == 'LG' & 삼진 == 113) %>% select(이름)
# using data from the condition to look into the table

# Ungroup
imsi = stat %>%  group_by(팀명)

stat %>% summarize(선수 = n())
imsi %>% summarize(선수 = n())
# while the result is the same this time, this will depend on the data because imsi is grouped before giving the count
imsi %>% ungroup() %>% summarize(선수 = n())
# use ungroup in order to remove the grouping, then calculate for the statistical value

# mutate - 파생변수 (만드려면 도메인지식이 많이 필요함)
stat %>% select(이름, 출루율, 장타율) %>% 
  mutate(OPS = 출루율 + 장타율)
# creates new column names OPS
stat %>% filter(타수 >= 100) %>% 
  mutate(볼삼비 = round(볼넷/삼진, 3)) %>% 
  select(이름, 볼넷, 삼진, 볼삼비) %>% arrange(desc(볼삼비))
# filter를 넣지 않았을떄, 삼진이 0인 사람이 나와 볼삼비가 inf 나옴
### mutate creates a completely new column out of the data inside the table, which we can assign name using (name) = (manipulation). after creating the column it can be used in select, arrange, etc. that takes the column name as its input

stat %>% mutate(타석차이 = 타석 - 타수) %>% arrange(desc(타석차이)) %>% select(이름, 타석, 타수, 타석차이, 볼넷)

# select 먼저
stat %>% select(팀명, 이름, 안타, 홈런) %>% 
  filter(안타 >= 100) %>% 
  mutate(홈런비중 = round(홈런/안타, 3)) %>% 
  arrange(desc(홈런비중))

# mutate 먼저
stat %>% mutate(홈런비중 = round(홈런/안타, 3)) %>% 
  filter(안타 >= 100) %>% 
  select(팀명, 이름, 안타, 홈런)

### if mutate is performed after select, the result will include the column created by mutate. However, if select is performed after mutate without including the new column name, the result will only include the columns in select, and will not be able to be ordered by the new column without including it in the select command

stat %>% select(팀명, 이름, 타석) %>% 
  mutate(규정타석 = if_else(condition = 타석 >= 144*3.1,
                        true = '이상', false = '미만')) %>% 
  group_by(팀명, 규정타석) %>%  summarise(구분 = n())
# if_else is the same as ifelse except for the variable names

stat %>% select(이름, 홈런) %>% 
  mutate(case_when(홈런 >= 20 ~ '거포',
                     홈런 >= 10 ~ '주전',
                     홈런 = T ~ '똑딱이'))
# 홈런 = T simply refers to all others that has value
### case_when is the same as case when in SQL except that the value to print is connected to the condition by ~ instead of then

stat %>% group_by(팀명) %>% 
  summarise(인원 = n(), 팀홈런 = sum(홈런)) %>% 
  mutate(평균홈런 = round(팀홈런/인원, 2)) %>% 
  arrange(desc(평균홈런))

stat %>% group_by(팀명) %>% 
  summarise(팀타수 = sum(타수), 팀안타 = sum(안타)) %>% 
  mutate(팀타율 = round(팀안타/팀타수, 3)) %>% 
  arrange(desc(팀타율))

stat %>% group_by(팀명) %>% 
  summarise(팀볼넷 = sum(볼넷), 팀삼진 = sum(삼진)) %>% 
  mutate(볼삼비 = round(팀볼넷/팀삼진, 3)) %>% 
  arrange(desc(볼삼비))

# Join

# create dataframes to test join on
employ = data.frame(
  이름 = c('김하나', '이하늬', '박찬우', '최진상'),
  나이 = c(24, 35, 28, 45),
  직급 = c('주임', '과장', '대리', '부장'))
office = data.frame(
  이름 = c('김하나', '이하늬', '최진상', '강민희'),
  내선 = c('0101', '2233', '9999', '5678'),
  부서 = c('인사', '총무', '전략', '영업'))
detail = data.frame(
  직원명 = c('김하나', '박찬우', '최진상', '강민희'),
  나이 = c(24, 31, 45, 34),
  혈액형 = c('A', 'B', 'O', 'AB'),
  동아리 = c('독서', '등산', '와인', '재테크'))
# check for the differences: office df has 강민희 instead of 박찬우, and detail has 박찬우 with age 31 instead of 이하늬 and 박찬우 with age 28

inner_join(employ, office, by = '이름')
# prints only the values that match between the two tables

full_join(employ, office, by = '이름')
# prints all values that does not match

left_join(employ, office, by = '이름')
# only prints values in left df that does not match in right df

right_join(employ, office, by = '이름')
# only prints values in right df that does not match in left df

left_join(employ, detail, by = c('이름' = '직원명'))
# c(name1 = name2) is used when we know that the two columns to join df by has different column names
### 직원명 does not show, but since both df have 나이, x and y are placed and two columns are created

left_join(employ, detail, by = c('이름' = '직원명', '나이'))
# no values are attached to 박찬우 since 나이 in the two tables are different
# we added 나이 as well since the name of column is in both dfs

# practice
teamInfo = read.csv('./data/KBO Team Info(EUC-KR).csv', fileEncoding = 'EUC-KR', stringsAsFactors = F)
imsi = left_join(stat, teamInfo, by = '팀명')
table(imsi$야구단명, useNA = 'ifany')
# the table shows that there are values with NA when it shouldn't, signifying that some names in the two tables do not match

teamInfo$팀명[teamInfo$팀명 == 'kt'] = 'KT'
stat$팀명[stat$팀명 == 'Hero'] = '키움'
# changing the names in the two tables to equal each other will remove all NA values in the joined df

table(imsi$야구단명, useNA = 'ifany')

readr::guess_encoding('./data/KBO Team Info(EUC-KR).csv')
# guess_encoding is used when we are not sure which encoding method is used for the file
### use for text files only, not necessary for excel files
### readr is included in tidyverse

