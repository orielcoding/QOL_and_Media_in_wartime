library(lavaan)
library(readxl)
library(semPlot)
library(lmx)

################################################################################

DATA_FILE_NAME <- "processed_responses.xlsx"

# Get the current working directory
current_dir <- file.path(getwd(), "..")

# Set the results directory relative to the script directory
results_dir <- file.path(current_dir, "CFA_results")

# Create the directory if it doesn't exist
if (!dir.exists(results_dir)) {
  dir.create(results_dir, recursive = TRUE)
}

# access the data file and read it. 
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)

respondents_data <- read_excel(data_file)

results_file <- file.path(results_dir, "CFA_phone.txt")

################################################################################

sink(results_file)

full.model2 <- 'unaware =~ w1 + w2 + w3 + w4 + w5 + w6'

alpha_phone <- cronbach.alpha(na.omit(respondents_data[, c("w1", "w2", "w3", "w4", "w5", "w6")]))

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

