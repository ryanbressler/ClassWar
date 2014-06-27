
library("foreign")
library("randomForest")

args<-(commandArgs(TRUE))

train<-read.arff(args[[1]])
test<-read.arff(args[[2]])
target<-args[[3]]

targets = colnames(train)==target

y = train[targets]
x = train[!targets]

ptm <- proc.time()

rf <- randomForest(x,as.factor(y[,1]))

print(cat("Total training time (seconds): ",(proc.time()-ptm)[3],"\n"))

targets = colnames(test)==target

y = test[targets]
x = test[!targets]

pred = predict(rf,x)

print(cat("Error: ", 1.0 - (sum(pred[y==true])/sum(y==true)+sum(!pred[y==false])/sum(y==false))/2.0)




