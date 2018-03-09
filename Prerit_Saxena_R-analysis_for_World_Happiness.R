library(RODBC)

#List all your ODBC connections
odbcDataSources(type = c("all", "user", "system"))

#Create connection - Note if you leave uid and pwd blank it works with your existing Windows credentials
Local <- odbcConnect("Example", uid = "", pwd = "")

#Query a database (select statement)
combined2 <- sqlQuery(Local, "SELECT * FROM DM_Project.dbo.combined2")

# Generating summary statistics
  
str(combined2)
summary(combined2)

# checking correlation

cor(combined2[,c(5:12)])
plot(combined2[,c(5:12)])

# Exploring some trends through graphs

boxplot(combined2$Happy_score~combined2$Region, col=rainbow(length(unique(combined2$Region))), cex.axis=0.5)

scatterplot(combined2$Happy_score, combined2$Economy)

scatterplot(combined2$Happy_score, combined2$Health)

scatterplot(combined2$Freedom, combined2$Generosity)

scatterplot(combined2$Economy, combined2$Trust)

# We can observe that happiness score is correlated to Economy, Family
# Health and Freedom to a larger extent and others to a lower extent

# Lets explore this through linear regression

# Preparing dataset for linear regression

datafile <- combined2[,c(5:12)]
str(datafile)

# Spliting into training and testing

library(caTools)
set.seed(123)

spl <- sample.split(datafile, 0.7)
train <- subset(datafile, spl==TRUE)
test <- subset(datafile, spl==FALSE)

# Training the model

model1 <- lm(Happy_score~.,data=train)
summary(model1)
plot(model1)

library(car)

# Checking if there is multicolliearity in the regressors

vif(model1)

# Predicting on test dataset

predictions <- predict(model1, test)

mse <- (sum(test$Happy_score-predictions)^2)/nrow(test)
mse

# Predictions are very good

# Checking for clusters in raw data

library(ggplot2)
ggplot(combined2, aes(Happy_rank,Happy_score, color = Region)) + geom_point()

set.seed(123)
happy_Cluster <- kmeans(combined2[, 5:12], centers = 10, iter.max = 100, nstart = 20)
happy_Cluster

happy_Cluster$size

data_with_cluster <- data.frame(combined2$Region, happy_Cluster$cluster)
data_with_cluster

summary(data_with_cluster)

boxplot(data_with_cluster$happy_Cluster.cluster~combined2$Region, col=rainbow(length(unique(combined2$Region))), cex.axis=0.5)

# Proves the hypothesis that clusters actually denote regions and there is an impact of regions in defining happiness score
# Also, we can see there are a few outliers in each region which can be identified easily

# Writing the file out in CSV

write.csv(combined2,"combined2.csv", row.names = FALSE)
