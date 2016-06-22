# Checking for data.

if(!file.exists("./data/train.csv")){
    print("not all files present, please refer to the kaggle site for the data.")
    browseURL("https://www.kaggle.com/c/integer-sequence-learning/data")
    
} else if(!file.exists("./data/train.csv") & file.exists("./data/train.csv.zip")) {
    print("unzipping file...")
    unzip("./data/test.csv.zip", exdir = "./data")
    unzip("./data/train.csv.zip", exdir = "./data")
    unzip("./data/sample_submission.csv.zip", exdir = "./data")
} else {
    print("reading in data...")
    test.data <- read.csv("./data/test.csv")
    train.data <- read.csv("./data/train.csv")
    sample.submission <- read.csv("./data/sample_submission.csv")
}

# Dependencies.
library(dplyr)
library(stringr)
library(readr)
library(doSNOW)
library(foreach)

# Setting multiple cores for parallel calculations.
cl <- makeCluster(4) # Change to amount of cores to be used.
registerDoSNOW(cl)

# Setting seed and options.
set.seed(20062016)
options(scipen = 999)


# Function for splitting strings in a list. 
ParseSequence <- function(str) {
    return(as.numeric(str_split(str, ",")[[1]]))
}

Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
}


x <- train.data %>%
    rowwise() %>%
    mutate(new_row = Mode(ParseSequence(Sequence))) %>%
    select(Id, new_row)

stopCluster(cl) #shutting down de clusters
