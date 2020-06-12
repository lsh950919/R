# data in a vector must be of same type
a = c(1, 2)
class(a) # numeric/double

b = c(1L, 2L)
class(b) # integer - must be used for functions whose input is required to be integers

sum(a)
sum(b)

c = c('hello', 'world')
class(c)

d = c(T, F)
class(d)
sum(d) # gives the number of T in vector
sum(c(F, T, T, T, F, F, T, F)) # = 4

as.integer(d) # as.type changes the type of vector to specified type

e = as.factor(c) # removes repeats, order in ascending order, and give them levels
class(e)
e # no apostrophes since it is not a string
c

as.integer(e) # gives numbers of their levels, but removes the text connected to the levels
### factors can be used for data that has multiple repeats

seq(3, 100, 3) # multiple of 3 from 3 to 100

letters[c(1,3,5)] # extracting multiple values from a list
letters[seq(1, 26, 2)] # giving a number range to extract - fancy index

loc = seq(3, 26, 3)
letters[loc] = LETTERS[loc] # changes the values in letters
letters

# a book from 16-351 pages for 28 days
seq(15, 351, length.out = 29) # because we want to count 28 times, length.out must be 29 (28 markers)

# 2018km run for 7500 people
seq(0, 2018, length.out = 7501)

vec = c('한국', '일본', '중국', '미국', '중국', '한국', '미국', '한국', '일본')
fct1 = factor(vec) # convert to factor
fct1
as.integer(fct1) # convert factor to integer (give level numbers)
fct2 = factor(vec, levels = c('한국', '미국', '중국', '일본')) # this specifies which order the levels should go by
fct2
as.integer(fct2) # this gives 1, 2, 3, 4, corresponding to 한국 미국 중국 일본
fct3 = factor(vec,
              levels = c('한국', '미국', '중국', '일본'),
              labels = c('대한민국', '미합중국', '중화민국', '일본나라')
              ) # changes the label names to specified strings
fct3
fct1 = as.factor(vec) # as.factor can also be used to convert to factor

vec[9] = '대만'
vec
fct1[9] = '대만'
fct1 # changes to NA because '대만' is not a part of one of the levels

fct4 = as.character(fct1) # convert to vector
fct4
fct4[9] = '대만' # change item 9 to 대만
fct4
as.factor(fct4)
fct4 # change factor to strings, change to '대만', and change back to factor, which will add the new level 대만 according to data

### OR, add a new level to factor
levels(fct1) = c('한국', '미국', '중국', '일본', '대만')
fct1
fct1[9] = '대만'
fct1

# Coercion
f = c(d, e)
f
class(f) # converts type to integer since d and e are not the same type

f= c(f, 3)
f
class(f) # since 3 is included, all type converts to numeric

f= c(f, '4')
f
class(f) # since '4' is included ,all type converts to character

as.integer(f)
as.numeric(f)
f # f is not changed yet because we did not assign the change

# indexing vectors
letters[1]

a = letters[1:5]
a
a[c(1, 3, 5)]
a[c(T, F, T, F, T)] # prints values that correspond to TRUE
# used more often since we can use constraints
### this is used more often because we can include constraints to slice by
#example
iris[iris$Sepal.Length >= 6, ] # comma included because the data is 2D

# a[] refers a as object, a() refers a as function

a[-1] # subtract first item
a[-c(1,2)] # subtract item 1 and 2, shows result, no changes in its value
b = a[-c(1,2)] # shows no result, change in value

a[1]
a[1] = 'A' # made change in value
a
a[2] = 'B'
a

# Numerical Operators
# objects must contain numbers and must be of same length for operators to work
# %% & %/% = remainder and dividend
a = c(0, 2, 4)
b = c(1, 2, 3)
a + b
a - b
a * b
a / b
a %% b # remainder
a %/% b # dividend
a ^ b

# different length vectors
c = seq(1, 11, 2)
d = seq(3, 12, 4)
a
c
a + c # shorter vector repeats itself after reaching end

# comparison operators - compares each item in each vector and returns a boolean
a
b
a > b
a >= b
a < b
a <= b
a == b
a != b

# logical operators
a
b
a & b # AND operator, 0 is FALSE, rest of the numbers is TRUE
a | b # OR operator
!a # NOT a
!b # NOT b

# Matrix
# matrix(data = , nrow = , ncol = , byrow = T/F, dimname = row names, col names)
# either nrow or ncol can be omitted as long as one is given since the total number of data in matrix is already given by data
A = matrix(1:12, 3) # matrix name is usually in capital, fills out starting from column first (1st column - 1 2 3)
A
class(A)

B = matrix(1:12, 3, byrow = T) # fills out row first
B

C = matrix(1:12, 3, 4, dimnames = 
             list(letters[1:3], LETTERS[4:7])) # adds row and column names to the matrix with letters
C           

# Matrix slicing
A[1, ] # first row, all columns
A[1:2, ] # 1st & 2nd row, all columns
A[, 1] # first col, all rows
A[, 1:2]
A[1, 1]
A[2, 3]
A[1:2, 1:2] # 2x2 matrix

A[-1, ] # same concept of subtraction: all rows other than 1, all columns
A[-c(1,2),] # rows other than 1st & 2nd, all columns
A[, -1]
A[, -c(1, 2)]
A[-1, -1]

# Matrix index assignment
A
A[1, ] = 95:98 # change first row to 95-98
A
A[, 1] = 31:33 # change first column to 31-33
A
A[1, 1] = 55
A
A[1, 1] = 55.5
A # type only follows column, so first column is converted to numeric
A[1, 1] = '55.5' # since this is a string, all values in matrix are converted to string
A
A = as.numeric(A) # turns the values back to numeric, but the result is a vector
A = matrix(data = A, nrow = 3) # converts the transformed vector into matrix
A

# Extra: string slicing
a = c('hello', 'world')
library(tidyverse)
str_sub(string = a, start = 1, end = 3)

# Lists - storage of all data types
# MUST know well since crawling returns lists ***

lst = list(a = 'a', b = 'b', c = 'c') # = gives name to the values we put into the list
lst
unlist(lst) # can only be used when all items in list are vectors
### used with a function that takes vector inputs and returns list of inputs

num = 1:5
char = LETTERS[6:10]
logi = rep(c(T, F), each = 3)
lst1 = list(a = num, b = char, c = logi)
str(lst1) # structure, shows what is inside the list
### it is VERY IMPORTANT to check for str once a list or a data frame is created in order to check if the structure is correct

lst2 = list(num, char, logi, lst1)
str(lst2) # since we did not input names, $ shows up in place of names
class(lst2)

lst1[[1]] # shows 1st item in lst1
###can only input 1 index in [[]]
lst1$a # indexing by its name
lst2[[1]]
lst2$a # gives null because there are no names assigned

lst2[2] # if only one [] is used, it ALWAYS prints the result out as a list
### some benefits might be that we can slice the result
lst2[[4]] # gives the list in itself
lst2[[4]]$b[2:4] #slicing the list inside the list
lst2[[4]][[2]][2:4] # this gives the same result as above
lst2[[4]]$[a,c] ########## be sure to remember to ask the question

# Data Frames
### lengths of all vectors must be equal. if not equal, gives a list instead

options('stringsAsFactors') # used to be TRUE, now FALSE
### what this means is that columns used to become factor type automatically before, but with updated version 4.0.0, data stays as vectors unless we input stringsAsFactors = T

df = data.frame(num, char, logi) # error because lengths are different: 5 for num and char but 6 for logi

num = 1:6
char = letters[1:6] # change two objects to become length 6
df1 = data.frame(num, char, logi)
str(df1) ### ALWAYS CHECK FOR STRUCTURE WHEN CREATED

df2 = data.frame(num, char, logi, stringsAsFactors = TRUE)
### since we input stringsAsFactors = T, the columns that contain character type now becomes factor type
str(df2) # now the second item becomes a factor type
### this is shown by $ char: Factor w/ 6 levels

View(df1) # shows df1 as a table in a separate screen, can also be shown by clicking on the sheet icon in environment

df2 # class: df
df2[1, ] # class: df
df2[1:2, ] # class: df
df2[, 1] # class: vector
df2[, c(1, 3)] # class: df
df2[, -c(1, 3)] # class: vector because only column 2 is presented
### because columns consist of vectors, if we slice df to one column, the result is a vector and not a df

df2[, 1] # vector
df2[, 'num'] # vector
df2[, c('num', 'char')] # df because two columns
df2$num # vector
df2['num'] # this is possible, but the result is a df
df2[['num']] # vector
# all possible ways of indexing a df

df2[-1, ] # same concept: subtract the first row (first item in each column)
df2[, -1] # erase the first row
df3 = df2[-1, -1] # all the processes do not change df2
df2
df3

df2$char = as.character(df2$char) # because we put stringsAsFactors = T, it used to be factor type, and we convert it back to character type and assign it back to the df
df2$char = LETTERS[1:6] # changing the values is now possible since it is not in factor type anymore
df2$char
df2$char[1:3] <- c('가', '나', '다')
df2$char