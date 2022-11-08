setwd("C:/Users/danie/Desktop/DataProduct-2022/Proyectos/Proyecto Modelo")
gcredit = read.csv("german_credit_data.csv")

install.packages("randomForest")
library(ISLR)
library(randomForest)
library(naniar)
library(missMDA)

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
  
  print(paste("Recall: ", round(recall,2)))
  print(paste("Accuracy: ", round(accuracy,2)))
  print(paste("Precision: ", round(presicion,2)))
  print(paste("F1: ", round(f1,2)))
}

gcredit = transform(gcredit, Sex = as.factor(Sex), Job = as.factor(Job), Housing = 
      as.factor(Housing), Saving.accounts = as.factor(Saving.accounts),
      Checking.account = as.factor(Checking.account), Purpose = as.factor(Purpose),
      Risk = as.factor(Risk))
str(gcredit)

n_miss(gcredit)
gg_miss_var(gcredit)
gcredit$Checking.account[is.na(gcredit$Checking.account)] = "little"
gcredit$Saving.accounts[is.na(gcredit$Saving.accounts)] = "little"

dt = sort(sample(nrow(gcredit), nrow(gcredit)*0.7))
train = gcredit[dt,(2:11)]
test = gcredit[-dt,(2:11)]

#Modelo random forest
rf = randomForest(Risk ~ ., data = train, importance = TRUE, ntree = 50,
      mtry = sqrt(ncol(train)), nodesize = 1, type = "classification", 
      predicted = TRUE)
saveRDS(rf, "random_forest.rds")
varImpPlot(rf)

rfExt = readRDS("random_forest.rds")

rf.pred = predict(rfExt, test)
test$Predicted = rf.pred
matrix = with(test, table(Predicted, Risk))
mediciones(matrix)

levels(test$Predicted)
test$Predicted = relevel(test$Predicted, ref = 2)

levels(test$Risk)
test$Risk = relevel(test$Risk, ref = 2)

matrix2 = with(test, table(Predicted, Risk))
mediciones(matrix2)

#-------------Hiperparametros del random forest
install.packages("caret")
library(caret)
control = trainControl(method = "cv", number = 10)
tunegrid = expand.grid(.mtry = (1:6))

rf2 = train(Risk~., data = train, method = "rf", metric = "Accuracy",
      TuneGrid = tunegrid, trControl = control)
print(rf2)
rf2$bestTune$mtry

#Random Search
control2 = trainControl(method = "repeatedcv", number = 5, repeats = 2,
        search = "random", classProbs = TRUE, savePredictions = "final",
        summaryFunction = twoClassSummary)
rf3 = train(Risk~., data = train, method = "rf", metric = "Sens", tuneLength = 8, 
        trControl = control2)
print(rf3)
plot(rf3)

#A partir de esto ya puedo usar el mtry sugerido en el modelo normal