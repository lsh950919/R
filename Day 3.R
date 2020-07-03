if (class(1L) == 'integer') {
  print('정수입니다!')
} # if pointer is inside the brackets, the code inside will always execute. To run the if statement the pointer must be outside the brackets

if (class(2) == 'integer') {
  print('정수입니다!')
} else {
  print('정수가 아닙니다!')
} # else statement
integer
a = 4.2
if (class(a) == 'integer') {
  print('정수입니다!')
} else if (class(a) == 'numeric') {
  print('실수입니다!')
} else {
  print('숫자가 아닙니다!')
} # else if statement

major = readline('전공을 입력하세요: ')
if (grepl('통계', major)) {
  print('R을 공부하세요!')
} else if (grepl('컴퓨터', major)) {
  print('Python을 공부하세요!')
} else {
  print('하고 싶은 언어를 공부하세요!')
} # readline - same as input in Python

score = 92
if (score >= 80) {
  result = '합격'
} else if (score >= 60) {
  result = '재시험'
} else {
  result = '불합격'
}
print(result)

set.seed(1234)
# setting the seed specifies the set of random numbers created with a specific key
lotto = sample(45, 6, F)
print(lotto)

lotto = sample(45, 60000, T) # must be T if # of random numbers are more than the possibilities
print(lotto)
tbl = table(lotto) # organizes the results into a table with value and its frequency
max(tbl) # maximum frequency
tbl == max(tbl) # gives a table that has T if yes and F if no
which(tbl == max(tbl)) # specifies what value corresponds to the comparison
sort(tbl, T) # sort table by descending order (desc = T)
sort(tbl, T)[1:6] # pull out the most frequent 6 numbers
# PROCESS: get 60000 random numbers from 1 to 45, make into table, 1. find which value has most frequency using which(tbl == max(tbl) 2. sort out result by most frequency using sort and print top 6 by indexing

n = nrow(iris)
set.seed(1234)
index = sample(n, n * .7, F)
### to see the default values, go to help -> and type in the function

trainSet = iris[index, ] # values that are in index
testSet = iris[-index, ] # values that are not in index

number = sample(10:99, 1)
guess = readline('두 자리 숫자를 입력하세요: ')
if (number == guess) {
  print('맞췄습니다!')
} else {
  print('틀렸습니다!')
}

ifelse(1:10 %% 2 == 1, '홀수', '짝수') # 파생변수 - making new data out of another data

df2 = data.frame(num = 1:6, char = letters[1:6])
df2

df2$gb = ifelse(df2$num %% 2 == 1, '홀수', '짝수')
df2
# ifelse(expr, b, c) - if expression is true, return b, else return c

set.seed(1234)
univ = data.frame(math = sample(40:99, 20, T))
univ$result = ifelse(univ$math <= 59, 'Fail', 'Pass')
table(univ$result)
# make a df with 20 random numbers between 40 and 99

set.seed(1234)
a = sample(15:65, 100, T)
cust = data.frame(age = a)
cust$gb = ifelse(cust$age <= 19, 
                 '1. 미성년', 
                 ifelse(cust$age <= 49, 
                        '2. 근로자',  
                        '3. 은퇴자'))
# if multiple ifelse is needed, put another ifelse function in place of return value for False
### adding numbers in front of the result name organizes them in order - 1. 미성년
table(cust$gb)
table(cust)

# For loop
for (i in 1:10) {
  sqr = i^2
  print(sqr)
}

for (i in 1:10) {
  if (i %% 2 == 1) next
  print(i)
} # 2 4 6 8 10
### putting next makes the loop skip to the next value

for (i in 1:10) {
  if (i %% 2 == 1) {
    print('홀수입니다')
    next
  }
  print(i)
}
### putting the brackets after if statement, some command, and next makes the code execute the command then skip to the next value

menu = c('짜장면', '탕수육', '짬뽕', '샥스핀', '전가복', '깐풍기')
for (i in menu) {
  cat('\n', i, '시킬까요?')
  if (!i %in% c('짜장면', '짬뽕')) {
    cat(' --> 그걸로 되겠어요?')
    next
  }
  cat(' --> 요리부터 주문합시다!')
}
# cat - concatenation function: combines all text in function, and prints out the result

# Error Prevention
for (i in 1:10) {
  sqr = i^2
  print(sqr)
  sqrs = c(sqrs,sqr)
}
# this creates error AND stops the loop because sqrs is not defined beforehand

for (i in 1:10) {
  sqr = i^2
  print(sqr)
  tryCatch({
    sqrs = c(sqrs,sqr)
  }, error = function(e) cat('에러가 발생했습니다\n'))
}
### IMPORTANT: used for crawling - gives a statement when there is error and goes onto the next website instead of ending the loop as a whole
### function(e) - e is the error message created, function(e) receives the error message and prints out the next text. If error message needs to be seen, print(e) can be used

# While loop
i = 10
while (i) {
  print(i)
  i = i - 1
}
# since 0 corresponds to False, the loop stops at i = 0

i = 1
while (i) {
  print(i)
  i = i + 1
} # click the interrupt button to end the infinite loop

j = 1
while (j) {
  if (j > 5) break
  print(j)
  j = j + 1
} # break is the same break used in Python

card = 30000
while (card) {
  if (card <= 10000) break
  cat('아메리카노 한 잔 드립니다!')
  card = card - 4100
  cat('현재 잔액은', card, '입니다.\n')
}

card = 30000
while (card) {
  if (card <= 10000) {
    charge = readline('충전 하시겠습니까? [예/아니오] ')
    if (charge == '예') {
      card = card + 10000
    } else {
      print('안녕히 가세요')
      break
    }
  } else {
    cat('아메리카노 한 잔 드립니다!')
    card = card - 4100
    cat('현재 잔액은', card, '입니다.\n')
  }
}

# Functions
Pythagoras = function(a,b) {
  c = sqrt(a^2 + b^2)
  return(c)
} # always must return the result in order for the function to contain any value when called
print(Pythagoras(3,4))
### However, since return can only be called once in a function, if there are multiple values that need to be returned, put them in a list and return the list as a whole

getVecLen = function(vec) {
  veclen = sqrt(sum(vec^2))
  return (veclen)
}
getVecLen(1:5)
# function for getting length of a vector (sqrt of sum of all #^2)

guessHeight = function(name, height = 173) {
  answer = paste(name,'님의 키는', height, 
                 'cm 입니다.', sep = ' ')
  return (answer)
}
### fixing a variable in the input gives the specified default value when it is not specified
guessHeight(name = 'Alan', height = 175)
guessHeight('Alan')
guessHeight('Alan', 185)

guessNumber = function() {
  number = sample(10:99, 1)
  print(number)
  while (number) {
    guess = readline('두 자리 숫자를 넣어주세요: ')
    if (number == guess) {
      print('정답입니다!')
      break
    } else if (number > guess) {
      print('더 높은 숫자를 넣어주세요')
    } else if (number < guess) {
      print('더 낮은 숫자를 넣어주세요')
    }
  }
}

guessNumber()

# setwd에서 절대경로를 넣지 않고 상대 경로를 넣을수도 있음
# ./code means all the same except for /code, '..' means the previous directory

rm(list = ls()) # erase all objects in environment
