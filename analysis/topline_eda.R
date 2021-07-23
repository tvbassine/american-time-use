# Purpose: Analyze some of the topline trends in American time use.
# Which activities did Americans do more or less of in the pandemic 
# year of 2020?
# Date: 7/23/21
####################################################################

# Read in data:
x = read.csv('https://raw.githubusercontent.com/tvbassine/american-time-use/master/data/topline.csv',
             stringsAsFactors = F)
head(x)
summary(x)

# How much did more time did Americans spend in activities in 2020?
x$delta = x$hours_2020 - x$hours_2019
x$delta_minutes = x$delta * 60

View(x[order(x$delta, decreasing = T),])

# Activities where Americans spent more time in 2020:
# -sports and leisure (32 minutes more)
# -watching television
# -household activities
# -sleeping (10 minutes more)

# Activities where we spent less time in 2020:
# -travel (26 min)
# -working (18 min)
# -socializing and communicating (7 min)

# The difference between "working" and "work-related-activities" is in the technical notes
# provided by BLS (https://www.bls.gov/news.release/atus.tn.htm):

# "Working" includes hours spent
# doing the specific tasks required of one's main or other job, regardless of location
# or time of day. "Work-related activities" include activities that are not obviously
# work but are done as part of one's job, such as having a business lunch and playing
# golf with clients.

# Let's make a nice plot of the change in time spent on activities:
library(ggplot2)

# Remove "Total, all activities(1)" and "Working" for the purposes of plotting deltas:
y = x[!(x$Activity %in% c('Total, all activities(1)', 'Working')), ]
y$Activity[y$Activity == 'Sleeping(2)'] = 'Sleeping'
y = y[order(y$delta_minutes, decreasing = F),]
# Make activity a factor. The levels here preserve the ordering so the plot goes from biggest
# delta to smallest.
y$Activity_factor = factor(y$Activity, levels = y$Activity)
# Color the bars based on whether Americans spent more or less time:
library(dplyr)
y$bar = if_else(y$delta > 0, 'red', 'blue')


p = ggplot(y, aes(x=Activity_factor, y = delta_minutes))+
  geom_bar(stat="identity", width=0.7, fill=y$bar, alpha = .7)+
  ylab('Change in Minutes, 2020 - 2019') +
  xlab('Activity') +
  coord_flip() + 
  theme_minimal() +
  theme(plot.title = element_text(size = 17, face = "bold", family = 'Times', hjust = .5),
        plot.subtitle = element_text(size = 14, face = "bold", family = 'Times', hjust = .5),
        axis.title.x = element_text( size=14),
        axis.title.y = element_text(size=14),
        axis.text.x = element_text( size = 12)) +
  ggtitle("Change In How Americans Spent Their Time, 2020 vs. 2019",
          subtitle = "Source: U.S. Bureau of Labor Statistics (BLS)")

ggsave(paste(getwd(), '/plots/topline.png', sep = ''), dpi = 500,
       height = 5.5, width = 11)

# Which activities did more or less Americans do?
x$pct_who_did_delta = x$pct_did_act_2020 - x$pct_did_act_2019
View(x)
# More people did sports or recreation (3.4%) and lawn and garden care.
# Less people travelled (17%!) and socialized/communicated (8%)