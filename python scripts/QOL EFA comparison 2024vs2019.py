import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from FactorAnalysis import rename_dataframe_from_excel
from EDA import reverse_hebrew_text


# in this script i will create heatmap compares the delta between qol loadings from this and the previous study
def main():
    # fetch loadings of both studies
    qol_loadings = pd.read_csv("C:/Users/bug32/Desktop/Media and Resilience/loadings/QOL_loadings.csv", index_col=0)
    previous_qol_loadings = pd.read_csv(
        "C:/Users/bug32/Desktop/Media and Resilience/loadings/Previous study QOL_loadings.csv", index_col=0)

    # drop missing questions (rows) from previous study
    previous_qol_loadings.drop(previous_qol_loadings.index[[i-1 for i in MISSING_QUESTIONS]], inplace=True)
    previous_qol_loadings.reset_index(drop=True, inplace=True)

    # manually reordering columns and renaming them
    qol_loadings['Factor_temp'] = qol_loadings['Factor3']
    qol_loadings['Factor3'] = qol_loadings['Factor2']
    qol_loadings['Factor2'] = qol_loadings['Factor_temp']
    qol_loadings.drop('Factor_temp', axis=1, inplace=True)
    qol_loadings.rename(columns={'Factor1': 'Functioning', 'Factor2': 'Positive Feelings', 'Factor3': 'Competence'}, inplace=True)

    # Calculate the delta using values to ignore index
    delta_qol_loadings = abs(qol_loadings.values - previous_qol_loadings.values)

    # Convert the result back to a DataFrame, if necessary
    delta_qol_loadings_df = pd.DataFrame(delta_qol_loadings, index=[reverse_hebrew_text(i) for i in qol_loadings.index], columns=qol_loadings.columns)

    # create a heatmap
    plt.figure(figsize=(20, 10))
    sns.heatmap(delta_qol_loadings_df, annot=True, fmt='.2f', cmap='coolwarm')
    plt.title('Delta between QOL loadings from this and the previous study')
    plt.show()


if __name__ == "__main__":
    MISSING_QUESTIONS = [3, 9, 12]
    MAPS_PATH = "C:/Users/bug32/Desktop/Media and Resilience/sem_variables_maps"
    main()
