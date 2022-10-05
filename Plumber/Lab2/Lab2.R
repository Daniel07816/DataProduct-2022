library(plumber)
library(dplyr)
library(lubridate)
library(jsonlite)
library(stringr)
library(rpart)


data <- read.csv("s&p.csv", sep = ",")
data[,1] <- as.Date.character(data[,1], format = "%d/%m/%y")

users <- data.frame(
  uid=c(1,2,3,4,5,6),
  username=c("Daniel", "Mario","Marcela", "Cruz", "Lorena", "Carlos")
)
#* ------------------PARTE 2-------------------

#* Log some information about the incoming request
#* @filter logger
function(req){
  largo <- length(req$args)
  if(largo > 0){
    fecha <- Sys.time()
    path <- paste0(getwd(),'/year=', year(fecha),'/month=', month(fecha),'/day=', day(fecha),'/',hour(fecha))
    path <- str_replace_all(path, fixed(" "), "")
    if (file.exists(path)) {
      
      cat("The folder already exists")
      
    } else {
      
      dir.create(path, recursive = TRUE)
      
    }
    
    ListJSON <- toJSON(list('req'=req$args, 'query'=req$QUERY_STRING, 'user_agent'=req$HTTP_USER_AGENT),auto_unbox=TRUE)
    write(ListJSON, file = paste0(path, '/', as.integer(fecha), '.json'))
    plumber::forward()
    
  }
  plumber::forward()
}

fit <- readRDS("modelo_entrenado.rds")

#* Prediccion de sobrevivencia de un pasajero
#* @param Pclass clase en el que viajabe el pasajero
#* @param Sex Sexo del pasajero
#* @param Age edad del pasajero
#* @param SibSp numero de hermanos
#* @param Parch numero de parientes
#* @param Fare precio del boleto
#* @param Embarked puerto del que embarco
#* @post /titanic

function(Pclass, Sex, Age, SibSp, Parch, Fare, Embarked){
  features <- data_frame(Pclass = as.integer(Pclass),
                         Sex,
                         Age=as.integer(Age),
                         SibSp= as.integer(SibSp),
                         Parch = as.integer(Parch),
                         Fare = as.numeric(Fare),
                         Embarked)
  out <- predict(fit,features,type = "class")
  as.character(out)
}

#* --------------------------------------------
#* ------------------PARTE 3-------------------

#* Lookup a user
#* @get /users/<id>
function(id){
  subset(users, uid %in% id)
}

#* @get /inicio/<from>/final/<to>
function(from, to){
  # Convertimos las variables de stra date
  from <- ymd(from)
  to <- ymd(to)
  # Buscamos todos los valores en ese rango y lo retornamos
  subset(data, data$Fecha >= from & data$Fecha <= to)
}

#* --------------------------------------------
#* ------------------PARTE 4-------------------

#* @get /tint/<id:int>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}

#* @get /tbool/<id:bool>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}

#* @get /tdouble/<id:double>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}

#* --------------------------------------------