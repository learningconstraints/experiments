#!RScript
# args[1] is the data procesed
# args[2] is the path for the results
# args[3] is the path for the minmax file
library(ggplot2)
library(plyr)
library(reshape2)
library(tools)

library(gridExtra)
library(grid)


args=(commandArgs(TRUE))
processData <- function(data){

  #Adding a helper colum
  data$index <- 1
  data$index <- ave(data$index, cumsum(c(F, diff(data$sr) > 0)), FUN=seq_along)
  data$freq<-ave( as.numeric(data[[1]]), data[["sr"]] , FUN=length)
  data$index= data$index * 100 / data$freq
  
  #CALCULATE METRICS
  data$accuracy = (data$TP+data$TN)/(data$TP+data$TN+data$FN+data$FP)
  data$specificity=data$TN/(data$TN+data$FP)
  data$precision=data$TP/(data$TP + data$FP)
  data$recall = data$TP / (data$TP+ data$FN) # Recall of class 1
  data$npv=data$TN/(data$TN+data$FN)
  data$negNPV=data$npv-(data$index/100)
  data$negAccuracy=data$accuracy-(data$index/100)
  
  #This melting is because the data wasn't in the proper csv style
    
  data<-melt(data, id.vars = c("FN","FP","TN","TP","sr","t","index","freq"))
    
  return(data)
}

processDataDiffNormalized <- function(data1, data2){
    
  #Adding a helper colum
  data1$index <- 1
  data1$index <- ave(data1$index, cumsum(c(F, diff(data1$sr) > 0)), FUN=seq_along)
  data1$freq<-ave( as.numeric(data1[[1]]), data1[["sr"]] , FUN=length)
  data1$index= data1$index * 100 / data1$freq
  
  #CALCULATE METRICS
  data1$accuracy = (data1$TP+data1$TN)/(data1$TP+data1$TN+data1$FN+data1$FP)
  data1$specificity=data1$TN/(data1$TN+data1$FP)
  data1$precision=data1$TP/(data1$TP + data1$FP)
  data1$recall = data1$TP / (data1$TP+ data1$FN) # Recall of class 1
  data1$npv=data1$TN/(data1$TN+data1$FN)
  data1$negNPV=data1$npv-(data1$index/100)
  data1$negAccuracy=data1$accuracy-(data1$index/100)
    
    
  #Adding a helper colum
  data2$index <- 1
  data2$index <- ave(data2$index, cumsum(c(F, diff(data2$sr) > 0)), FUN=seq_along)
  data2$freq<-ave( as.numeric(data2[[1]]), data2[["sr"]] , FUN=length)
  data2$index= data2$index * 100 / data2$freq
  
  #CALCULATE METRICS
  data2$accuracy = (data2$TP+data2$TN)/(data2$TP+data2$TN+data2$FN+data2$FP)
  data2$specificity=data2$TN/(data2$TN+data2$FP)
  data2$precision=data2$TP/(data2$TP + data2$FP)
  data2$recall = data2$TP / (data2$TP+ data2$FN) # Recall of class 1
  data2$npv=data2$TN/(data2$TN+data2$FN)
  data2$negNPV=data2$npv-(data2$index/100)
  data2$negAccuracy=data2$accuracy-(data2$index/100)
    
    
  #Calculate diff
  accuracy <- data.frame( data1 = data1$accuracy , data2 = data2$accuracy)
  accuracy$accuracy <- (accuracy$data1 - accuracy$data2)
    
  specificity <- data.frame( data1 = data1$specificity , data2 = data2$specificity)
  specificity$specificity <- (specificity$data1 - specificity$data2)
    
  precision <- data.frame( data1 = data1$precision , data2 = data2$precision)
  precision$precision <- (precision$data1 - precision$data2)
    
  recall <- data.frame( data1 = data1$recall , data2 = data2$recall)
  recall$recall <- (recall$data1 - recall$data2)
    
  npv <- data.frame( data1 = data1$npv , data2 = data2$npv)
  npv$npv <- (npv$data1 - npv$data2)
    
  negNPV <- data.frame( data1 = data1$negNPV , data2 = data2$negNPV)
  negNPV$negNPV <- (negNPV$data1 - negNPV$data2)
    
  negAccuracy <- data.frame( data1 = data1$negAccuracy , data2 = data2$negAccuracy)
  negAccuracy$negAccuracy <- (negAccuracy$data1 - negAccuracy$data2)
    
  data <- data.frame(
      accuracy = accuracy$accuracy,
      specificity = specificity$specificity,
      precision = precision$precision,
      recall = recall$recall,
      npv = npv$npv,
      negNPV = negNPV$negNPV,
      negAccuracy = negAccuracy$negAccuracy
  )
  
  #Normalization
  data$accuracy = data$accuracy/abs(data$accuracy)
  data$specificity = data$specificity/abs(data$specificity)
  data$precision = data$precision/abs(data$precision)
  data$recall = data$recall/abs(data$recall)
  data$npv = data$npv/abs(data$npv)
  data$negNPV = data$negNPV/abs(data$negNPV)
  data$negAccuracy = data$negAccuracy/abs(data$negAccuracy)
    
  #This melting is because the data wasn't in the proper csv style
  data<-melt(data)
    
    rapply( data, f=function(x) ifelse(is.nan(x),0,x), how="replace" )
    
  return(data)
}

processDataDiff <- function(data1, data2){
    
  #Adding a helper colum
  data1$index <- 1
  data1$index <- ave(data1$index, cumsum(c(F, diff(data1$sr) > 0)), FUN=seq_along)
  data1$freq<-ave( as.numeric(data1[[1]]), data1[["sr"]] , FUN=length)
  data1$index= data1$index * 100 / data1$freq
  
  #CALCULATE METRICS
  data1$accuracy = (data1$TP+data1$TN)/(data1$TP+data1$TN+data1$FN+data1$FP)
  data1$specificity=data1$TN/(data1$TN+data1$FP)
  data1$precision=data1$TP/(data1$TP + data1$FP)
  data1$recall = data1$TP / (data1$TP+ data1$FN) # Recall of class 1
  data1$npv=data1$TN/(data1$TN+data1$FN)
  data1$negNPV=data1$npv-(data1$index/100)
  data1$negAccuracy=data1$accuracy-(data1$index/100)
    
    
  #Adding a helper colum
  data2$index <- 1
  data2$index <- ave(data2$index, cumsum(c(F, diff(data2$sr) > 0)), FUN=seq_along)
  data2$freq<-ave( as.numeric(data2[[1]]), data2[["sr"]] , FUN=length)
  data2$index= data2$index * 100 / data2$freq
  
  #CALCULATE METRICS
  data2$accuracy = (data2$TP+data2$TN)/(data2$TP+data2$TN+data2$FN+data2$FP)
  data2$specificity=data2$TN/(data2$TN+data2$FP)
  data2$precision=data2$TP/(data2$TP + data2$FP)
  data2$recall = data2$TP / (data2$TP+ data2$FN) # Recall of class 1
  data2$npv=data2$TN/(data2$TN+data2$FN)
  data2$negNPV=data2$npv-(data2$index/100)
  data2$negAccuracy=data2$accuracy-(data2$index/100)
    
    
  #Calculate diff
  accuracy <- data.frame( data1 = data1$accuracy , data2 = data2$accuracy)
  accuracy$accuracy <- (accuracy$data1 - accuracy$data2)
    
  specificity <- data.frame( data1 = data1$specificity , data2 = data2$specificity)
  specificity$specificity <- (specificity$data1 - specificity$data2)
    
  precision <- data.frame( data1 = data1$precision , data2 = data2$precision)
  precision$precision <- (precision$data1 - precision$data2)
    
  recall <- data.frame( data1 = data1$recall , data2 = data2$recall)
  recall$recall <- (recall$data1 - recall$data2)
    
  npv <- data.frame( data1 = data1$npv , data2 = data2$npv)
  npv$npv <- (npv$data1 - npv$data2)
    
  negNPV <- data.frame( data1 = data1$negNPV , data2 = data2$negNPV)
  negNPV$negNPV <- (negNPV$data1 - negNPV$data2)
    
  negAccuracy <- data.frame( data1 = data1$negAccuracy , data2 = data2$negAccuracy)
  negAccuracy$negAccuracy <- (negAccuracy$data1 - negAccuracy$data2)
    
  data <- data.frame(
      accuracy = accuracy$accuracy,
      specificity = specificity$specificity,
      precision = precision$precision,
      recall = recall$recall,
      npv = npv$npv,
      negNPV = negNPV$negNPV,
      negAccuracy = negAccuracy$negAccuracy
  )
    
  #This melting is because the data wasn't in the proper csv style
  data<-melt(data)
    
    rapply( data, f=function(x) ifelse(is.nan(x),0,x), how="replace" )
    
  return(data)
}

#LOAD THE FILE(S)
dataRegression=read.table(paste(args[1], "regression.csv", sep="-"), header=T,sep=",");
dataClassification=read.table(paste(args[1], "classification.csv", sep="-"), header=T,sep=",");
minmax=read.table(args[3], header=T,sep=",");

splitted<-strsplit(args[1],"/")
filename <- splitted[[1]][length(splitted[[1]])]

dataRegression<-processData(dataRegression);
dataClassification<-processData(dataClassification);
dataDiff<-processDataDiff(dataClassification,dataRegression);
dataDiffNormalized<-processDataDiffNormalized(dataClassification,dataRegression);

dataDiff$sr = dataClassification$sr
dataDiff$index = dataClassification$index    
           
dataDiffNormalized$sr = dataClassification$sr
dataDiffNormalized$index = dataClassification$index    

for (v in unique(dataRegression$variable)){
  limits=c(c(minmax[v][[1]][1],minmax[v][[1]][2]))
    
  datatmp=dataRegression[which(dataRegression$variable == v),]
    
  plotRegression<-ggplot(datatmp,aes(sr,index))+geom_tile(aes(fill=value))+
  scale_fill_gradient(low = "yellow",high = "red", limits=limits)+
    xlab("Number of configurations in the training set") +
    ylab("Percentage of acceptable configurations")+
    theme(strip.background = element_blank())+labs(fill="Classification\nMetric")+ 
    ggtitle("Regression")+
    theme(axis.text = element_text(size = rel(2)),axis.title= element_text(size = rel(2)), plot.title = element_text(face="bold", size=20, hjust=0.5))
    
  datatmp=dataClassification[which(dataClassification$variable == v),]
    
  plotClassification<-ggplot(datatmp,aes(sr,index))+geom_tile(aes(fill=value))+
  scale_fill_gradient(low = "yellow",high = "red", limits=limits)+
    xlab("Number of configurations in the training set") +
    ylab("Percentage of acceptable configurations")+
    theme(strip.background = element_blank())+labs(fill="Classification\nMetric")+ 
    ggtitle("Classification")+
    theme(axis.text = element_text(size = rel(2)),axis.title= element_text(size = rel(2)), plot.title = element_text(face="bold", size=20, hjust=0.5))
    
  datatmp=dataDiff[which(dataDiff$variable == v),]
    
  plotDiff<-ggplot(datatmp,aes(sr,index))+geom_tile(aes(fill=value))+
  scale_fill_gradient(low = "yellow",high = "red")+
    xlab("Number of configurations in the training set") +
    ylab("Percentage of acceptable configurations")+
    theme(strip.background = element_blank())+labs(fill="Classification\nMetric")+ 
    ggtitle("Difference")+
    theme(axis.text = element_text(size = rel(2)),axis.title= element_text(size = rel(2)), plot.title = element_text(face="bold", size=20, hjust=0.5))
    
  datatmp=dataDiffNormalized[which(dataDiff$variable == v),]
    
  plotDiffNormalized<-ggplot(datatmp,aes(sr,index))+geom_tile(aes(fill=value))+
  scale_fill_gradient(low = "yellow",high = "red")+
    xlab("Number of configurations in the training set") +
    ylab("Percentage of acceptable configurations")+
    theme(strip.background = element_blank())+labs(fill="Classification\nMetric")+ 
    ggtitle("Difference normalized")+
    theme(axis.text = element_text(size = rel(2)),axis.title= element_text(size = rel(2)), plot.title = element_text(face="bold", size=20, hjust=0.5))
  
  title=textGrob(paste(as.character(v), " for ", filename, sep=""), gp=gpar(fontface="bold",fontsize=20))
    
  ggsave(
      arrangeGrob(plotClassification, plotRegression, plotDiff, plotDiffNormalized, ncol=4, bottom=title),
      file=paste(
          args[2], paste(
              basename(file_path_sans_ext(args[1])),
              ".pdf",
              sep = paste(
                  "-",
                  as.character(v),
                  sep="")
          ), sep=""
      ),
      width=33,
      height=11
      )
}
