## myAPI.R file
library(plumber)

# Read in the data we are using for our model
load("diabetes_final")

best_model <- train(make.names(Diabetes_binary) ~ ., 
                               data = training, 
                               method = "glm",
                               trControl = train_ctrl, 
                               metric = "logLoss")

# Access summary data from the API with the pred endpoint
#* @param pred_list list of predictor variables to summarize (separate with comma)
#* @get / pred
function(pred_list){
  # Collect all arguments into a list
  var_list <- list(pred_list)
  
  # Initialize an empty list to store results
  results <- list()
  
  # Process each variable in the list
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
      warning(paste("Skipping unsupported type in variable", i, ":", class(var)))
      result <- NA
    }
    
    # Store the result
    results[[paste("Predictor", i)]] <- result
  }
  
  return(results)
}


#http://localhost:8000/pred?pred_list=
#http://localhost:8000/pred?pred_list=
#http://localhost:8000/pred?pred_list=


# Display name and link to GitHub pages from the API with the info endpoint
#* @get / info
function(){
  "AUTHOR: Trevor Lynch"
  "URL FOR GITHUB PAGES: ___"
}

#http://localhost:8000/info
