# R tutorial for Ecostats
# Dominique Maucieri
# Sept 19, 2023

# Packages ----
install.packages("dplyr")
library(dplyr)
# install.packages("ggplot2")
library(ggplot2)
# install.packages("readxl")
library(readxl)
# install.packages("tidyr")
library(tidyr)
library(car)
library(palmerpenguins)
# install.packages("dunn.test") #you may need to install this package if you haven't before
library(dunn.test)


# Loading Data ----
getwd()
setwd("~/Dropbox/Documents/GitHub/ecostats_fall2023/September_19")
getwd()

shark_data <- read.csv("data/LPD_Sharks_CPUE.csv")
shark_data2 <- read_excel("data/LPD_Sharks_CPUE.xlsx")

fruit <- c("apple", "orange", "banana", "grape")
str(fruit)

leaf_lengths <- c(3, 6, 7, 3)
str(leaf_lengths)

example <- c("apple", 5, "banana", 6)
str(example)

class(fruit)


class(shark_data)
str(shark_data)
str(shark_data$Abundance)

shark_data$ID <- as.character(shark_data$ID)
str(shark_data)

