library(plumber)
r <- plumb('modelos_api.R')
r$run(port=8000)
