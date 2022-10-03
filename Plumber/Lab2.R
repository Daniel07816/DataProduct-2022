library(plumber)
library(dplyr)
library(lubridate)


data <- read.csv("s&p.csv", sep = ",")
data[,1] <- as.Date.character(data[,1], format = "%d/%m/%y")

users <- data.frame(
  uid=c(1,2,3,4,5,6),
  username=c("Daniel", "Mario","Marcela", "Cruz", "Lorena", "Carlos")
)

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