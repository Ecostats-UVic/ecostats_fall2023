# Example R script to show how to use R Projects to make filepaths easier.


#Normally to import a data set, you would need to enter the entire file path
#or you would need to ensure the file is in the same folder as your script

#for me this filepath looks like this
getwd()
example_data <- read.csv("~/Dropbox/Documents/R_Scripts/Bates_Lab_Resources/Intro_Materials/example.csv")

#Now when collaborating with people, this gets annoying because in order to import
#this data yourself, you will have to update the filepath

#To make it easier, open the project. This will set the working directory to the
#location of the R Project.
#Once I have the project open I only have to specify the path relative to the projects 
#location, which means it will be the same for everyone who has downloaded 
#the repo
example_data_2 <- read.csv("Intro_Materials/example.csv")

#This works great when only working with .R files, but once you try to use .Rmd files
#this won't work 
#If you work with .Rmd files, go to the simplified_filepaths.Rmd to find out how we solve this
