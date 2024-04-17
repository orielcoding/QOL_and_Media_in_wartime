import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from scipy.stats import f_oneway, levene, shapiro
import numpy as np
from preprocessing import excel_column_number
import matplotlib as mpl
from pathlib import Path


def reverse_hebrew_text(text):
    """ Reverse Hebrew text for correct display in plots """

    # Set the default font to one that supports Hebrew
    mpl.rcParams['font.family'] = 'Arial'

    # Convert non-string inputs to strings
    text = str(text)

    # Check if the text is Hebrew and reverse it if so
    if any("\u0590" <= c <= "\u05EA" for c in text):
        return text[::-1]
    return text


def histogram(data, group: str) -> None:
    """Plot the distribution of subjects population with mean and std in the title."""
    mean_val = data.mean()
    std_val = data.std()

    plt.figure(figsize=(10, 5))
    sns.histplot(data=data, bins=20, kde=True)
    plt.xlabel('Score')
    plt.ylabel('Number of subjects')
    plt.title(f'Group: {group}, n={len(data)}, Mean: {mean_val:.2f}, Std: {std_val:.2f}')
    plt.show()


def ks_test_1sample_normal_distribution(data, group: str, alpha=0.05):
    """
    Test if the data comes from a normal distribution, plot EDF against normal distribution CDF,
    and include the p-value and hypothesis test result in the plot title.

    Parameters:
    - data: 1D array-like object containing the data to be tested
    - alpha: Significance level for the hypothesis test (default 0.05)

    Returns:
    - D_statistic: K-S test statistic
    - p_value: p-value corresponding to the test statistic
    """
    # Normalize the data
    data_normalized = (data - np.mean(data)) / np.std(data)

    # Perform the K-S test
    D_statistic, p_value = stats.kstest(data_normalized, 'norm')

    # Determine if the null hypothesis is rejected or not
    if p_value < alpha:
        hypothesis_result = 'Rejected'
    else:
        hypothesis_result = 'Not Rejected'

    # Plotting
    sorted_data = np.sort(data_normalized)
    y_values = np.arange(len(sorted_data)) / float(len(sorted_data) - 1)
    norm_cdf = stats.norm.cdf(sorted_data)

    plt.figure(figsize=(10, 6))
    plt.step(sorted_data, y_values, label='EDF', where='post')
    plt.plot(sorted_data, norm_cdf, label='Normal CDF')
    plt.title(f'group: {group}, EDF vs. Normal CDF (p-value: {p_value:.3f}, Null Hypothesis: {hypothesis_result})')
    plt.xlabel('Value')
    plt.ylabel('Cumulative Probability')
    plt.legend()
    plt.show()

    return D_statistic, p_value


def ks_test_2sample(group1_data, group2_data, alpha=0.05, ks_threshold=None):
    """
    Perform a two-sample K-S test on two subsets of data, print conclusions, and plot EDFs.

    Parameters:
    - group1_data: pandas Series or numpy array of scores for the first group
    - group2_data: pandas Series or numpy array of scores for the second group
    - alpha: Significance level for deciding whether to reject the null hypothesis (default 0.05)
    - ks_threshold: Optional threshold for KS statistic to determine a significant difference

    Returns:
    - ks_statistic: The K-S statistic for the test
    - p_value: The p-value for the test
    """
    # Perform KS test
    ks_statistic, p_value = stats.ks_2samp(group1_data, group2_data)

    # Print conclusions
    if p_value < alpha:
        print(
            f"Reject the null hypothesis (p-value = {p_value:.3f}). There is a significant difference between the groups.")
        if ks_threshold is not None and ks_statistic > ks_threshold:
            print(
                f"The KS statistic ({ks_statistic:.3f}) is greater than the threshold ({ks_threshold}). This indicates a substantial difference in distributions.")
    else:
        print(
            f"Fail to reject the null hypothesis (p-value = {p_value:.3f}). There is no significant difference between the groups.")

    # Plotting EDFs
    for data, label in zip([group1_data, group2_data], ['Group 1', 'Group 2']):
        sns.lineplot(x=np.sort(data), y=np.linspace(0, 1, len(data), endpoint=False), label=label)

    plt.title('Empirical Distribution Functions (EDFs)')
    plt.xlabel('Value')
    plt.ylabel('Cumulative Probability')
    plt.legend()
    plt.show()

    return ks_statistic, p_value

    # Function to test normality for each group


def analyze_and_plot(dataframe, categorical_column, numerical_column):
    plt.figure(figsize=(10, 6))
    reversed_column_label = reverse_hebrew_text(categorical_column)

    categorical_column_hebrew = reverse_hebrew_text(categorical_column)

    # Create a copy of the dataframe to avoid SettingWithCopyWarning
    dataframe = dataframe.dropna(subset=[categorical_column, numerical_column]).copy()

    # Apply the reversal to the values in the categorical column
    dataframe.loc[:, categorical_column_hebrew] = dataframe[categorical_column].apply(reverse_hebrew_text)

    categories = dataframe[categorical_column].unique()

    # Test for mean differences (ANOVA)
    anova_result = f_oneway(
        *(dataframe[dataframe[categorical_column] == category][numerical_column] for category in categories))

    # Test for variance differences (Levene's test)
    levene_result = levene(
        *(dataframe[dataframe[categorical_column] == category][numerical_column] for category in categories))

    def test_normality(group):
        stat, p = shapiro(dataframe[dataframe[categorical_column] == group][numerical_column])
        return p > 0.05  # True if normal

    # Decide which plot to use
    if anova_result.pvalue > 0.05 and levene_result.pvalue > 0.05:
        # Use barplot/countplot if no significant difference in mean and std
        sns.barplot(x=categorical_column, y=numerical_column, data=dataframe)
    elif all(test_normality(category) for category in categories):
        # Use boxplot if distributions are normal
        sns.boxplot(x=categorical_column, y=numerical_column, data=dataframe)
    else:
        # Use violin plot if distributions are not normal
        sns.violinplot(x=categorical_column, y=numerical_column, data=dataframe)

    plt.xlabel(reversed_column_label)
    plt.xticks([reverse_hebrew_text(label) for label in dataframe[categorical_column].unique()], rotation=45)
    plt.show()


def corr_heatmap(dataframes: list, df_names: list, threshold=.65) -> None:
    plt.figure(figsize=(15, 10))
    corrs = pd.concat(dataframes, axis=1).corr()
    mask = np.triu(np.ones_like(corrs))
    sns.heatmap(corrs, cmap='viridis', mask=mask, annot=True)
    plt.title(f"Correlation between {df_names}")
    plt.show()

    # if some correlation is above threshold, print it
    for i in range(len(corrs)):
        for j in range(i):
            if corrs.iloc[i, j] > threshold or corrs.iloc[i, j] < -threshold:
                print(f"{corrs.index[i]} and {corrs.columns[j]}: {corrs.iloc[i, j]}")


def main():
    df = pd.read_excel(FILE_PATH)

    qol_df = df.loc[:, df.columns.str.contains('y')]
    resilience_df = df.loc[:, df.columns.str.contains('z')]
    media_df = df.loc[:, df.columns.str.contains('x')]
    phone_df = df.loc[:, df.columns.str.contains('w')]
    stress_df = df.loc[:, df.columns.str.contains('u')]
    support_df = df.loc[:, df.columns.str.contains('v')]

    # # reorder column order of media_df: x1, x2, x3, x4 ,x5 ,x6 ,x7 , x11, x15, x10, x16, x12, x8, x9, x13, x14
    # media_df = media_df[[ 'x11', 'x15', 'x3', 'x2', 'x6', 'x7', 'x4', 'x5', 'x16', 'x10', 'x12', 'x1', 'x13', 'x14', 'x8', 'x9']]
    #
    # # plot corr heatmap of media
    # corr_heatmap([media_df], ['media'])

    # resilience_stats = False
    # if resilience_stats:
    #     # Split the resilience data into two age groups
    #     resilience_group1 = resilience_df[df['גיל'].isin(['18-24', '25-29'])]  # Ages 18-29
    #     resilience_group2 = resilience_df[~df['גיל'].isin(['18-24', '25-29'])]  # Ages 30+
    #
    #     # Plot dist
    #     histogram(resilience_df.sum(axis=1), 'Resilience all ages')
    #     histogram(resilience_group1.sum(axis=1), 'Resilience ages 18-29')
    #     histogram(resilience_group2.sum(axis=1), 'Resilience ages 30+')
    #
    #     # 1 sample ks test. H0: normal distribution
    #     D_resilience, p_resilience = ks_test_1sample_normal_distribution(resilience_group1.sum(axis=1),
    #                                                                      'Resilience ages 18-29')
    #     print(f'Resilience: D={D_resilience}, p-value={p_resilience}')
    #     D_resilience, p_resilience = ks_test_1sample_normal_distribution(resilience_group2.sum(axis=1),
    #                                                                      'Resilience ages 30+')
    #     print(f'Resilience: D={D_resilience}, p-value={p_resilience}')
    #
    #     # 2 sample ks test. H0: same distribution
    #     ks_statistic_resilience, p_value_resilience = ks_test_2sample(resilience_group1.sum(axis=1),
    #                                                                   resilience_group2.sum(axis=1))
    #
    #     print(f'Resilience: KS statistic = {ks_statistic_resilience}, p-value = {p_value_resilience}')
    #
    #     # TODO: add wetcher test

    # qol_stats = False
    # if qol_stats:
    #     QOL_df = df.iloc[:, excel_column_number('BC'):excel_column_number('BU') + 1]
    #     print(QOL_df.columns)
    #     # functioning_questions =
    #
    # resilience_df['resilience_score'] = resilience_df.sum(axis=1)
    # qol_df['qol_score'] = qol_df.sum(axis=1)
    # media_df['media_score'] = media_df.sum(axis=1)
    #
    # for col in stress_df.columns:
    #     analyze_and_plot(df, col, 'resilience_score')
    #
    # for col in phone_df.columns:
    #     analyze_and_plot(df, col, 'resilience_score')
    #
    # for col in media_df.columns:
    #     analyze_and_plot(df, col, 'resilience_score')
    #
    # media_df = df.iloc[:, excel_column_number('Z'):excel_column_number('AR') + 1]
    #
    #
    # distribution(QOL_df_mapped)
    #
    # D_qol, p_qol = test_normal_distribution(resilence_df_mapped)
    #
    # print(f'QOL: D={D_qol}, p-value={p_qol}')
    # print(f'K-S statistic: {ks_stat}')
    # print(f'p-value: {p_value}')
    #
    # # Split the QOL data into two age groups
    # QOL_group1 = QOL_df_mapped[df['age'] < 30]  # Ages 18-29
    # QOL_group2 = QOL_df_mapped[df['age'] >= 30]  # Ages 30+
    #
    #
    #
    # # Now perform the K-S test for QOL
    # ks_statistic_qol, p_value_qol = ks_test_for_age_groups(QOL_group1, QOL_group2)
    #
    #
    # Print out the results
    # print(f'QOL: KS statistic = {ks_statistic_qol}, p-value = {p_value_qol}')

    # create a function which calculate correlations of all features. split the results to three: couples of items with high positive
    # correlation, couples of items with high negative correlation, and couples of items with low correlation.
    # send the results to a csv file.
    def calculate_correlations(df, method='pearson', threshold=.3):
        corrs = df.corr(method=method)
        high_positive_corrs = []
        high_negative_corrs = []
        low_corrs = []
        for i in range(len(corrs)):
            for j in range(i):
                if corrs.iloc[i, j] > threshold:
                    high_positive_corrs.append((corrs.index[i], corrs.columns[j], corrs.iloc[i, j]))
                elif corrs.iloc[i, j] < -threshold:
                    high_negative_corrs.append((corrs.index[i], corrs.columns[j], corrs.iloc[i, j]))
                else:
                    low_corrs.append((corrs.index[i], corrs.columns[j], corrs.iloc[i, j]))
        return high_positive_corrs, high_negative_corrs, low_corrs

    # questions_df = pd.concat([qol_df, resilience_df, media_df, phone_df, stress_df, support_df], axis=1)
    # high_positive_corrs, high_negative_corrs, low_corrs = calculate_correlations(questions_df)
    # high_positive_corrs_df = pd.DataFrame(high_positive_corrs, columns=['item1', 'item2', 'correlation'])
    # high_negative_corrs_df = pd.DataFrame(high_negative_corrs, columns=['item1', 'item2', 'correlation'])
    # low_corrs_df = pd.DataFrame(low_corrs, columns=['item1', 'item2', 'correlation'])
    # # send all df to the same csv in different sheets with appropriate names
    # with pd.ExcelWriter('pearson_linear_correlations.xlsx') as writer:
    #     high_positive_corrs_df.to_excel(writer, sheet_name='high_positive_corrs')
    #     high_negative_corrs_df.to_excel(writer, sheet_name='high_negative_corrs')
    #     low_corrs_df.to_excel(writer, sheet_name='low_corrs')

    # heatmap media
    # corr_heatmapheatmap([media_df], ['media'])
    # corr_heatmap([resilience_df], ['resilience'])

if __name__ == "__main__":
    # Path to the directory where the script is located
    script_dir = Path(__file__).parent

    # Path to the 'processed_responses.xlsx' file in the 'data' folder
    data_folder_path = script_dir / '..' / 'data'
    FILE_PATH = data_folder_path / 'processed_responses.xlsx'
    RESPONSES_PATH = data_folder_path / 'responses210124.xlsx'
    RESPONSES_FULL_QOL_PATH = data_folder_path / 'responses_full_qol060224.xlsx'

    main()
