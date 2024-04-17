library(lavaan)
library(readxl)
library(semPlot)
library(ltm)

################################################################################

DATA_FILE_NAME <- "processed_responses.xlsx"

# Get the current working directory
current_dir <- file.path(getwd(), "..")


# access the data file and read it. 
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)

respondents_data <- read_excel(data_file)


###############################################################################
###### Single factor


full.model2 <- 'stress =~ u1 + u2 + u3 + u4 + u5 + u6 + u7 + u8 + u9'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)
semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

alpha_stress <- cronbach.alpha(na.omit(respondents_data[, c("u1", "u2", "u3", "u4", "u5", "u6", "u7", "u8", "u9")]))

################################################################################
###### two factor


full.model2 <- 'stress =~ u1 + u2 + u3
                stress2 =~ u4 + u5 + u6 + u7 + u8 + u9'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

################################################################################
###### three factor

full.model2 <- 'stress =~ u1 + u2 + u3
                stress2 =~ u4  + u6
                stress3 =~ u5 + u7 + u8 + u9'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)


################################################################################
###### support - bad 

full.model2 <- 'support =~ v1 + v2 + v3 + v4'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)


################################################################################
###### support - bad 

full.model2 <- 'support =~ v1 + v2 + v3 + v4'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

################################################################################
#names(respondents_data)
