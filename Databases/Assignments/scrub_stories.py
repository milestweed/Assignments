#!/usr/bin/env python
# coding: utf-8

# Open the stories_orig.csv file in read mode
file = open('/home/mtweed/Documents/New_College/year_1/DatabasesForDS/Homework/3_Hubway_Fanfiction/Fanfiction/stories_orig.csv', 'r')


# Open an empty stories.csv file in write mode
file2 = open('/home/mtweed/Documents/New_College/year_1/DatabasesForDS/Homework/3_Hubway_Fanfiction/Fanfiction/stories.csv', 'w')


# Ensure that the cursor is set to the beginning of each file
file.seek(0)
file2.seek(0)

# Read the entire file into the variable line
lines = file.readlines()

# Create an empty dictionary to hold URLs
urls = {}

# This loop iterates over each line in lines
for i in range(0,len(lines)):

    # Since the first line will be the header, it is immediately written
    if i == 0:
        file2.writelines(lines[0])

    # Otherwise it is a record and needs to be checked for duplication
    else:
	# set line equal to an individual line
        line = lines[i]

        # Even though this is a comma separated file, there are commas in 
        # some of the variables
        # Separation one uses the fact that every url starts with ',http://'
        sep1 = line.split(sep = ',http://')
	
        # separation one created a list with two items, one of which 
        # started at the 'www.' of the url
        # The entry is further separated using the comma
        sep2 = sep1[1].split(sep = ',')

	# The zeroth value of separation 2 is the isolated url
	# If this value exists in the dictionary keys, it is skipped
        if sep2[0] in urls.keys():
            continue

	# otherwise, it is added to the dictionary and written as the next line in stories.csv
        else:
            urls[sep2[0]] = 1
            file2.writelines(lines[i])

