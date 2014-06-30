
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

rf <- randomForest(x,as.factor(y[,1]),ntree=500)

cat("Total training time (seconds): ",(proc.time()-ptm)[3],"\n")

targets = colnames(test)==target

for(i in 1:length(train)){if(length(unique(train[,i]))==1){cat(colnames(train)[i],"\n")}}

# for ( i in 1:length(targets)) {
# 	if(length(unique(test[,i])) != length(unique(train[,i]))) {
# 		cat(colnames(test)[i],"\n")
# 	}
# }

y = test[targets]
x = test[!targets]

pred = predict(rf,x)

cat("Error: ", 1.0 - (sum(pred[y==true])/sum(y==true)+sum(!pred[y==false])/sum(y==false))/2.0, "\n")

Sys.sleep(".1")




