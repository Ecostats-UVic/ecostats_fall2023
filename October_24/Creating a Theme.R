#Creating a theme in R
library(ggplot2)

shark_data <- read.csv("data/LPD_Sharks_CPUE.csv")

theme.dgm <- function () {
  theme_classic(base_size = 12) +
    theme(
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black"),
      axis.title = element_text(size = 14, face = "bold"),
      axis.text = element_text(size = 12, face = "plain"),
      legend.text = element_text(size = 12, face = "plain"),
      legend.title = element_text(size = 14, face = "bold"))
}

theme.dgm.map <- function (){
  theme_bw(base_size = 12) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.title = element_text(size = 14, face = "bold"),
          axis.text = element_text(size = 12, face = "plain"),
          legend.text = element_text(size = 12, face = "plain"),
          legend.title = element_text(size = 14, face = "bold")) 
}

Country_Colors <- c("blue", "green", "yellow", "orange",
                    "red", "pink")

shark_data$Region <- factor(shark_data$Region,
                            levels = c("International Waters", "Latin America and Caribbean",
                                       "Africa", "Asia", "North America",
                                       "Europe"))

theme.example <- function(){
  theme_classic(base_size = 12, base_family = "Times") +
    theme(
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black"),
      axis.title = element_text(size = 14, face = "bold"),
      axis.text = element_text(size = 12, face = "plain"),
      legend.text = element_text(size = 12, face = "plain"),
      legend.title = element_text(size = 14, face = "bold")) 
}


ggplot(shark_data, aes(x = Region, y = Abundance, color = Region)) +
  geom_boxplot() +
  scale_color_manual(values = Country_Colors) +
  theme.example()
  
