library(lavaan)
library(readxl)
library(semPlot)

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

results_file <- file.path(results_dir, "CFA_qol.txt")

################################################################################

# To save all results
sink(results_file)

# Read the loadings and their mappings
qol_loadings <- read.csv(file.path(current_dir, "..", "loadings/QOL_loadings.csv"), stringsAsFactors = FALSE)
y_mapping <- read.csv(file.path(current_dir, "..", "items_maps/y_mapping.csv"), stringsAsFactors = FALSE)

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

qol_max_indices <- get_max_indices_per_factor(qol_loadings[, c("Factor1", "Factor2", "Factor3")])
qol_threshold_indices <- get_indices_above_threshold(qol_loadings[, c("Factor1", "Factor2", "Factor3")], 0.3)

# Create lists for each factor
#QOL1_indices <- which(qol_max_indices == 1)
#QOL2_indices <- which(qol_max_indices == 2)
#QOL3_indices <- which(qol_max_indices == 3)
QOL1_indices <- qol_threshold_indices[["Factor1"]]
QOL2_indices <- qol_threshold_indices[["Factor2"]]
QOL3_indices <- qol_threshold_indices[["Factor3"]]

# Map indices to letter (y,x ...) variables
map_indices <- function(indices, mapping_df) {
  mapping_df$Variable[indices]
}

qol1_y <- map_indices(QOL1_indices, y_mapping)
qol2_y <- map_indices(QOL2_indices, y_mapping)
qol3_y <- map_indices(QOL3_indices, y_mapping)


full.model2 <- paste(
  "qol1 =~", paste(qol1_y, collapse = " + "), ";",
  "qol2 =~", paste(qol2_y, collapse = " + "), ";",
  "qol3 =~", paste(qol3_y, collapse = " + "), ";",
  "qol =~ qol1 + qol2 + qol3;",
   sep = "\n"
)


full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)
