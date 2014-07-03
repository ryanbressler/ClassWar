
library("foreign")
library("randomForest")

args<-(commandArgs(TRUE))

train<-read.arff(args[[1]])
test<-read.arff(args[[2]])

for(i in 1:length(train)){
	if (is.factor(train[,i])){
		if (nlevels(train[,i])>nlevels(test[,i])){
			test[,i]=factor(test[,i],levels=levels(train[,i]))
		}else{
			train[,i]=factor(train[,i],levels=levels(test[,i]))
		}
	}
}

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
xt = test[!targets]

# testclass = sapply(xt, class)
# trainclass = sapply(x, class)

# for(i in 1:length(xt)){
# 	if (trainclass[i]!=testclass[i] || nlevels(x[,i])!=nlevels(xt[,i])){
# 		cat(colnames(x)[i],colnames(xt)[i],trainclass[i],testclass[i],trainclass[i]!=testclass[i],nlevels(x[,i]),nlevels(xt[,i]),"\n")
# 	}
# }

pred = predict(rf,xt)

cat("Error: ", 1.0 - (sum("true"==pred[y=="true"])/sum(y=="true")+sum("false"==pred[y=="false"])/sum(y=="false"))/2.0, "\n")

Sys.sleep(".1")




