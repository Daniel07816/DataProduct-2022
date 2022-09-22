library(plumber)

#* @apiTitle Clase sobre el uso de plumber
#* @apiDescription En esta api se implementaran varios endpoints que nos
#* serviran para aprender el uso de plumber

#* Eco de Input
#* @param msg Mensaje que vamos a repetir
#* @get /echo

function(msg=""){
  list(msg = paste0("El mensaje es: "),msg)
}

#* Histograma de una distribución Normal
#* @serializer png
#* @param n Total de numeros
#* @param bins Total de particiones
#* @get /plot

function(n=100, bins=15){
  rand <- rnorm(as.numeric(n))
  hist(rand, breaks=as.numeric(bins))
}

#* Suma de dos parametros
#* @serializer unboxedJSON
#* @param x primer numero
#* @param y segundo numero
#* @get /suma

function(x='1', y='2'){
  x = as.numeric(x)
  y = as.numeric(y)
  list("Primer Numero"=x,
       "Segundo Numero"=y,
       "Suma"=x+y)
}

#* Ejemplo de serializacion csv
#* @serializer csv
#* @param n Numero de filas
#* @get /data

function(n='100'){
  head(mtcars, as.numeric(n))
}