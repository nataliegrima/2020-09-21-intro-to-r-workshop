#####################
# MANIPULATING DATA #
#       using       #
#     TIDYVERSE     #
#####################
#
#
# Based on: https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Data is available from the following link (we should already have it)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

#---------------------
# Learning Objectives
#---------------------

#    Describe the purpose of the dplyr and tidyr packages.
#    Select certain columns in a data frame with the dplyr function select.
#    Select certain rows in a data frame according to filtering conditions with the dplyr function filter .
#    Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
#    Add new columns to a data frame that are functions of existing columns with mutate.
#    Use the split-apply-combine concept for data analysis.
#    Use summarize, group_by, and count to split a data frame into groups of observations, apply summary statistics for each group, and then combine the results.
#    Describe the concept of a wide and a long table format and for which purpose those formats are useful.
#    Describe what key-value pairs are.
#    Reshape a data frame from long to wide format and back with the pivit_wider and pivit_longer commands from the tidyr package.
#    Export a data frame to a .csv file.
#----------------------

#------------------
# Lets get started!
#------------------

# loadinging dplyr and tidyr
install.packages("tidyverse")
library(tidyverse)

# loading the dataset
surveys <- read_csv("data_raw/portal_data_joined.csv")

# check structure
str(surveys)


#-----------------------------------
# Selecting columns & filtering rows
#-----------------------------------
select(surveys, plot_id, species_id, weight)

select(surveys, -record_id, -species_id)

# Filter for a particular year 
surveys_1995 <- filter(surveys, year == 1995)

surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

surveys_sml <- select(filter(surveys, weight < 5), species_id, sex, weight)

#-------
# Pipes
#-------

# The pipe --> %>%
# Shortcut --. Ctrl + shift + m or command + shift + m

surveys %>%
  filter(weight<5) %>%
  select(species_id, sex, weight)

surveys_sml2 <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

View(surveys_sml2)

#-----------
# CHALLENGE
#-----------

# Using pipes, subset the ```surveys``` data to include animals collected before 1995 and 
# retain only the columns ```year```, ```sex```, and ```weight```.

surveys_1995 <- surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight)

View(surveys_1995)

# When dealing with larger datasets it will likely be quicker to perform select before filter
# Order of column titles in select function determines data frame order

#--------
# Mutate
#--------
# Handy if you want to convert one column to another without overwritting the original column
# e.g. conversion of lbs to kgs

surveys %>% 
  mutate(weight_kg = weight/1000)

#can generate multiple new columns in the one function 

surveys %>%
  mutate(weight_kg = weight/1000,
         weight_lb = weight_kg *2.2) %>% 
  head()

surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight / 1000) %>% 
  head(20)

#if you want to remove blanks could use: filer(weight !="")
#removing NA and blanks: filter(weight !="" | !is.na(weight))

#-----------
# CHALLENGE
#-----------

# Create a new data frame from the ```surveys``` data that meets the following criteria: 
# 1. contains only the ```species_id``` column and a new column called ```hindfoot_cm``` containing 
# the ```hindfoot_length``` values converted to centimeters. In this hindfoot_cm column, 
# there are no ```NA```s and all values are less than 3.

# Hint: think about how the commands should be ordered to produce this data frame!

hindfoot_subset <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  mutate(hindfoot_cm = hindfoot_length/10) %>% 
  select(species_id, hindfoot_cm) %>% 
  filter(hindfoot_cm < 3)

View(hindfoot_subset)

#---------------------
# Split-apply-combine
#---------------------






#-----------
# CHALLENGE
#-----------

# 1. How many animals were caught in each ```plot_type``` surveyed?

# 2. Use ```group_by()``` and ```summarize()``` to find the mean, min, and max hindfoot length 
#    for each species (using ```species_id```). Also add the number of observations 
#    (hint: see ```?n```).

# 3. What was the heaviest animal measured in each year? 
#    Return the columns ```year```, ```genus```, ```species_id```, and ```weight```.





#-----------
# Reshaping
#-----------







#-----------
# CHALLENGE
#-----------

# 1. Spread the surveys data frame with year as columns, plot_id as rows, 
#    and the number of genera per plot as the values. You will need to summarize before reshaping, 
#    and use the function n_distinct() to get the number of unique genera within a particular chunk of data. 
#    It’s a powerful function! See ?n_distinct for more.

# 2. Now take that data frame and pivot_longer() it again, so each row is a unique plot_id by year combination.

# 3. The surveys data set has two measurement columns: hindfoot_length and weight. 
#    This makes it difficult to do things like look at the relationship between mean values of each 
#    measurement per year in different plot types. Let’s walk through a common solution for this type of problem. 
#    First, use pivot_longer() to create a dataset where we have a key column called measurement and a value column that 
#    takes on the value of either hindfoot_length or weight. 
#    Hint: You’ll need to specify which columns are being pivoted.

# 4. With this new data set, calculate the average of each measurement in each year for each different plot_type. 
#    Then pivot_wider() them into a data set with a column for hindfoot_length and weight. 
#    Hint: You only need to specify the key and value columns for pivot_wider().





#----------------
# Exporting data
#----------------












