train_one_hot <- subset(train, select = -Address)

temp_mat <- data.frame(with(data.frame(DayOfWeek=train$DayOfWeek), model.matrix(~DayOfWeek+0)))
names(temp_mat) <- sort(unique(train$DayOfWeek))
train_one_hot <- cbind(subset(train_one_hot, select=-DayOfWeek), temp_mat)

temp_mat <- data.frame(with(data.frame(PdDistrict=train$PdDistrict), model.matrix(~PdDistrict+0)))
names(temp_mat) <- sort(unique(train$PdDistrict))
train_one_hot <- cbind(subset(train_one_hot, select=-PdDistrict), temp_mat)

temp_mat <- data.frame(with(data.frame(Year=train$Year), model.matrix(~Year+0)))
names(temp_mat) <- sort(unique(train$Year))
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
