#   _____ _             _   _                        _ _   _       _____        _        
#  / ____| |           | | (_)                      (_| | | |     |  __ \      | |       
# | (___ | |_ __ _ _ __| |_ _ _ __   __ _  __      ___| |_| |__   | |  | | __ _| |_ __ _ 
#  \___ \| __/ _` | '__| __| | '_ \ / _` | \ \ /\ / | | __| '_ \  | |  | |/ _` | __/ _` |
#  ____) | || (_| | |  | |_| | | | | (_| |  \ V  V /| | |_| | | | | |__| | (_| | || (_| |
# |_____/ \__\__,_|_|   \__|_|_| |_|\__, |   \_/\_/ |_|\__|_| |_| |_____/ \__,_|\__\__,_|
#                                    __/ |                                               
#                                   |___/                                                
#
# Based on: https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html



# Lets download some data (make sure the data folder exists)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

# now we will read this "csv" into an R object called "surveys"
surveys <- read.csv("data_raw/portal_data_joined.csv")

# and take a look at it
surveys
head(surveys)
View(surveys)

# BTW, we assumed our data was comma separated, however this might not
# always be the case. So we may been to tell read.csv more about our file.



# So what kind of an R object is "surveys" ?
class(surveys)

# ok - so what are dataframes ?
str(surveys)
dim(surveys)
nrow(surveys)
ncol(surveys)
head(surveys,2)
tail(surveys)
names(surveys)
rownames(surveys)
summary(surveys)

# --------
# Exercise
# --------
#
# What is the class of the object surveys?
#
# Answer:
class(surveys)    #data.frame

# How many rows and how many columns are in this survey ?
#
# Answer:
nrow(surveys)     #34786
ncol(surveys)     #13

# What's the average weight of survey animals
#
#
# Answer:
summary(surveys)    #will be present in the R summary
mean(surveys$weight, na.rm = TRUE)    #alternate way of pulling the mean from the table


# Are there more Birds than Rodents ?
#
#
# Answer: No - again can look to summary
sum(surveys$taxa == "Rodent")     #alternate

# 
# Topic: Sub-setting
#

# first element in the first column of the data frame (as a vector)
surveys[1,1]

# first element in the 6th column (as a vector)
surveys[1,6]

# first column of the data frame (as a vector)
surveys[,6]

# first column of the data frame (as a data frame)
surveys[1]
head(surveys[1])
head(surveys[,1])

# first row (as a data frame)
surveys[1,]

# first three elements in the 7th column (as a vector)
surveys[1:3,7]

# the 3rd row of the data frame (as a data.frame)
surveys[3,]

# equivalent to head(surveys)
surveys[1:6,]

# looking at the 1:6 more closely
1:6
5:10
surveys[c(1,2,3,5,6),]     #can pull specific rows
surveys[,c(2,3)]           #or columns

# we also use other objects to specify the range
rows <- 6
surveys[1:rows,3]    #sames as surveys[1:6,3]

#
# Challenge: Using slicing, see if you can produce the same result as:
#
#   tail(surveys)
#
# i.e., print just last 6 rows of the surveys dataframe
#
# Solution:
nrow(surveys)
surveys[34781:34786,]
surveys[(nrow(surveys)-5):nrow(surveys),]   #alternate way if you don't want to count rows 

# We can omit (leave out) columns using '-'
surveys[-1]
surveys[c(-1,-2,-3)]
head(surveys[-(1:3)])

# column "names" can be used in place of the column numbers
head(surveys["month"])


#
# Topic: Factors (for categorical data)
#
gender <- c("male","male","female")           #storing a vector of characters
gender <- factor(c("male","male","female"))   #better way is to store as a vector of factors

class(gender)
levels(gender)
nlevels(gender)

# factors have an order
temperature <- factor(c("hot","cold","hot","warm"))
temperature[1]
levels(temperature)

# will be ordered alphabetically unless level order is pre-stated which you can do as described below

temperature <- factor (c("hot","cold","hot","warm"), level = c("cold","warm","hot"))
levels(temperature)

# Converting factors
as.numeric(temperature)
as.character(temperature)

# can be tricky if the levels are numbers
year <- factor ( c(1990, 1983, 1977, 1998, 1990))
year
as.numeric(year)
as.character(year)
as.numeric (as.character(year))    #converting it back into a useful format

# so does our survey data have any factors
str(surveys)

#
# Topic:  Dealing with Dates
#

# R has a whole library for dealing with dates ...
library(lubridate)

my_date <- ymd("2015-01-01")
class(my_date)

#date: 7-16-1977

# R can concatenated things together using paste()
paste("abc","123","xyz")

# 'sep' indicates the character to use to separate each component
paste("abc","123","xyz", sep = "+")
paste("2015", "01", "01", sep = "-")
my_date <- ymd(paste("2015", "01", "01", sep = "-"))
class(my_date)

# paste() also works for entire columns
surveys$year
paste(surveys$year, surveys$month, surveys$day, sep = "-")

# let's save the dates in a new column of our dataframe surveys$date 
surveys$date <- ymd( paste( surveys$year, surveys$month, surveys$day, sep = "-"))

# and ask summary() to summarise 
head(summary(surveys))

# but what about the "Warning: 129 failed to parse"
#some data cannot be converted to date - will still convert with this error

summary (surveys$date)     #can show you that there are 129 NAs - source of the error 

missing_date <- surveys[is.na(surveys$date), "date"]
missing_date

#shows you that some of the months have 31 days even though it is not possible for those months
#that is why they have been converted to NAs
missing_date <- surveys[is.na(surveys$date), c("year", "month", "day")]  
missing_date
