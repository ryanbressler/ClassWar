
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

print("Training:", proc.time() - ptm)



browse()

