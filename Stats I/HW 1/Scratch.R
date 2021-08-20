
library(ggplot2)

student_survey <-read.csv('http://sites.williams.edu/bklingen/files/2015/07/fl_student_survey.csv')

# This is a categorical variable that has to values Yes/No
# It is heavily weighted to No
barplot(table(student_survey$vegetarian),
         col = c("mistyrose", "lightgreen"),
        xlab = 'Vegetarian')

# This is an ordinal quantitative factor
barplot(table(student_survey$religiosity),
        col = c("mistyrose", "lightgreen", 'lavender', 'cornsilk'))

# This is a Categorical variable that has three possible values Yes/No/Unsure
barplot(table(student_survey$life_after_death),
        col = c("mistyrose", "lightgreen", 'lavender', 'cornsilk'))

hist(student_survey$distance_residence,
     col = c("mistyrose", "lightgreen", 'lavender', 'cornsilk'),
     xlab = 'Distance', 
     main = "Student's distance to residence")

table(student_survey$vegetarian)

length(student_survey)