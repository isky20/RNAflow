# Load necessary libraries
library(DESeq2)
library(tidyr)

# Get command-line arguments
args <- commandArgs(trailingOnly = TRUE)



# Read file paths from arguments
input.count.matrix <- args[2]
input.study.design <- args[1]
output.directory <- args[3]

# Input and open the files
data.matrix <- read.csv(file = input.count.matrix, header = TRUE, sep = ",", row.names = "Name", stringsAsFactors = FALSE)
study.design.matrix <- read.csv(input.study.design, header = TRUE, row.names = "samplename")


# Clean count data and study design
data.matrix <- na.omit(data.matrix) # Remove NA values
data.matrix <- round(data.matrix, 0) # Convert float to int
study.design.matrix <- study.design.matrix[order(rownames(study.design.matrix)), ]

# Loop through study design columns for differential expression analysis
for (i in colnames(study.design.matrix)) {
  formula <- as.formula(paste("~", i))  # Dynamically create the formula
  # Create a DESeq2 object
  DE.object <- DESeqDataSetFromMatrix(
    countData = data.matrix,
    colData = study.design.matrix,
    design = formula
  )
  # Determine the size factors for normalization
  DE.object <- estimateSizeFactors(DE.object)
  DE.object <- DESeq(DE.object)
  # Extract results for differential expression
  results <- results(DE.object)
  
  # Get case1 vs case2 name
  opposite_level <- levels(colData(DE.object)[[i]])[2]
  ref_level <- levels(colData(DE.object)[[i]])[1]
  res_filtered <- results[!is.na(results$padj) & results$padj <= 0.05, ]
  
  # Save results
  if (nrow(res_filtered) == 0) {
    # No significant results
    message <- paste("No significant results between", opposite_level, "and", ref_level)
    write.csv(data.frame(Message = message), 
              file.path(output.directory, paste0("no_significant_results_", i, ".csv")))  } else {
    # Add regulation column
    res_filtered$regulation <- ifelse(
      res_filtered$log2FoldChange > 0,
      paste("upregulated", opposite_level, "Vs.", ref_level),
      paste("downregulated", opposite_level, "Vs.", ref_level)
    )
    # Save the results to a CSV file
    write.csv(res_filtered, 
              file.path(output.directory, paste0("significant_results_", i, "_", opposite_level, "Vs", ref_level, ".csv")))
  
  }
}
