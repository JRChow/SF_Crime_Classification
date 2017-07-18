# Multinomial Logistic regression.

# Perform regression
library(nnet)
mlr <- multinom(Category ~ ., data = train, MaxNWts=877983)
save(mlr, file="mlr.rda")
summary(mlr)
load("mlr.rda")
pred <- predict(mlr, newdata=test)

result <- as.data.frame(matrix(0, ncol=40,nrow=nrow(test)))
names(result) <- c("Id", sort(as.character(unique(train$Category))))
result[,"Id"] <- seq.int(from=0, to=nrow(test)-1)
for (i in 1:length(pred)) {
  result[i,as.character(pred[i])] <- 1
}
write.csv(result, file="mlr_result.csv")