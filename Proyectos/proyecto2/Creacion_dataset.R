library(shiny)
library(readr)
library(DT)

data_pro <- read_csv("dataset.csv")


names(data_pro) <- c("Title", "Seasons", "Episodes", "Country", "borrar", 
                     "Premiere_Year", "Final_Year", "Original Channel", 
                     "Technique")


data_pro <- data_pro[,-5]


data_pro <- data_pro %>% 
  mutate(Seasons = case_when(!is.na(Seasons) ~ Seasons, 
                             is.na(Seasons) ~ "1"))


data_pro <- dataset %>% 
  mutate(Seasons = as.numeric(Seasons), 
         Episodes = as.numeric(Episodes)) %>% 
  filter(!is.na(Seasons)) %>% 
  filter(!is.na(Episodes))

data_pro <- data_pro %>% 
  rename_with(~gsub(" ","_",.x,fixed = TRUE))


data_pro <- data_pro %>% 
  mutate(Technique = toupper(Technique),
         Technique = gsub(" ","-", Technique))


saveRDS(data_pro, "data.rds")

