## Visualising data with ggplot2

# load ggplot
library(ggplot2)
library(tidyverse)

#load data
surveys_complete <- read_csv("data_raw/surveys_complete.csv")

# CREATING A PLOT - step by step 

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



# BUILDING PLOTS ITERATIVELY

# "alpha" changes the opacity of the points (0 is fully transparent, 1 is opaque)
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1)

# colours can also be added as an argument within the geom_point function 
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, colour = "cyan")

# and can be used to define groups
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, aes(colour = species_id))
#alternate
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length, colour = species_id)) +
  geom_point(alpha = 0.1)


# Note on colours:
# Most basic colours are recognised by R (need quotation marks as they don't come from dataset)
# You can also use a HEX code
# Plent of resources online... 
# https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/


# Challenge 3
# Use what you just learned to create a scatter plot of weight over species_id 
# with the plot type showing in different colours. 
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight, colour = species_id)) +
  geom_point()

# alternate that spreads our the overlapping points is geom_jitter function 
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight, colour = species_id)) +
  geom_jitter()



# BOX PLOTS AND VIOLIN PLOTS

# basic box plot
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_boxplot()

# adding individual points on top of your box plot as a second layer
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, colour = "tomato")


# Challenge 4
# Notice how the boxplot layer is behind the jitter layer? What do you need to change in the code to 
# put the boxplot in front of the points such that it’s not hidden?
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_jitter(alpha = 0.3, colour = "tomato") +
  geom_boxplot(alpha = 0)

# Order of the layers matter!


# Challenge 5
# Boxplots are useful summaries but hide the shape of the distribution. For example, if there is a 
# bimodal distribution, it would not be observed with a boxplot. An alternative to the boxplot is 
# the violin plot (sometimes known as a beanplot), where the shape (of the density of points) is drawn.
# Replace the box plot with a violin plot
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_violin(alpha = 1, colour = "magenta")


# Challenge 6
# So far, we’ve looked at the distribution of weight within species. Make a new plot to explore the 
# distribution of hindfoot_length within each species.Add color to the data points on your boxplot 
# according to the plot from which the sample was taken (plot_id).
# Hint: Check the class for plot_id. Consider changing the class of plot_id from integer to factor. 
# How and why does this change how R makes the graph?

surveys_complete$plot_id <- as.factor(surveys_complete$plot_id)
class(surveys_complete$plot_id)

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length, colour = plot_id)) +
  geom_point()

# alternatively you can change plot_id o a factor directly in the ggplot code
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) +
  geom_jitter(alpha = 0.3, aes(colour = as.factor(plot_id))) +
  geom_boxplot(alpha = 0)
  

# Challenge 7
# In many types of data, it is important to consider the scale of the observations. For example, it 
# may be worth changing the scale of the axis to better distribute the observations in the space of 
# the plot. Changing the scale of the axes is done similarly to adding/modifying other components 
# (i.e., by incrementally adding commands). 
# Make a scatter plot of species_id on the x-axis and weight on the y-axis with a log10 scale.

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, aes(colour = as.factor(plot_id))) +
  scale_y_log10()

# alternative
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, aes(colour = as.factor(plot_id))) +
  scale_y_continuous(trans = 'log10')



# PLOTTING TIME SERIES DATA

# plotting counts per genus for each year as a line graph 
yearly_counts <- surveys_complete %>% 
  count(year, genus)

ggplot(data=yearly_counts, mapping = aes(x= year, y=n, group=genus)) +
  geom_line()

# Challenge 8
# Modify the code for the yearly counts to colour by genus so we can clearly see the counts by genus.
ggplot(data = yearly_counts, mapping = aes(x = year, y = n, colour = genus)) +
         geom_line()

# note that the colour function will automatically group by genus for you



# INTEGRATING THE PIPE OPERATOR WITH GGPLOT

# by using pipes you no longer need to add the data argument into the ggplot function 
yearly_counts %>% 
  ggplot(mapping = aes(x = year, y = n, colour = genus)) +
  geom_line()

# you can go one step further and combine all these steps into one by piping twice
yearly_counts_graph <- surveys_complete %>% 
  count(year, genus) %>% 
  ggplot(mapping = aes(x = year, y = n, colour = genus)) +
  geom_line()



# FACETING

# making a panel of graphs to better visualise our data
ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
  geom_line() + 
  facet_wrap(facet = vars(genus))

# alternate method
ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
  geom_line() + 
  facet_wrap(~genus)

# adding sex as another variable
yearly_sex_counts <- surveys_complete %>% 
  count(year, genus, sex) %>% 
  ggplot(mapping= aes(x = year, y = n, colour = sex)) + 
  geom_line() +
  facet_wrap(facet = vars(genus))

yearly_sex_counts

# faceting sex
yearly_sex_counts %>% 
  ggplot(mapping= aes(x = year, y = n, colour = sex)) + 
  geom_line() +
  facet_grid(rows = vars(sex), cols  = vars(genus))

# Challenge 9
# How would you modify this code so the faceting is organised into only columns instead of only rows?
  
# Challenge 10
# Put together what you’ve learned to create a plot that depicts how the average weight of each 
# species changes through the years.
# Hint: need to do a group_by() and summarize() to get the data before plotting

