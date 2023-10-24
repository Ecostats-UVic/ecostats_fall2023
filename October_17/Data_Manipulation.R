#Data Manipulation

library(dplyr)
library(tidyr)

setwd("/Users/dom/Library/CloudStorage/Dropbox/Documents/GitHub/ecostats_fall2023/September_19")
shark_data <- read.csv("data/LPD_Sharks_CPUE.csv")

fruit <- c("apple", "orange", "banana")
fruit

length(fruit)
length(shark_data)
length(shark_data$ID)

nrow(shark_data)
ncol(shark_data)

shark_data$Species
unique(shark_data$Species)

sharks_simple <- select(shark_data, Common_name, Country, Year, Abundance)
shark_rm <- select(shark_data, -Common_name)

lemon_shark <- filter(shark_data, Common_name == "Lemon shark")
rare_sharks <- filter(shark_data, Abundance <= 1)

lemon_tiger_sharks <- filter(shark_data, 
                             Common_name == "Lemon shark"|Common_name == "Tiger shark")
Africa_BlueShark <- filter(shark_data, 
                          Region == "Africa" & Common_name == "Blue shark")

Africa_Blue_SandTiger <- filter(shark_data,
                                Region == "Africa" &
                                  (Common_name == "Blue shark" | Common_name == "Sand tiger shark"))

sharks_grouped <- group_by(shark_data, Common_name)
str(sharks_grouped)


shark_samplesize <- summarise(sharks_grouped, sample_size = length(Abundance))

shark_summary <- summarise(sharks_grouped, sample_size = length(Abundance),
                           mean_abund = mean(Abundance), 
                           sd_abund = sd(Abundance),
                           se_abund = sd(Abundance)/sqrt(length(Abundance))) 

shark_summary_errorbars <- mutate(shark_summary, 
                                  SE_upper = mean_abund + se_abund,
                                  SE_lower = mean_abund - se_abund)


shark_summary_pipe <- shark_data %>% 
  group_by(Common_name) %>%
  summarise(sample_size = length(Abundance),
            mean_abund = mean(Abundance), 
            sd_abund = sd(Abundance),
            se_abund = sd(Abundance)/sqrt(length(Abundance))) %>%
  mutate(SE_upper = mean_abund + se_abund,
         SE_lower = mean_abund - se_abund)
  
  
# filter for years after and equal to 2000
# group by country
# unique shark species for each country and average abundance
  
  

