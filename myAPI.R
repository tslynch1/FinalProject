## myAPI.R file
library(GGally)
library(plumber)

# Read in the data we are using for our model
load("diabetes_final")

best_model <- train(make.names(Diabetes_binary) ~ Smoker + PhysActivity + Fruits + Veggies + DiffWalk + Sex + Age, 
                    data = training, 
                    method = "rpart",
                    trControl = train_ctrl, 
                    metric = "logLoss",
                    tuneGrid = data.frame(cp = seq(0.00001, 0.01001, by = 0.0001)))


# Access data from the API with the -pred- and -info- endpoints
#* @param pred list of predictor variables 
#* @param info information on author and website
#* @get / model
function(pred, info){
  if (info = TRUE) {
    paste0("Name: Trevor Lynch")
    paste0("____________________INSERT URL FOR RENDERED GITHUB PAGES SITE HERE________________________")
  }
  else {
    
  }
}

#http://localhost:PORT/model?pred=-------&info=T
#http://localhost:PORT/model?pred=-------&info=F
#http://localhost:PORT/model?info=T

