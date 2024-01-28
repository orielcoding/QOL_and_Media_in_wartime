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

################################################################################

# Read the loadings and their mappings
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

# Map indices to letter (y,x ...) variables
map_indices <- function(indices, mapping_df) {
  mapping_df$Variable[indices]
}

######################

results_file <- file.path(results_dir, "SEM_media_3_factors.txt")

# To save all results
sink(results_file)

media_loadings <- read.csv(file.path(current_dir, "..", "loadings/media_3_factor_loadings.csv"), stringsAsFactors = FALSE)

#media_max_indices <- get_max_indices_per_factor(media_loadings[, c("Factor1", "Factor2", "Factor3")])
media_threshold_indices <- get_indices_above_threshold(media_loadings[, c("Factor1", "Factor2", "Factor3")], 0.3)

# Create lists for each factor
#media1_indices <- which(media_max_indices == 1)
#media2_indices <- which(media_max_indices == 2)
#media3_indices <- which(media_max_indices == 3)
media1_indices <- media_threshold_indices[["Factor1"]]
media2_indices <- media_threshold_indices[["Factor2"]]
media3_indices <- media_threshold_indices[["Factor3"]]

media1_x <- map_indices(media1_indices, x_mapping)
media2_x <- map_indices(media2_indices, x_mapping)
media3_x <- map_indices(media3_indices, x_mapping)


full.model2 <- paste(
  "media1 =~", paste(media1_x, collapse = " + "), ";",
  "media2 =~", paste(media2_x, collapse = " + "), ";",
  "media3 =~", paste(media3_x, collapse = " + "), ";",
  
   sep = "\n"
)

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)


########################

results_file <- file.path(results_dir, "SEM_media_4_factors.txt")

# To save all results
sink(results_file)

media_loadings <- read.csv(file.path(current_dir, "..", "loadings/media_4_factor_loadings.csv"), stringsAsFactors = FALSE)

#media_max_indices <- get_max_indices_per_factor(media_loadings[, c("Factor1", "Factor2", "Factor3", "Factor4")])
media_threshold_indices <- get_indices_above_threshold(media_loadings[, c("Factor1", "Factor2", "Factor3", "Factor4")], 0.3)

# Create lists for each factor
#media1_indices <- which(media_max_indices == 1)
#media2_indices <- which(media_max_indices == 2)
#media3_indices <- which(media_max_indices == 3)
#media4_indices <- which(media_max_indices == 4)
media1_indices <- media_threshold_indices[["Factor1"]]
media2_indices <- media_threshold_indices[["Factor2"]]
media3_indices <- media_threshold_indices[["Factor3"]]
media4_indices <- media_threshold_indices[["Factor4"]]

media1_x <- map_indices(media1_indices, x_mapping)
media2_x <- map_indices(media2_indices, x_mapping)
media3_x <- map_indices(media3_indices, x_mapping)
media4_x <- map_indices(media4_indices, x_mapping)


full.model2 <- paste(
  "media1 =~", paste(media1_x, collapse = " + "), ";",
  "media2 =~", paste(media2_x, collapse = " + "), ";",
  "media3 =~", paste(media3_x, collapse = " + "), ";",
  "media4 =~", paste(media4_x, collapse = " + "),
  
  sep = "\n"
)

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)


########################

results_file <- file.path(results_dir, "SEM_media_2_factors.txt")

# To save all results
sink(results_file)

media_loadings <- read.csv(file.path(current_dir, "..", "loadings/media_2_factor_loadings.csv"), stringsAsFactors = FALSE)
#media_max_indices <- get_max_indices_per_factor(media_loadings[, c("Factor1", "Factor2")])
media_threshold_indices <- get_indices_above_threshold(media_loadings[, c("Factor1", "Factor2")], 0.3)

# Create lists for each factor
#media1_indices <- which(media_max_indices == 1)
#media2_indices <- which(media_max_indices == 2)
media1_indices <- media_threshold_indices[["Factor1"]]
media2_indices <- media_threshold_indices[["Factor2"]]

media1_x <- map_indices(media1_indices, x_mapping)
media2_x <- map_indices(media2_indices, x_mapping)


full.model2 <- paste(
  "media1 =~", paste(media1_x, collapse = " + "), ";",
  "media2 =~", paste(media2_x, collapse = " + "),
  
  sep = "\n"
)

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)


########################
