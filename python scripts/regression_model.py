# The following code will use linear regression from generated latent factors to asses qol.
import pandas as pd
from pathlib import Path
import json
import statsmodels.api as sm
import statsmodels.formula.api as smf
import itertools
from sklearn.preprocessing import StandardScaler
from itertools import permutations
from EDA import corr_heatmap, reverse_hebrew_text


def perform_ols_regressions_with_multiple_targets(data, predictors, targets, filename, significance_level=0.05):
    """
    Performs OLS regressions using specified predictors against multiple target columns, saves results to CSV.

    Parameters:
    - data: pandas DataFrame, your dataset.
    - predictors: list, the names of the columns to use as predictors.
    - targets: list, the names of the columns to be predicted.
    - filename: str, the name of the file to save the results.
    - significance_level: float, the threshold for p-value significance.
    """
    results = []  # To store the results

    # Iterate over each target and predictor
    for target in targets:
        for predictor in predictors:
            # Ensure the predictor is not the same as the target
            if predictor != target:
                # Perform OLS regression
                X = sm.add_constant(data[predictor])  # Adds a constant term to the predictor
                model = sm.OLS(data[target], X).fit()

                # Get the coefficient and p-value for the predictor variable
                coeff = model.params[predictor]
                p_value = model.pvalues[predictor]

                # Determine if the p-value is significant
                significant = "*" if p_value < significance_level else ""

                # Append results
                results.append([target, predictor, coeff, p_value, significant])

    # Create a DataFrame from the results
    results_df = pd.DataFrame(results, columns=["Predicted Column", "Predicting Column", "Coefficient", "P-Value", "Significant"])

    # Save to CSV
    results_df.to_csv(filename, index=False)

    print(f"Results saved to {filename}")


def perform_regressions_with_multiple_targets(data, predictors, targets, filename, significance_level=0.05):
    """
    Performs regressions using specified predictors against multiple target columns using MLE, saves results to CSV.

    Parameters:
    - data: pandas DataFrame, your dataset.
    - predictors: list, the names of the columns to use as predictors.
    - targets: list, the names of the columns to be predicted.
    - filename: str, the name of the file to save the results.
    - significance_level: float, the threshold for p-value significance.
    """
    results = []  # To store the results

    # Iterate over each combination of target and predictor
    for target in targets:
        for predictor in predictors:
            # Ensure the predictor is not the same as the target
            if predictor != target:
                # Perform regression using MLE
                formula = f"{target} ~ {predictor}"
                model = smf.glm(formula=formula, data=data, family=sm.families.Gaussian()).fit()

                # Get the coefficient and p-value for the predictor variable
                coeff = model.params[predictor]
                p_value = model.pvalues[predictor]

                # Determine if the p-value is significant
                significant = "*" if p_value < significance_level else ""

                # Append results
                results.append([target, predictor, coeff, p_value, significant])

    # Create a DataFrame from the results
    results_df = pd.DataFrame(results, columns=["Predicted Column", "Predicting Column", "Coefficient", "P-Value", "Significant"])

    # Save to CSV
    results_df.to_csv(filename, index=False)

    print(f"Results saved to {filename}")


def ols_regression(data: pd.DataFrame, target, predictor, general_item=None):
    if general_item:
        X = sm.add_constant(data[[predictor, general_item]])
    else:
        X = sm.add_constant(data[[predictor]])

    y = data[target]
    model = sm.OLS(y, X).fit()

    return model.pvalues[predictor], model.params[predictor]


def main():
    df = pd.read_excel(FILE_PATH)

    # fill missing values with the mean of the column
    df.fillna(df.mean(), inplace=True)

    create_latent_factor(df)

    # # reverse text of column names of first 4 columns
    # for col in df.columns[:4]:
    #     df.rename(columns={col: reverse_hebrew_text(col)}, inplace=True)
    # corr heatmap of general questions and all latent factors
    # relvant = df.columns[df.columns.str.contains(
    #     'age|gender|status|education|qol|resilience|phone|entertainment|news|communication_platforms|offline_news')]
    # corr_heatmap([df[relvant]], relvant)

    targets = df.columns[df.columns.str.contains('support|functioning|competence|positive_feeling|qol|resilience|phone|entertainment|news|communication_platforms|offline_news')]
    # predictors = df.columns[df.columns.str.contains('stress|support|(u|v|x)\d')]
    predictors = df.columns[df.columns.str.contains('functioning|competence|positive_feeling|qol|resilience|phone|entertainment|news|communication_platforms|offline_news')]
    general_items = df.columns[df.columns.str.contains('age|gender|status|education')]

    results = []
    general_items_list=[]
    insignificant_results = []
    insignificant_predictors = []
    single_significant_results = []

    for target, predictor, general_item in itertools.product(targets, predictors, general_items):
        if target == predictor:
            continue
        # Step 1: Simple regression
        p_value_single, coefficient_single = ols_regression(df, target, predictor)
        if p_value_single < 0.05:
            add_row(single_significant_results, coefficient_single, p_value_single, predictor, target)
            # Step 2: Multiple regression
            p_value_multiple, coefficient_multiple = ols_regression(df, target, predictor, general_item)
            if p_value_multiple < 0.05:
                add_row(results, coefficient_single, p_value_single, predictor, target)
            else:
                insignificant_predictors.append(predictor)
                add_row(insignificant_results, coefficient_multiple, p_value_multiple, predictor, target, general_item)

    # Convert results to DataFrame
    results_df = pd.DataFrame(results)
    insignificant_results_df = pd.DataFrame(insignificant_results)
    single_significant_results_df = pd.DataFrame(single_significant_results)
    # drop duplicates
    single_significant_results_df = single_significant_results_df.drop_duplicates()

    for target, predictor in itertools.product(targets, general_items):
        # Step 1: Simple regression
        p_value_single, coefficient_single = ols_regression(df, target, predictor)
        if p_value_single < 0.05:
            add_row(general_items_list, coefficient_single, p_value_single, predictor, target)

    general_items_df = pd.DataFrame(general_items_list)

    # drop from results all rows where the target - predictor combination is in insignificant_predictors
    temp_df1 = results_df.iloc[:, :2].reset_index()
    temp_df2 = insignificant_results_df.iloc[:, :2]

    # Add an artificial key to facilitate the merge operation since we're working with positions, not column names
    temp_df1['key'] = temp_df1.index
    temp_df2['key'] = temp_df2.index

    # Step 2: Merge with an indicator, using the artificial 'key' and the first two columns for comparison
    # Note: Since direct .iloc usage in merge is not possible, we work around by resetting the index and adding a 'key'
    merged_df = pd.merge(temp_df1, temp_df2, on=temp_df1.columns.tolist()[1:-1], how='left', indicator=True)

    # Step 3: Filter df1 to keep rows that did not find a match in df2 based on the first two columns
    unique_rows = merged_df[merged_df['_merge'] == 'left_only']['index']
    results_df = results_df.loc[unique_rows]
    results_df = results_df.drop_duplicates()

    with pd.ExcelWriter('regression_analysis_results_version2.xlsx') as writer:
        results_df.to_excel(writer, sheet_name='Significant Predictors', index=False)
        insignificant_results_df.to_excel(writer, sheet_name='Multiple_Reg Insignificant', index=False)
        general_items_df.to_excel(writer, sheet_name='General Items', index=False)
        single_significant_results_df.to_excel(writer, sheet_name='Single Significant Predictors', index=False)


def add_row(lst, coefficient_single, p_value_single, predictor, target, general_item=None):
    lst.append({
        'Target': target,
        'Predictor': predictor,
        'Coefficient': round(coefficient_single, 3),
        'P-Value': round(p_value_single, 4)
    })

    if general_item:
        lst[-1]['General Item'] = general_item


def create_latent_factor(df):
    """create mean latent factors, and normalize them with standard scaler"""

    df.loc[:, 'functioning'] = df.loc[:, config['QUESTIONS']['QOL']['FUNCTIONING']].mean(axis=1)
    df.loc[:, 'competence'] = df.loc[:, config['QUESTIONS']['QOL']['COMPETENCE']].mean(axis=1)
    df.loc[:, 'positive_feeling'] = df.loc[:, config['QUESTIONS']['QOL']['POSITIVE_FEELING']].mean(axis=1)
    df.loc[:, 'qol'] = df[['functioning', 'competence', 'positive_feeling']].mean(axis=1)

    df.loc[:, 'traditional_news'] = df.loc[:, config['QUESTIONS']['MEDIA']['TRADITIONAL_NEWS']].mean(axis=1)
    df.loc[:, 'online_news'] = df.loc[:, config['QUESTIONS']['MEDIA']['ONLINE_NEWS']].mean(axis=1)
    df.loc[:, 'push_news'] = df.loc[:, config['QUESTIONS']['MEDIA']['PUSH_NEWS']].mean(axis=1)
    df.loc[:, 'communication_platforms'] = df.loc[:, config['QUESTIONS']['MEDIA']['COMMUNICATION_PLATFORMS']].mean(
        axis=1)
    df.loc[:, 'entertainment'] = df.loc[:, config['QUESTIONS']['MEDIA']['ENTERTAINMENT']].mean(axis=1)
    df.loc[:, 'social_media'] = df.loc[:, config['QUESTIONS']['MEDIA']['SOCIAL_MEDIA']].mean(axis=1)
    df.loc[:, 'offline'] = df.loc[:, config['QUESTIONS']['MEDIA']['OFFLINE']].mean(axis=1)

    df.loc[:, 'resilience'] = df.loc[:, config['QUESTIONS']['RESILIENCE']].mean(axis=1)
    df.loc[:, 'phone'] = df.loc[:, config['QUESTIONS']['PHONE_UNAWARE_USAGE']].mean(axis=1)
    df.loc[:, 'stress'] = df.loc[:, config['QUESTIONS']['STRESS']].mean(axis=1)
    df.loc[:, 'support'] = df.loc[:, config['QUESTIONS']['SUPPORT']].mean(axis=1)
    df.loc[:, 'support2'] = df.loc[:, config['QUESTIONS']['SUPPORT2']].mean(axis=1)

    # Normalizing the newly created columns
    columns_to_scale = ['functioning', 'competence', 'positive_feeling', 'qol', 'traditional_news', 'online_news',
                        'push_news', 'communication_platforms', 'entertainment', 'social_media', 'offline', 'resilience',
                        'phone', 'stress', 'support', 'support2']
    scaler = StandardScaler()
    df[columns_to_scale] = scaler.fit_transform(df[columns_to_scale])


if __name__ == "__main__":
    script_dir = Path(__file__).parent

    # Path to the 'processed_responses.xlsx' file in the 'data' folder
    FILE_PATH = script_dir / '..' / 'data' / 'processed_responses.xlsx'

    PROCESSED_DATA_WITH_FACTORS_PATH = script_dir / '..' / 'data' / 'processed_data_with_factors.xlsx'

    with open('config.json', encoding='utf-8') as f:
        config = json.load(f)

    main()
