# This R environment comes with all of CRAN preinstalled, as well as many other helpful packages
# The environment is defined by the kaggle/rstats docker image: https://github.com/kaggle/docker-rstats
# For example, here's several helpful packages to load in 

library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function

# Input data files are available in the "../input/" directory.
# For example, running this (by clicking run or pressing Shift+Enter) will list the files in the input directory


# Any results you write to the current directory are saved as output.
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

train_one_hot <- subset(train, select = -Address)

temp_mat <- data.frame(with(data.frame(DayOfWeek=train$DayOfWeek), model.matrix(~DayOfWeek+0)))
names(temp_mat) <- sort(unique(train$DayOfWeek))
train_one_hot <- cbind(subset(train_one_hot, select=-DayOfWeek), temp_mat)

temp_mat <- data.frame(with(data.frame(PdDistrict=train$PdDistrict), model.matrix(~PdDistrict+0)))
names(temp_mat) <- sort(unique(train$PdDistrict))
train_one_hot <- cbind(subset(train_one_hot, select=-PdDistrict), temp_mat)

temp_mat <- data.frame(with(data.frame(Year=train$Year), model.matrix(~Year+0)))
#names(temp_mat) <- sort(unique(as.character(train$Year)))
train_one_hot <- cbind(subset(train_one_hot, select=-Year), temp_mat)

temp_mat <- data.frame(with(data.frame(Month=train$Month), model.matrix(~Month+0)))
#names(temp_mat) <- sort(unique(train$Month))
train_one_hot <- cbind(subset(train_one_hot, select=-Month), temp_mat)

temp_mat <- data.frame(with(data.frame(Day=train$Day), model.matrix(~Day+0)))
#names(temp_mat) <- sort(unique(train$Day))
train_one_hot <- cbind(subset(train_one_hot, select=-Day), temp_mat)

temp_mat <- data.frame(with(data.frame(Hour=train$Hour), model.matrix(~Hour+0)))
#names(temp_mat) <- sort(unique(train$Hour))
train_one_hot <- cbind(subset(train_one_hot, select=-Hour), temp_mat)

temp_mat <- data.frame(with(data.frame(Season=train$Season), model.matrix(~Season+0)))
names(temp_mat) <- sort(unique(train$Season))
train_one_hot <- cbind(subset(train_one_hot, select=-Season), temp_mat)

temp_mat <- data.frame(with(data.frame(TimeInDay=train$TimeInDay), model.matrix(~TimeInDay+0)))
names(temp_mat) <- sort(unique(train$TimeInDay))
train_one_hot <- cbind(subset(train_one_hot, select=-TimeInDay), temp_mat)

temp_mat <- data.frame(with(data.frame(DayNight=train$DayNight), model.matrix(~DayNight+0)))
names(temp_mat) <- sort(unique(train$DayNight))
train_one_hot <- cbind(subset(train_one_hot, select=-DayNight), temp_mat)

set.seed(1234)
train_sample <- train_one_hot[sample(sample(nrow(train_one_hot), nrow(train_one_hot)*0.3)),]

library(party)
library(randomForest)
set.seed(1234)
fit <- randomForest(Category ~ .,
                    data = train_sample,
                    importance = TRUE,
                    ntree=300)
varImpPlot(fit)
summary(fit)
save(fit, file="rf_one-hot_huge.rda")

load("test_one_hot.rda")
colnames(test_one_hot)[colnames(test_one_hot)=="2003"] <- "Year2003"
colnames(test_one_hot)[colnames(test_one_hot)=="2004"] <- "Year2004"
colnames(test_one_hot)[colnames(test_one_hot)=="2005"] <- "Year2005"
colnames(test_one_hot)[colnames(test_one_hot)=="2006"] <- "Year2006"
colnames(test_one_hot)[colnames(test_one_hot)=="2007"] <- "Year2007"
colnames(test_one_hot)[colnames(test_one_hot)=="2008"] <- "Year2008"
colnames(test_one_hot)[colnames(test_one_hot)=="2009"] <- "Year2009"
colnames(test_one_hot)[colnames(test_one_hot)=="2010"] <- "Year2010"
colnames(test_one_hot)[colnames(test_one_hot)=="2011"] <- "Year2011"
colnames(test_one_hot)[colnames(test_one_hot)=="2012"] <- "Year2012"
colnames(test_one_hot)[colnames(test_one_hot)=="2013"] <- "Year2013"
colnames(test_one_hot)[colnames(test_one_hot)=="2014"] <- "Year2014"
colnames(test_one_hot)[colnames(test_one_hot)=="2015"] <- "Year2015"
prd <- predict(fit, test_one_hot, type="prob")
save(prd, file="rf_one-hot_pred_large.rda")
prd_df <- as.data.frame(prd)
id <- data.frame(Id=seq.int(from=0, to=nrow(test)-1))
submit <- cbind(id, prd_df)
write.csv(submit, "RF_one_hot_large.csv")
