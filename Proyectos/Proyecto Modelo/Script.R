setwd("C:/Users/danie/Desktop/DataProduct-2022/Proyectos/Proyecto Modelo")
gcredit = read.csv("german_credit_data.csv")

library(ISLR)
library(randomForest)
library(naniar)
library(missMDA)
library(vcd)
library(pROC)

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

#Limpieza de la data----------------
gcredit = transform(gcredit, Sex = as.factor(Sex), Job = as.factor(Job), Housing = 
      as.factor(Housing), Saving.accounts = as.factor(Saving.accounts),
      Checking.account = as.factor(Checking.account), Purpose = as.factor(Purpose),
      Risk = as.factor(Risk))
str(gcredit)

n_miss(gcredit)
gg_miss_var(gcredit)
gcredit$Checking.account[is.na(gcredit$Checking.account)] = "little"
gcredit$Saving.accounts[is.na(gcredit$Saving.accounts)] = "little"
#-----------------------------------

#Modelo-----------------------------
dt = sort(sample(nrow(gcredit), nrow(gcredit)*0.7))
train = gcredit[dt,(2:11)]
test = gcredit[-dt,(2:11)]


rf = randomForest(Risk ~ ., data = train, importance = TRUE, ntree = 50,
      mtry = sqrt(ncol(train)), nodesize = 1, type = "classification", 
      predicted = TRUE)
saveRDS(rf, "random_forest.rds")
varImpPlot(rf)

rfExt = readRDS("random_forest.rds")

rf.pred = predict(rfExt, test)
test$Predicted = rf.pred
#-----------------------------------

#Matriz de confusion----------------
matrix = with(test, table(Predicted, Risk))
mediciones(matrix)
mosaic(matrix, shade = T, colorize = T, main = "Matriz de Confusion",
       gp = gpar(fill = matrix(c("green", "red", "red", "green"),2,2)))
#-----------------------------------

#ROC-AOC----------------------------
rocaoc = roc(gcredit$Risk ~ gcredit$Duration)
rocaoc #(mientras mas alto mejor)
ci.auc(rocaoc)
plot(rocaoc)
#-----------------------------------