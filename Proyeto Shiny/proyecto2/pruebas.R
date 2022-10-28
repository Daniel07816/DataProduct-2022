library(readr)
library(dplyr)
library(lubridate)
library(stringr)

dataset <- read_csv("dataset.csv")
View(dataset)
str(dataset)

##### Preparacion de la base de datos #####

dataset <- dataset[-5]

dataset <- dataset %>% 
  mutate(Seasons = case_when(!is.na(Seasons) ~ Seasons, is.na(Seasons) ~ "1"))
 
dataset <- dataset %>% 
  mutate(Seasons = as.numeric(Seasons), 
         Episodes = as.numeric(Episodes)) %>% 
  filter(!is.na(Seasons)) %>% 
  filter(!is.na(Episodes))


#######
pais <- "United States"

res <- dataset %>% 
  filter(str_detect(Country, pais, negate = FALSE))


tecnica <- "Flash"

res <- dataset %>% 
  filter(str_detect(Technique, tecnica, negate = FALSE))
         
         