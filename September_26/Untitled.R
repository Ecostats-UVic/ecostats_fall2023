#Plotting in R
#Dominique Maucieri

library(ggplot2)
library(dplyr)

setwd("~/Dropbox/Documents/GitHub/ecostats_fall2023/September_19")
shark_data <- read.csv("data/LPD_Sharks_CPUE.csv")

plot(table(rpois(100, 5)), type = "h", col = "red", lwd = 10,
     main = "rpois(100, lambda = 5)")

plot(shark_data$Year, shark_data$Abundance)

ggplot(shark_data, aes(x = Year)) +
  geom_histogram(binwidth = 5, fill = "darkgreen", color = "grey") +
  theme_classic() +
  labs(x = "Sampling Year",
       y = "Count")



ggplot(shark_data, aes(x = Year, fill = Region)) +
  geom_histogram(binwidth = 5, color = "black") +
  theme_classic() +
  labs(x = "Sampling Year",
       y = "Count") +
  scale_fill_manual(values = c("cyan", "green", "deeppink", "goldenrod1",
                               "blueviolet", "darkblue"))


(shark_hist <- ggplot(shark_data, aes(x = Year, fill = Region)) +
  geom_histogram(binwidth = 5, color = "black") +
  theme_classic() +
  labs(x = "Sampling Year",
       y = "Count") +
  scale_fill_manual(values = c("cyan", "green", "red", "goldenrod1",
                               "blueviolet", "darkblue"))+
  facet_wrap(~Region) +
  theme(legend.position = "none"))

png(filename = "figure/shark_histogram.png", units = "in", width = 8, height = 5,
    res = 300)
shark_hist
dev.off()


ggplot(shark_data, aes(x = Region, y = Abundance, fill = Region)) +
  geom_boxplot() +
  theme_classic() +
  theme(legend.position = "none")


