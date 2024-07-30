## myAPI.R file
library(plumber)
library(tidyverse)
library(caret)

# Read in the data we are using for our model
diabetes <- read.csv("diabetes_binary_health_indicators_BRFSS2015.csv", header = T)

# Convert binary predictors and response variable to factor variables (Not converting BMI)
diabetes_tib <- as_tibble(diabetes) |>
  mutate(Diabetes_binary = as.factor(Diabetes_binary),
         HighBP = as.factor(HighBP),
         HighChol = as.factor(HighChol),
         Smoker = as.factor(Smoker),
         PhysActivity = as.factor(PhysActivity),
         Fruits = as.factor(Fruits),
         Veggies = as.factor(Veggies),
         GenHlth = as.factor(GenHlth),
         DiffWalk = as.factor(DiffWalk),
         Sex = as.factor(Sex),
         Age = as.factor(Age))


# Give all of the factor variables meaningful level names
levels(diabetes_tib$Diabetes_binary) <- c("No_Diabetes","Diabetes")
levels(diabetes_tib$HighBP) <- c("Normal_BP", "High_BP")
levels(diabetes_tib$HighChol) <- c("Normal_Chol_Levels","High_Chol_Levels")
levels(diabetes_tib$Smoker) <- c("Non-Smoker","Smoker")
levels(diabetes_tib$PhysActivity) <- c("Not_Active", "Active")
levels(diabetes_tib$Fruits) <- c("No_Fruits_in_Diet","Fruits_in_Diet")
levels(diabetes_tib$Veggies) <- c("No_Veggies_in_Diet","Veggies_in_Diet")
levels(diabetes_tib$GenHlth) <- c("Excellent", "Very Good", "Good", "Fair", "Poor")
levels(diabetes_tib$DiffWalk) <- c("No_Difficulty_with_Stairs","Difficulty_with_Stairs")
levels(diabetes_tib$Sex) <- c("Female", "Male")
levels(diabetes_tib$Age) <- c("18-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80+")

# Create a final dataset that includes only the variables we will be using in our analysis
diabetes_final <- diabetes_tib |>
  dplyr::select(- c(CholCheck, Stroke, HeartDiseaseorAttack, HvyAlcoholConsump, MentHlth, PhysHlth, AnyHealthcare, NoDocbcCost, Education, Income))

# Specify the resampling scheme to be used the best model code
train_ctrl <- trainControl(method = "cv", 
                           number = 3, 
                           classProbs = TRUE, 
                           summaryFunction = mnLogLoss,
                           verboseIter = T)

# Code for the best model copied here
best_model <- train(make.names(Diabetes_binary) ~ ., 
                               data = training, 
                               method = "glm",
                               trControl = train_ctrl, 
                               metric = "logLoss")

# Access summary data from the API with the pred endpoint
#* @param pred_list List of predictor variables to summarize (HighBP, HighChol, BMI, Smoker, PhysActivity, Fruits, Veggies, GenHlth, DiffWalk, Sex, Age - Separate with comma)
#* @get / pred
function(pred_list){
  # Collect all arguments into a list
  var_list <- list(pred_list)
  
  # Initialize an empty list to store results
  results <- list()
  
  # Iterate through each variable in the list with a for
  for (i in seq_along(var_list)) {
    var <- var_list[[i]]
    
    if (is.numeric(var)) {
      # Calculate the average of numeric variables
      result <- mean(var, na.rm = TRUE)
    } else if (is.factor(var) || is.character(var)) {
      # Find the most frequent value for categorical variables
      freq_table <- table(var)
      most_frequent_value <- names(freq_table)[which.max(freq_table)]
      result <- most_frequent_value
    } else {
      result <- NA
    }
    
    # Store the result
    results[[paste0(var)]] <- result
  }
  
  return(results)
}


#http://localhost:PORT/pred?pred_list=HighBP,BMI
#http://localhost:PORT/pred?pred_list=HighChol
#http://localhost:PORT/pred?pred_list=


# Display name and link to GitHub pages from the API with the info endpoint
#* @get / info
function(){
  "AUTHOR: Trevor Lynch"
  "URL FOR GITHUB PAGES: ___"
}

#http://localhost:8000/info
