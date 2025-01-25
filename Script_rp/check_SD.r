# Load necessary libraries
library(DESeq2)
library(tidyr)

# Get command-line arguments
args <- commandArgs(trailingOnly = TRUE)


# Read file paths from arguments
input.count.matrix <- args[1]
input.study.design <- args[2]

# Input and open the files
data.matrix <- read.csv(file = input.count.matrix, header = TRUE, sep = ",", row.names = "Name", stringsAsFactors = FALSE)
study.design.matrix <- read.csv(input.study.design, header = TRUE)

# Find matching indices
reorder_idx <- match(colnames(data.matrix), study.design.matrix$samplename)


if (is.na(reorder_idx)) {
  stop("Error: Missing columns in the study design matrix. Please ensure all required columns are present.")
} else {

# Write the data frame to a CSV file
write.csv(data.frame(study.design.matrix), 
          file = "go_next_SD_accepted.csv",
          row.names = FALSE) # Exclude row names in the CSV
}