train <- read.csv(file="train.csv", na.strings=c(""))
train$Dates<-fast_strptime(as.character(train$Dates), format="%Y-%m-%d %H:%M:%S", tz="UTC")
train$Day<-day(train$Dates)
train$Month<-month(train$Dates)
train$Year<-year(train$Dates)
train$Hour<-hour(train$Dates)
train$Minute<-minute(train$Dates)
train$Second<-second(train$Dates)
train$Intersection<-grepl("/", train$Address)
train$Intersection<-plyr::mapvalues(train$Intersection,from=c("TRUE","FALSE"),to=c(1,0))
train$Night<-ifelse(train$Hour > 22 | train$Hour < 6,1,0)
train$Week<-ifelse(train$DayOfWeek=="Saturday" | train$DayOfWeek=="Sunday",0,1)
categoryMatrix<-data.frame(with(train,model.matrix(~Category+0)))
names(categoryMatrix)<-sort(unique(train$Category))
train<-cbind(categoryMatrix,train)
MMLL <- function(act, pred, eps=1e-15) {
  pred[pred < eps] <- eps
  pred[pred > 1 - eps] <- 1 - eps
  -1/nrow(act)*(sum(act*log(pred)))
}
train.tr.index<-sample(1:nrow(train),0.7*nrow(train))
train.tr<-train[train.tr.index,]
train.test<-train[-train.tr.index,]
matMod.tr<-sparse.model.matrix(~as.factor(PdDistrict)+X+Y+Hour+Minute+Intersection+Night,data=train.tr)
matMod.test<-sparse.model.matrix(~as.factor(PdDistrict)+X+Y+Hour+Minute+Intersection+Night,data=train.test)
#matMod.test<-sparse.model.matrix(~as.factor(PdDistrict)+X+Y+Hour+Minute+Intersection+Night,data=train.test)
m<-glmnet(matMod.tr,train.tr[,1],family="binomial")
pred<-as.data.frame(predict(m,matMod.test,s=1e-15,type="response"))
numCat<-length(unique(train.tr$Category))
pb <- txtProgressBar(min = 1, max = numCat, style = 3)
for (i in 2:numCat) {
  m<-glmnet(matMod.tr,train.tr[,i],family="binomial")
  pred<-cbind(pred,predict(m,matMod.test,s=1e-15,type="response"))
  setTxtProgressBar(pb, i)
}
save(m, file="model.rda")
