# Set working directory
setwd("~/Desktop/INFO201/NFL-Project-Proposal/scripts")

# Source GetSummaryInformation.R script to expose GetSummaryInformation function
source('./scripts/GetSummaryInformation')

# A function that takes in a dataset and returns a list of information about the dataset
GetSummaryInformation <- function(data) {
  info <- list()
  info$length <- length(data)
  info$numrows <- nrow(data)
  info$numcols <- ncol(data)
  info$colnames <- colnames(data)
  info$dim <- dim(data)
}