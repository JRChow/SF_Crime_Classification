# Naive Bayes
load("nb_fit.rda")
load("nb_pred.rda")

pred <- data.frame(Category = nb_pred)
pred_mat <- data.frame(with(pred, model.matrix(~Category+0)))
names(pred_mat) <- sort(unique(train$Category))
id_mat <- data.frame(Id = seq.int(from=0, to=nrow(test)-1))
submit <- cbind(id_mat, pred_mat)
write.csv(submit, "NB.csv")
