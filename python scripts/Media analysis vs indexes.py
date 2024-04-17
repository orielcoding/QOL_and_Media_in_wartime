import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from EDA import reverse_hebrew_text
from pathlib import Path


def create_score_columns(dataframe, loadings_df, threshold=0.3, method='factor-based scores'):
    """
    Given the loadings of the items on the factors, use threshold critieria to separate the items into factors, and
    use factor-based scoring to create a score column for each factor.
    (see https://www.theanalysisfactor.com/index-score-factor-analysis/ for more details)
    :param dataframe: dataframe with the questions
    :param loadings_df: dataframe with the loadings
    :param threshold: threshold for the loadings to be considered in the factor
    """
    dataframe = dataframe.copy()  # To prevent python SettingWithCopyWarning which is irrelevant
    for factor in loadings_df.columns:
        # get the items that belong to the factor
        items_for_factor = loadings_df[abs(loadings_df[factor]) > threshold].index

        # create a score column for the factor by summing columns in locations of items_for_factor
        if method == 'factor-based scores':
            dataframe[factor] = dataframe.iloc[:, items_for_factor].sum(axis=1)
        elif method == 'factor scores':
            items_loadings = loadings_df.loc[items_for_factor, factor].abs()
            dataframe[factor] = dataframe.iloc[:, items_for_factor].mul(list(items_loadings), axis=1).sum(axis=1)
            print(items_loadings)

    return dataframe


def indexes_scatter_plots(df1_name, df2_name, df1, df2, loadings1, loadings2):
    fig, axes = plt.subplots(loadings1.shape[1], loadings2.shape[1], figsize=(20, 10))
    fig.subplots_adjust(hspace=0.3, wspace=0.3)

    for i, df1_factor in enumerate(df1.iloc[:, -loadings1.shape[1]:].columns):
        for j, df2_factor in enumerate(df2.iloc[:, -loadings2.shape[1]:].columns):
            # Calculate the frequency of each point
            merged_df = pd.DataFrame()
            merged_df['x'] = df1[df1_factor]
            merged_df['y'] = df2[df2_factor]
            merged_df['freq'] = merged_df.groupby(['x', 'y'])['y'].transform('count')

            # Use frequencies to set dot sizes
            sizes = merged_df['freq'] * 20  # Adjust the multiplier as needed for visibility

            sns.regplot(x='x', y='y', data=merged_df, ax=axes[i, j], scatter=False)
            axes[i, j].scatter(merged_df['x'], merged_df['y'], s=sizes, alpha=0.6)
            axes[i, j].set_xlabel(df1_factor)
            axes[i, j].set_ylabel(df2_factor)

    fig.text(0.5, 0.04, df1_name + ' factors', ha='center')
    fig.text(0.04, 0.5, df2_name + ' factors', va='center', rotation='vertical')
    plt.suptitle("Scatterplots of " + df1_name + " factors vs " + df2_name + " factors")
    plt.show()


def control_item_boxplots_against_factors(df, df1, loadings, control_item):
    # Create boxplots of the control item distribution of each factor
    if loadings.shape[1] == 1:    # Handle with case of single loading column, plot just a single plot
        sns.boxplot(x=df[control_item], y=df1.iloc[:, -1])
        plt.xlabel(reverse_hebrew_text(control_item))
        plt.ylabel(df1.columns[-1])
        plt.title('Distribution of ' + control_item + ' by ' + df1.columns[-1])

    else:
        fig, axes = plt.subplots(1, loadings.shape[1], figsize=(20, 10))
        fig.subplots_adjust(hspace=0.3, wspace=0.3)

        for i, factor in enumerate(df1.iloc[:, -loadings.shape[1]:].columns):
            sns.boxplot(x=df[control_item], y=df1[factor], ax=axes[i])
            axes[i].set_xlabel(reverse_hebrew_text(control_item))
            axes[i].set_ylabel(factor)
            axes[i].set_title('Distribution of ' + control_item + ' by ' + factor)

    plt.show()


def plot_factors_heatmap(df1, df1_name, df1_loadings, df2, df2_name, df2_loadings):
    """ Create a heatmap of the correlations between the factors of the indexes """
    factors_corr = pd.concat([df2.iloc[:, -df2_loadings.shape[1]:], df1.iloc[:, -df1_loadings.shape[1]:]],
                             axis=1).corr()
    plt.figure(figsize=(10, 10))
    mask = np.triu(np.ones_like(factors_corr))
    sns.heatmap(factors_corr, mask=mask, annot=True, fmt=".2f", square=True, cmap='Blues')
    plt.title(f"Correlation between factors of {df1_name}  and {df2_name}")
    plt.show()


def main():
    # read dataframes
    media_loadings, qol_loadings, resilience_loadings, stress_loadings, phone_loadings = read_loadings()
    df, media_df, qol_df, resilience_df, stress_df, phone_df = read_dataframes()

    media_df, phone_df, qol_df, resilience_df, stress_df = calc_factors_scores(media_df, media_loadings,
                                                                               phone_df, phone_loadings,
                                                                               qol_df, qol_loadings,
                                                                               resilience_df,
                                                                               resilience_loadings, stress_df,
                                                                               stress_loadings)

    rename_factor_columns(media_df, qol_df, resilience_df, stress_df, phone_df)

    # Plotting heatmap and scatter plots for the factors of the indexes against each other
    # plot_factors_heatmap(media_df, 'Media', media_loadings, qol_df, 'QOL', qol_loadings)
    # indexes_scatter_plots('QOL', 'Media', qol_df, media_df, qol_loadings, media_loadings)

    # Create boxplot of the age distribution for each factor
    # df['גיל'] = df['גיל'].astype('category')
    # control_item_boxplots_against_factors(df, media_df, media_loadings, 'גיל')

    # plot histogram with kde of the resilience index scores for different age groups. age appears in df.
    # df['resilience'] = resilience_df['resilience']
    # for age_group in df['גיל'].unique():
    #     sns.histplot(data=df[df['גיל'] == age_group], x='resilience', kde=True, common_norm=False)
    #     plt.title('Resilience index scores distribution for age group ' + str(age_group))
    #     plt.show()


    # df['מצב משפחתי'] = df['מצב משפחתי'].astype('category')
    # control_item_boxplots_against_factors(df, stress_df, stress_loadings, 'מצב משפחתי')

    

    # create boxplot to check social media items distribution according to phone factor scores.
    # for app in ['x10', 'x11', 'x12', 'x13', 'x14', 'x15', 'x16']:
    #     control_item_boxplots_against_factors(df, phone_df, phone_loadings, app)

    df = df[df['גיל'].isin(['18-24', '25-29'])]

    # Filter qol_df and resilience_df based on df's index
    qol_df = qol_df.loc[df.index]
    resilience_df = resilience_df.loc[df.index]

    # # see usage of telegram effect on qol factor scores
    control_item_boxplots_against_factors(df, qol_df, qol_loadings, 'x13')
    control_item_boxplots_against_factors(df, resilience_df, resilience_loadings, 'x13')

    # same with instegram
    control_item_boxplots_against_factors(df, qol_df, qol_loadings, 'x12')
    control_item_boxplots_against_factors(df, resilience_df, resilience_loadings, 'x12')

    # same with linkedin
    control_item_boxplots_against_factors(df, qol_df, qol_loadings, 'x15')
    control_item_boxplots_against_factors(df, resilience_df, resilience_loadings, 'x15')




def calc_factors_scores(media_df, media_loadings, phone_df, phone_loadings, qol_df, qol_loadings,
                        resilience_df, resilience_loadings, stress_df, stress_loadings):
    # create score columns for each index
    qol_df = create_score_columns(qol_df, qol_loadings, threshold=0.3)
    media_df = create_score_columns(media_df, media_loadings, threshold=0.3)
    resilience_df = create_score_columns(resilience_df, resilience_loadings, threshold=0.3)
    stress_df = create_score_columns(stress_df, stress_loadings, threshold=0.3)
    phone_df = create_score_columns(phone_df, phone_loadings, threshold=0.3)
    return media_df, phone_df, qol_df, resilience_df, stress_df


def rename_factor_columns(media_df, qol_df, resilience_df, stress_df, phone_df):
    # Manually renaming columns based on theory
    qol_df.rename(columns={'Factor1': 'Functioning', 'Factor2': 'Positive Feelings', 'Factor3': 'Competence'},
                  inplace=True)
    media_df.rename(columns={'Factor1': 'Social network', 'Factor2': 'Offline/Traditional news/communication',
                             'Factor3': 'Online/Internet communication'}, inplace=True)
    resilience_df.rename(columns={'Factor1': 'resilience'}, inplace=True)
    stress_df.rename(columns={'Factor1': 'stress'}, inplace=True)
    phone_df.rename(columns={'Factor1': 'phone_use'}, inplace=True)


def read_dataframes():
    # read dataframes
    df = pd.read_excel(FILE_PATH)
    qol_df = df.loc[:, df.columns.str.contains('y')]
    media_df = df.loc[:, df.columns.str.contains('x')]
    resilience_df = df.loc[:, df.columns.str.contains('z')]
    stress_df = df.loc[:, df.columns.str.contains('u')]
    phone_df = df.loc[:, df.columns.str.contains('w')]
    return df, media_df, qol_df, resilience_df, stress_df, phone_df


def read_loadings():
    # read Loadings
    qol_loadings = pd.read_excel(LOADINGS_PATH / "QOL_loadings.Xlsx").iloc[:, 1:]
    media_loadings = pd.read_excel(LOADINGS_PATH / "media_loadings.Xlsx").iloc[:, 1:]
    resilience_loadings = pd.read_excel(LOADINGS_PATH / "resilience_loadings.Xlsx").iloc[:, 1:]
    stress_loadings = pd.read_excel(LOADINGS_PATH / "stress_loadings.Xlsx").iloc[:, 1:]
    phone_loadings = pd.read_excel(LOADINGS_PATH / "phone_loadings.Xlsx").iloc[:, 1:]
    return media_loadings, qol_loadings, resilience_loadings, stress_loadings, phone_loadings


if __name__ == "__main__":
    # Path to the directory where the script is located
    script_dir = Path(__file__).parent

    # Path to the 'processed_responses.xlsx' file in the 'data' folder
    FILE_PATH = script_dir / '..' / 'data' / 'processed_responses.xlsx'

    # Path to the 'items_maps' folder
    ITEM_MAPS_PATH = script_dir / '..' / 'items_maps'

    # Create a directory for the factor loadings
    LOADINGS_PATH = script_dir / '..' / 'loadings'

    main()