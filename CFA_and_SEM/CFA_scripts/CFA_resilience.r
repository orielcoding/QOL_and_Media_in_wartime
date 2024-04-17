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

results_file <- file.path(results_dir, "CFA_reslience.txt")

################################################################################

sink(results_file)

full.model2 <- 'resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
#z1 ~~ z8                
'

alpha_resilience <- psych::alpha(na.omit(respondents_data[, c("z1", "z2", "z3", "z4", "z5", "z6", "z7", "z8", "z9", "z10")]))

full.fit2 <- cfa(full.model2, data = respondents_data)
modindices(full.fit2, sort = TRUE, maximum.number = 5)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE, ci = TRUE)

# Save the results to the output file
sink()

###############################################################################
###################### better, parcel z3 and z9. 
sink(results_file)

# Create a new item z11 as the average of z3 and z9
respondents_data$z11 <- rowMeans(respondents_data[, c("z3", "z9")], na.rm = TRUE)

# Update the CFA model to use z11 instead of z3 and z9
full.model2 <- '
resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
'

# Update the items for the reliability analysis excluding z3 and z9, including z11
#alpha_resilience <- psych::alpha(na.omit(respondents_data[, c("z1", "z2", "z4", "z5", "z6", "z7", "z8", "z10", "z11")]))

# Run the CFA with the updated model
full.fit2 <- cfa(full.model2, data = respondents_data)

# Display the summary with standardized results and fit measures
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

sink()

semPaths(full.fit2, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)

###############################################################################
######################### bad!!!!!!!! parcel z4 and z9. 
sink(results_file)

# Create a new item z11 as the average of z4 and z9
respondents_data$z11 <- rowMeans(respondents_data[, c("z4", "z9")], na.rm = TRUE)

# Update the CFA model to use z11 instead of z3 and z9
full.model2 <- '
resilience =~ z1 + z2 + z3 + z5 + z6 + z7 + z8 + z10 + z11
'

# Update the items for the reliability analysis excluding z3 and z9, including z11
#alpha_resilience <- psych::alpha(na.omit(respondents_data[, c("z1", "z2", "z3", "z5", "z6", "z7", "z8", "z10", "z11")]))

# Run the CFA with the updated model
full.fit2 <- cfa(full.model2, data = respondents_data)

# Display the summary with standardized results and fit measures
summary(full.fit2, standardized = TRUE, fit.measures = FALSE)

sink()

semPaths(full.fit2, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)
