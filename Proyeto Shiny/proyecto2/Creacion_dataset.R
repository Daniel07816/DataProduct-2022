library(shiny)
library(readr)
library(DT)

data_pro <- read_csv("dataset.csv")


names(data_pro) <- c("Title", "Seasons", "Episodes", "Country", "borrar", 
                     "Premiere Year", "Final Year", "Original Channel", 
                     "Technique")


data_pro <- data_pro %>% 
  mutate(Seasons = case_when(!is.na(Seasons) ~ Seasons, 
                             is.na(Seasons) ~ "1"))


data_pro <- dataset %>% 
  mutate(Seasons = as.numeric(Seasons), 
         Episodes = as.numeric(Episodes)) %>% 
  filter(!is.na(Seasons)) %>% 
  filter(!is.na(Episodes))


data_pro <- data_pro[,-5]


saveRDS(data_pro, "data.rds")

