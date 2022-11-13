library(plumber)
library(ISLR)
library(randomForest)
library(naniar)
library(missMDA)
library(vcd)
library(pROC)

library(plumber)
library(dplyr)
library(rpart)
library(readr)
library(lubridate)
library(jsonlite)



# Utilise post method to send JSON unseen data, in the same 
# format as our dataset

#--------------------------------------------------
# Read in model 
#--------------------------------------------------
modelo <- readRDS("random_forest.rds")
modelo$modelInfo

train <- readRDS("train.rds")[1,]


logge <- function(req, res){
  # boole <- length(req$args)
  boole <- 1
  
  d <- Sys.time()
  y <-list('usuario' = Sys.getenv("USERNAME"),
           'end_point' = req$PATH_INFO,
           'user_agent'=req$HTTP_USER_AGENT,
           'time' = d, 
           'payload'=req$body, 
           'status' = res$status, 
           'output' = res$body
  )
  
  archivo <- toJSON(y, auto_unbox = TRUE)
  
  wd <- getwd()
  
  dir <- paste0(wd,"/logs","/year=", year(d), "/month=", month(d), "/day=", day(d))
  
  dir.create(dir, recursive = TRUE)
  
  write(archivo, file = paste0(dir,"/",as.integer(d),".json"), append = TRUE)
}


#* Test connection
#* @get /connection-status
function(){
  list(status = "Connection to Stranded Patient API successful", 
       time = Sys.time(),
       username = Sys.getenv("USERNAME"))
}



#* Predice si un cliente es "bueno" o "malo" para pagar su prestamo
#* @serializer json
#* @post /predict
function(req, res){
  data <- as.data.frame(req$body)
  data$Risk <- "bad"
  info <- rbind(train, data)
  info <- info[-1,]
  
  result <- data.frame(predict(modelo, info))
  
  res$body <- result
  
  logge(req,res)
  
  result
}



#* Predice si un cliente es "bueno" o "malo" para pagar su prestamo
#* @serializer json
#* @post /batches
function(req, res){
  data <- as.data.frame(req$body)
  data$Risk <- "good"
  info <- rbind(train, data)
  info <- info[-1,]
  
  resulta <- data.frame(predict(modelo, info))
  
  res$body <- resulta
  
  logge(req,res)
  
  resulta
}



#* @plumber
function(pr){
  pr %>% 
    pr_set_api_spec(yaml::read_yaml("openapi.yaml"))
  
}
