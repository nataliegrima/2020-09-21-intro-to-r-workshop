## Visualising data with ggplot2

# load ggplot

library(ggplot2)
library(tidyverse)

#load data

surveys_complete <- read_csv("data_raw/surveys_complete.csv")

# create a plot - step by step

# 1 call the data using ggplot (dataset)
ggplot(data = surveys_complete)      

# 2 define the x and y axes using the aesthetics function (co-ordinating)
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))

# 3 tell ggplot how you want to display your data (visualising)
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()



# assign a plot to an object/variable

surveys_plot <- ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))

# draw the plot 

surveys_plot + geom_point()



# Challenge 1
# Change the mappings so weight is on the y-axis and hindfoot_length is on the x-axis

ggplot(data = surveys_complete, mapping = aes(x = hindfoot_length, y = weight)) +
  geom_point()

# alternate - ggplot works in layers so can reverse axes using aes function 
surveys_plot + 
  geom_point(aes(x = hindfoot_lenth, y = weight))

# Challenge 2
# How would you create a histogram of weights?
ggplot(data = surveys_complete, mapping = aes(x = weight)) +
  geom_histogram(binwidth = 10)

# Note: binwidth describes grouping strategy

# Challenge 3
# Use what you just learned to create a scatter plot of weight over species_id 
# with the plot type showing in different colours. 
ggplot(data = surveys_complete, mapping = aes(x = weight, y = species_id)) +
  geom_point()

