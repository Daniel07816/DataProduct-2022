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

train <- readRDS("metricas/train.rds")[1,]


logge <- function(req, res){
  # boole <- length(req$args)
  d <- Sys.time()
  y <-list('usuario' = Sys.getenv("USERNAME"),
           'end_point' = req$PATH_INFO,
           'user_agent'=req$HTTP_USER_AGENT,
           'time' = d, 
           'payload'=req$body, 
           'output' = res$body
  )
  
  archivo <- toJSON(y, auto_unbox = TRUE)
  
  wd <- getwd()
  
  dir <- paste0(wd,"/logs","/year=", year(d), "/month=", month(d), "/day=", day(d))
  
  dir.create(dir, recursive = TRUE)
  
  write(archivo, file = paste0(dir,"/",as.integer(d),".json"), append = TRUE)
}

mediciones = function(CM)
{
  TN = CM[1,1]
  TP = CM[2,2]
  FP = CM[2,1]
  FN = CM[1,2]
  
  recall = TP/(TP+FN)
  accuracy = (TP+TN)/(TN+TP+FP+FN)
  presicion = TP/(TP+FP)
  f1 = (2*presicion*recall)/(presicion+recall)
  
  results = list(
    RECALL = round(recall,2),
    ACCURACY = round(accuracy,2),
    PRESICION = round(presicion,2),
    SPECIFICITY = round(f1,2)
  )
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
  data$Risk <- "bad"
  info <- rbind(train, data)
  info <- info[-1,]
  
  result <- data.frame(predict(modelo, info))
  
  res$body <- result
  
  logge(req,res)
  
  result
}


#* Predice si un cliente es "bueno" o "malo" para pagar su prestamo
#* @serializer png
#* @post /metricas
function(req, res){
  test <- as.data.frame(req$body)
  test <- rbind(train, test)
  test <- test[-1,]
  
  result <- data.frame(predict(modelo, test))
  
  res$body <- result
  
  logge(req,res)
  
  #Prediccion
  rf.pred = predict(modelo, test)
  test$Predicted = rf.pred
  
  #Creando Matroz de confusion
  matrix = with(test, table(Predicted, Risk))
  mediciones(matrix)
  mosaic(matrix, shade = T, colorize = T, main = "Matriz de Confusion",
         gp = gpar(fill = matrix(c("green", "red", "red", "green"),2,2)))
  
  #ROC-AOC
  #rocaoc = roc(gcredit$Risk ~ gcredit$Duration)
  #rocaoc #(mientras mas alto mejor)
  #ci.auc(rocaoc)
  #plot(rocaoc)
  
}


#* @plumber
function(pr){
  pr %>% 
    pr_set_api_spec(yaml::read_yaml("openapi.yaml"))
  
}
