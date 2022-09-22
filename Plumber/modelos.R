library(rpart)
library(rattle)
library(rpart.plot)
library(dplyr)
library(readr)

train = read.csv("train.csv")
test = read.csv("test.csv")

fit = rpart(Survived ~ Pclass + Sex + Age + SibSp +
              Parch + Fare + Embarked,
            data = train,
            method = "class")

fancyRpartPlot(fit)

Prediction = predict(fit, test, type="class")

saveRDS(fit, "modelo_entrenado.rds")