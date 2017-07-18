# This R environment comes with all of CRAN preinstalled, as well as many other helpful packages
# The environment is defined by the kaggle/rstats docker image: https://github.com/kaggle/docker-rstats
# For example, here's several helpful packages to load in 

library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function

# Input data files are available in the "../input/" directory.
# For example, running this (by clicking run or pressing Shift+Enter) will list the files in the input directory

train <- read.csv(file="train.csv", na.strings=c(""))
train <- subset(train, select = -c(Descript, Resolution))

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
train <- subset(train, select = -c(Dates, Address))

train <- train[!(train$Y>50),]
train$Year <- as.factor(train$Year)
train$Month <- as.factor(train$Month)
train$Day <- as.factor(train$Day)
train$Hour <- as.factor(train$Hour)
train$Season <- as.factor(train$Season)
train$DayNight <- as.factor(train$DayNight)

set.seed(1234)
train_sample <- train[sample(nrow(train), 0.1*nrow(train)),]
train_sample$Year <- as.factor(train_sample$Year)
train_sample$Month <- as.factor(train_sample$Month)
train_sample$Day <- as.factor(train_sample$Day)
train_sample$Hour <- as.factor(train_sample$Hour)
train_sample$Season <- as.factor(train_sample$Season)
train_sample$DayNight <- as.factor(train_sample$DayNight)

#---------------------------------------------------------------------------

library("xgboost")  # the main algorithm
library("archdata") # for the sample dataset
library("caret")    # for the confusionmatrix() function (also needs e1071 package)
library("dplyr")    # for some data preperation

set.seed(717)
cats <- unique(train_one_hot$Category)

train_one_hot$Category <- as.numeric(train_one_hot$Category)
train_one_hot$Category <- train_one_hot$Category - 1
#summary(train)

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

#-------------------------------------------------------------------------

library(party)
set.seed(1234)
train_sample = train_one_hot[sample(nrow(train_one_hot), nrow(train_one_hot)*0.5),] 
fit <- cforest(Category ~., data=train_sample)
save(fit, file="cf_fit.rda")
varImpPlot(fit)
summary(fit)