# Purpose: Clean the American time use tables.
# Date: 7/23/21
#################################################

# Read in the first table:
x = read.csv('https://raw.githubusercontent.com/tvbassine/american-time-use/master/data/American%20Time%20Use%20Survey%20-%20table_1.csv',
             stringsAsFactors = F)
summary(x)
head(x)

# Make more readable columns:
colnames(x) = c('Activity', 'hours_2019',
                'hours_2020', 'pct_did_act_2019',
                'pct_did_act_2020', 'hours_who_did_2019',
                'hours_who_did_2020')

head(x)

# Remove the first row which just has the years 2019 and 2020:
x = x[-1,]

# Check the column sums to see if they are reasonable:
apply(x[,2:3], 2, sum) #The total hours add up to almost 68, which is expected (we have a row for total which is adding another 24 hours.)

# write out data
write.csv(x, paste(getwd(), '/Data/topline.csv', sep = ''))

