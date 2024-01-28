# Load necessary libraries
library(dplyr)
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

results_file <- file.path(results_dir, "SEM_media_to_qol.txt")

################################################################################

sink(results_file)

# Read the loadings and their mappings
qol_loadings <- read.csv(file.path(current_dir, "..", "loadings/QOL_loadings.csv"), stringsAsFactors = FALSE)
y_mapping <- read.csv(file.path(current_dir, "..", "items_maps/y_mapping.csv"), stringsAsFactors = FALSE)

media_loadings <- read.csv(file.path(current_dir, "..", "loadings/media_3_factor_loadings.csv"), stringsAsFactors = FALSE)
x_mapping <- read.csv(file.path(current_dir, "..", "items_maps/x_mapping.csv"), stringsAsFactors = FALSE)

# Function to find the row indices where each factor has the maximum value
get_max_indices_per_factor <- function(df) {
  apply(df, 1, function(x) which(x == max(x)))
}

# Function to find the row indices where each factor takes items above threshold
get_indices_above_threshold <- function(df, threshold = 0.3) {
  # Create a list to store indices for each factor
  factor_indices_list <- vector("list", ncol(df))
  names(factor_indices_list) <- colnames(df)
  
  for (factor in seq_along(factor_indices_list)) {
    factor_indices_list[[factor]] <- which(abs(df[, factor]) >= threshold)
  }
  
  return(factor_indices_list)
}

# Apply the function to the relevant part of qol_loadings
#qol_max_indices <- get_max_indices_per_factor(qol_loadings[, c("Factor1", "Factor2", "Factor3")])
qol_threshold_indices <- get_indices_above_threshold(qol_loadings[, c("Factor1", "Factor2", "Factor3")], 0.3)
#media_max_indices <- get_max_indices_per_factor(media_loadings[, c("Factor1", "Factor2", "Factor3")])
media_threshold_indices <- get_indices_above_threshold(media_loadings[, c("Factor1", "Factor2", "Factor3")], 0.3)


# Create lists for each factor
#QOL1_indices <- which(qol_max_indices == 1)
#QOL2_indices <- which(qol_max_indices == 2)
#QOL3_indices <- which(qol_max_indices == 3)
QOL1_indices <- qol_threshold_indices[["Factor1"]]
QOL2_indices <- qol_threshold_indices[["Factor2"]]
QOL3_indices <- qol_threshold_indices[["Factor3"]]

#media1_indices <- which(media_max_indices == 1)
#media2_indices <- which(media_max_indices == 2)
#media3_indices <- which(media_max_indices == 3)
media1_indices <- media_threshold_indices[["Factor1"]]
media2_indices <- media_threshold_indices[["Factor2"]]
media3_indices <- media_threshold_indices[["Factor3"]]

# Map indices to letter (y,x ...) variables
map_indices <- function(indices, mapping_df) {
  mapping_df$Variable[indices]
}

qol1_y <- map_indices(QOL1_indices, y_mapping)
qol2_y <- map_indices(QOL2_indices, y_mapping)
qol3_y <- map_indices(QOL3_indices, y_mapping)

media1_x <- map_indices(media1_indices, x_mapping)
media2_x <- map_indices(media2_indices, x_mapping)
media3_x <- map_indices(media3_indices, x_mapping)

# Construct the extended latent factor model
full.model2 <- paste(
  "competence =~", paste(qol1_y, collapse = " + "), ";",
  "functioning =~", paste(qol2_y, collapse = " + "), ";",
  "positive_feeling =~", paste(qol3_y, collapse = " + "), ";",
  "qol =~ competence + functioning + positive_feeling;",
  
  "resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10;",
  
  "stress =~ u1 + u2 + u3 + u4 + u5 + u6 + u7 + u8 + u9;",
  
  "media_factor1 =~", paste(media1_x, collapse = " + "), ";",
  "media_factor2 =~", paste(media2_x, collapse = " + "), ";",
  "media_factor3 =~", paste(media3_x, collapse = " + "), ";",
  "media =~ media_factor1 + media_factor2 + media_factor3;",
  
  # Edit
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

