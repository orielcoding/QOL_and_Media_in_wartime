#library(dplyr)
library(lavaan)
library(semPlot)
library(readxl)

################################################################################

DATA_FILE_NAME <- "processed_responses.xlsx"

# Get the current working directory
current_dir <- file.path(getwd(), "..")

# Set the results directory relative to the script directory
results_dir <- file.path(current_dir, "SEM_results")

# Create the directory if it doesn't exist
if (!dir.exists(results_dir)) {
  dir.create(results_dir, recursive = TRUE)
}

# access the data file and read it. 
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)

respondents_data <- read_excel(data_file)

results_file <- file.path(results_dir, "basic_qol_resilience_media_stress.txt")

################################################################################

# Sink command before and after the code for saving results in results file.
sink(results_file)

# Construct the extended latent factor model
full.model2 <- paste(
  "qol =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y12 + y13 + y14 + y15 + y16 + y17 + y18 + y19;",
  "resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10;",
  "media =~ x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10 + x11 + x12 + x13 + x14 + x15 + x16 + x17;",
  "stress =~ u1 + u2 + u3 + u4 + u5 + u6 + u7 + u8 + u9;",
  
  # relations direction - SEM 
  "qol ~ resilience;",
  "qol ~ media;",
  "qol ~ stress;",
  "media ~ resilience;",
  "media ~ stress;",
  "resilience ~ stress",

  sep = "\n"
)

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = FALSE, edge.label.cex = 1, what = 'std', structural = TRUE)

