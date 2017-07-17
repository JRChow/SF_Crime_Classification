# Read training data
train <- read.csv(file="train.csv", na.strings=c(""))
train <- subset(train, select = -c(Descript, Resolution))
# Prepare training data
train <- train[!(train$Y > 40),]
train$Year <- substring(train$Dates, 1, 4)
train$Month <- substring(train$Dates, 6, 7)
train$Day <- substring(train$Dates, 9, 10)
train$Hour <- substring(train$Dates, 12, 13)
train$Season <- "Spring"
train[train$Month == "06" | train$Month == "07" | train$Month == "08",]$Season <- "Summer"
train[train$Month == "09" | train$Month == "10" | train$Month == "11",]$Season <- "Fall"
train[train$Month == "12" | train$Month == "01" | train$Month == "02",]$Season <- "Winter"
breaks <- c(0,6,10,14,18,24)/24
labels <- c("EarlyMorning","Morning","Noon","Afternoon","Evening")
library(chron)
train$TimeInDay <- cut(times(substring(train$Dates,12)), breaks, labels, include.lowest = T)
breaks <- c(0,5, 20, 24)/24
labels <- c("Night","Day","Night2")
train$DayNight <- cut(times(substring(train$Dates,12)), breaks, labels, include.lowest = T)
train$DayNight <- gsub("Night2", "Night", train$DayNight)
train <- subset(train, select = -c(Dates))
train$Year <- as.factor(train$Year)
train$Month <- as.factor(train$Month)
train$Day <- as.factor(train$Day)
train$Hour <- as.factor(train$Hour)
train$Season <- as.factor(train$Season)
train$DayNight <- as.factor(train$DayNight)
# rd <- c()
# inte <- c()
# 
# for (i in 1:length(train$Category)){
#   if(length(grep("/", train$Address[i]))>0){
#     rd <- append(rd,0)
#     inte <- append(inte,1)
#   }
#   else{
#     rd <- append(rd,1)
#     inte <- append(inte,0)
#   }
# }
#save(rd, file="road.rda")
#save(inte, file="intersection.rda")
load("road.rda")
load("intersection.rda")
train$Road <- rd
train$Cross <- inte

#sapply(train, class)
#tiny_sample <- train[sample(nrow(train), nrow(train)*0.1),]
#tiny_sample$Year <- as.factor(tiny_sample$Year)
#tiny_sample$Month <- as.factor(tiny_sample$Month)
#tiny_sample$Season <- as.factor(tiny_sample$Season)
#tiny_sample$DayNight <- as.factor(tiny_sample$DayNight)b

# Read test data 
test <- read.csv(file="test.csv", na.strings=c(""))
test <- subset(test, select = -c(Id))
# Prepare test data
test$Year <- substring(test$Dates, 1, 4)
test$Month <- substring(test$Dates, 6, 7)
test$Day <- substring(test$Dates, 9, 10)
test$Hour <- substring(test$Dates, 12, 13)
test$Season <- "Spring"
test[test$Month == "06" | test$Month == "07" | test$Month == "08",]$Season <- "Summer"
test[test$Month == "09" | test$Month == "10" | test$Month == "11",]$Season <- "Fall"
test[test$Month == "12" | test$Month == "01" | test$Month == "02",]$Season <- "Winter"
breaks <- c(0,6,10,14,18,24)/24
labels <- c("EarlyMorning","Morning","Noon","Afternoon","Evening")
library(chron)
test$TimeInDay <- cut(times(substring(test$Dates,12)), breaks, labels, include.lowest = T)
breaks <- c(0,5, 20, 24)/24
labels <- c("Night","Day","Night2")
test$DayNight <- cut(times(substring(test$Dates,12)), breaks, labels, include.lowest = T)
test$DayNight <- gsub("Night2", "Night", test$DayNight)
test <- subset(test, select = -c(Dates, Address))
test$Year <- as.factor(test$Year)
test$Month <- as.factor(test$Month)
test$Day <- as.factor(test$Day)
test$Hour <- as.factor(test$Hour)
test$Season <- as.factor(test$Season)
test$DayNight <- as.factor(test$DayNight)