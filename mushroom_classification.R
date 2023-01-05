library(stringr)
library(purrr)
library(ggplot2)
library(caret)
library(randomForest)

# Read the data and make it in the form of a Dataframe. 
d1 = read.csv("secondary_data_no_miss.csv")

colnames(d1)[1] = "col1"

t <- str_split(d1$col1, ";")
data <- do.call(rbind, t)

colnames(data) <- c('class','cap-diameter','cap-shape','cap-surface',
                    'cap-color','does-bruise-or-bleed','gill-attachment',
                    'gill-spacing','gill-color','stem-height','stem-width',
                    'stem-color','has-ring','ring-type','habitat','season')
data = data.frame(data)

# Change the variables to become factors or integers. 
sapply(data, class)

cols.num = c("cap.diameter","stem.height","stem.width")
data[cols.num] = sapply(data[cols.num],as.numeric)

data[sapply(data, is.character)] <- lapply(data[sapply(data, is.character)], 
                                           as.factor)
levels(data$class) <- c("edible", "poisonous")
str(data)

# Verify if the data has missing values:
map_dbl(data, function(.x) {sum(is.na(.x))})

# Visualize the data
table(data$class)

dataVis <- function(data, x, y, col) {
  x <- rlang::sym(x)
  y <- rlang::sym(y)
  col <- rlang::sym(col)
  
  ggplot(data = data, aes(x = !!x , y = !!y , col = !!col)) + 
    geom_jitter(alpha = 0.5) + 
    scale_color_manual(values = c("green", "red"))
}

set.seed(1)
dataVis(data = data, x = 'cap.surface', y = 'cap.color', col = 'class')

dataVis(data = data, x = 'gill.color', y = 'cap.color', col = 'class')

# Data Splitting 
set.seed(1023)
trainsamples <- createDataPartition(y = data$class, p = 0.7, list = FALSE)
train_mushroom <- data[ trainsamples, ]
test_mushroom  <- data[-trainsamples, ]

# Random Forest Model on the training data. 
rf = randomForest(class ~ .,  
                  ntree = 100,
                  data = train_mushroom)
print(rf)

# Variable importance
varImpPlot(rf,  
           sort = T,
           main = "Variable Importance")

var.imp = data.frame(importance(rf, type=2))

# make row names as columns
var.imp$Variables = row.names(var.imp)  
print(var.imp[order(var.imp$MeanDecreaseGini,decreasing = T),])

# Save the accuracy result to a txt file. 
sink(file = "mushroom_classification_accuracy.txt")

# Compute the test performance. 
test_mushroom$predicted.response = predict(rf , test_mushroom)

test_mushroom$predicted.response <- as.factor(test_mushroom$predicted.response)

print(confusionMatrix(data = test_mushroom$predicted.response,  
                      reference = test_mushroom$class,
                      positive = 'edible'))

sink()
