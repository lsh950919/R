sen = 'Hello World!'
print(x = sen)
class(sen)

length(sen) ### gives length of the vector/object
nchar(sen) ### gives the number of characters in vector/object
length(df1)
nchar(df1)
names = c('Adam', 'Ben', 'Charlie')

a = 1; print(a)
b = 2; print(b)
a = b; print(a)
b = 3
print(a); print(b)

1a = 3
`1a` = 3
print(`1a`) # if you want object name to start with number, use ``

c(TRUE, FALSE)
c('TRUE', 'FALSE')
c(T, F) # can be expressed as a single letter
c(1L, 2L, 3L) ### integer - 
c(1, 2, 3) # float
c('a', 'b', 'c', 'd', 'e')
c('가', '다', '나', '라', '하') # order is kept

a = c('가', '다', '나', '라', '하')
b = c('a', 'b', 'c', 'd', 'e')
c = c(a, b) # a and b  are combined into one vector

seq(1, 3, 1)
seq(from = 1, to = 3, by = 1) # different way of writing
seq(3, 1, -1)
1:3 # different from Python: it goes from 1 to 3 instead of 1 to 2 (start and end inclusive)
3:1
1:10000
10000:1
sum(1:10000)

seq(1, 10, 2.5) # different from Python: in Python range cannot include sep by float, but R can
seq(1, 10, length.out = 19) ### length.out gives the number of items the range should have
seq(80, 60, length.out = 365)

rep(1:3, times = 5) # repeats the whole vector 5 times
rep(1:3, each = 5) # repeats first item in vector 5 times, then second item 5 times, and so on
rep_len(1:3, length.out = 9)
rep_len(1:3, length.out = 10) # not frequently used, but length.out can also be used for repetitions, can be used when the last value is needed to end in the middle of the item

letters # all lowercase alphabets
LETTERS # all uppercase alphabets
class(letters) # char
length(letters) ### 26
nchar(letters) ### prints 1 26 times



terms = c('I', 'am', 'a', 'girl')
class(terms)
length(terms) # 4 since there are 4 items in the vector
nchar(terms) # 1 2 1 4 according to the length of each string

paste('I', 'am', 'a', 'girl', sep = ' ') # prints I am a girl
paste(terms, sep = ' ') # this is not done like the above since it only contains a vector and not multiple objects
paste(terms, terms, sep = ' ') # gives weird answer: II amam aa girlgirl
paste(terms, collapse = ' ') ### collapse is used for vectors

grep('a', terms) ### gives index number of objects inside vector that includes the item
grepl('a', terms) # gives boolean for each object in vector
grep('a', terms, value = T) ### gives all objects inside vector that includes the item

gsub('a', 'b', terms) ### replaces first with second for all in vector and gives the full vector


