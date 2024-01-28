from sklearn.preprocessing import StandardScaler
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from EDA import reverse_hebrew_text
from factor_analyzer import FactorAnalyzer
from pathlib import Path
from sklearn.cluster import AgglomerativeClustering
from scipy.cluster.hierarchy import dendrogram, linkage


def scaling_data(dataframe):
    """Accepts a dataframe and returns a dataframe with scaled data"""
    # Standardize the data
    scaler = StandardScaler()
    scaler.fit(dataframe)
    scaled_data = scaler.transform(dataframe)

    return scaled_data


def rename_dataframe_from_csv(df, csv_file_path):
    # Read the CSV file
    mapping_df = pd.read_csv(csv_file_path, encoding='utf-8')

    # Apply reverse_hebrew_text to each value in the 'Questions' column
    mapping_df['Questions'] = mapping_df['Questions'].apply(reverse_hebrew_text)

    # Create a dictionary with 'Variable' as keys and 'Questions' as values
    mapping_dict = pd.Series(mapping_df.Questions.values, index=mapping_df.Variable).to_dict()

    # Rename the DataFrame columns
    df_renamed = df.rename(columns=mapping_dict)

    return df_renamed


def factor_analysis(dataframe: pd.DataFrame, df_name: str, n_components: int = 3, eigenvalues_plot=False) -> None:
    fa = FactorAnalyzer(n_factors=n_components)  # TODO: check hyperparameters
    fa.fit_transform(dataframe)

    # Get variance of all factors
    eigen_values, vectors = fa.get_eigenvalues()
    _, prop_var, cum_var = fa.get_factor_variance()
    print(f"{df_name} prop variance:\n", prop_var)

    if eigenvalues_plot:
        # Create subplots
        fig, axs = plt.subplots(1, 2, figsize=(15, 6))
        plt.subplots_adjust(hspace=1)

        # First subplot for cumulative explained variance
        axs[0].plot(range(1, len(dataframe.columns) + 1), eigen_values.cumsum())
        axs[0].set_title("Cumulative scree plot")
        axs[0].set_xlabel('Factors')
        axs[0].set_ylabel('EigenValue')
        axs[0].set_xticks(range(1, len(dataframe.columns) + 1))
        axs[0].grid()

        # Second subplot for individual explained variance
        axs[1].plot(range(1, len(dataframe.columns) + 1), eigen_values)
        axs[1].set_title("Individual scree plot")
        axs[1].set_xlabel('Factors')
        axs[1].set_ylabel('EigenValue')
        axs[1].set_xticks(range(1, len(dataframe.columns) + 1))
        axs[1].grid()

        # Show the plot
        plt.title(f"Scree plot for {df_name}")
        plt.show()

    # Save loadings of n_components to CSV file
    loadings = fa.loadings_
    print(f"{df_name} loadings:\n", loadings)
    loadings_df = pd.DataFrame(loadings, columns=[f"Factor{i}" for i in range(1, n_components + 1)])
    loadings_df.index = [reverse_hebrew_text(idx) for idx in dataframe.columns]

    loadings_df.to_csv(LOADINGS_PATH / f'{df_name}_loadings.csv', encoding='utf-8-sig')


def corr_heatmap(dataframes: list, df_names: list, threshold=.65) -> None:
    plt.figure(figsize=(15, 10))
    corrs = pd.concat(dataframes, axis=1).corr()
    mask = np.triu(np.ones_like(corrs))
    sns.heatmap(corrs, cmap='Spectral', mask=mask, vmin=-1, vmax=1, annot=True)
    plt.title(f"Correlation between {df_names}")
    plt.show()

    # if some correlation is above threshold, print it
    for i in range(len(corrs)):
        for j in range(i):
            if corrs.iloc[i, j] > threshold or corrs.iloc[i, j] < -threshold:
                print(f"{corrs.index[i]} and {corrs.columns[j]}: {corrs.iloc[i, j]}")


def hierarchical_clustering(dataframes: list, df_names: list) -> None:
    # # Performing hierarchical clustering on qol
    # cluster = AgglomerativeClustering(n_clusters=None, distance_threshold=10, linkage='ward')
    # cluster.fit_predict(np.concatenate((qol_scaled_data, resilience_scaled_data, phone_scaled_data), axis=1))
    # print(cluster.labels_)
    #
    # Z = linkage(qol_scaled_data, method='ward')
    #
    # # Plot the dendrogram
    # plt.figure(figsize=(15, 10))
    # plt.title('Hierarchical Clustering Dendrogram')
    # plt.xlabel('Sample index')
    # plt.ylabel('Distance')
    # dendrogram(Z)
    # plt.show()
    pass


def main():
    df = pd.read_excel(FILE_PATH)

    qol_df = df.loc[:, df.columns.str.contains('y')]
    resilience_df = df.loc[:, df.columns.str.contains('z')]
    media_df = df.loc[:, df.columns.str.contains('x')]
    phone_df = df.loc[:, df.columns.str.contains('w')]
    stress_df = df.loc[:, df.columns.str.contains('u')]
    support_df = df.loc[:, df.columns.str.contains('v')]

    # Changing columns names back to the questions for readability
    qol_df = rename_dataframe_from_csv(qol_df, ITEM_MAPS_PATH / 'y_mapping.csv')
    resilience_df = rename_dataframe_from_csv(resilience_df, ITEM_MAPS_PATH / 'z_mapping.csv')
    media_df = rename_dataframe_from_csv(media_df, ITEM_MAPS_PATH / 'x_mapping.csv')
    phone_df = rename_dataframe_from_csv(phone_df, ITEM_MAPS_PATH / 'w_mapping.csv')
    stress_df = rename_dataframe_from_csv(stress_df, ITEM_MAPS_PATH / 'u_mapping.csv')
    support_df = rename_dataframe_from_csv(support_df, ITEM_MAPS_PATH / 'v_mapping.csv')

    # FA on resilience
    resilience_scaled_data = scaling_data(resilience_df)
    nan_resilience_rows = np.isnan(resilience_scaled_data).any(axis=1)
    resilience_scaled_data = resilience_scaled_data[~nan_resilience_rows]
    resilience_scaled_data = pd.DataFrame(resilience_scaled_data, columns=resilience_df.columns)
    resilience_scaled_data.dropna(inplace=True)
    factor_analysis(resilience_scaled_data, 'resilience', n_components=1, eigenvalues_plot=False)
    # corr_heatmap([resilience_scaled_data], ['resilience'])

    # FA on qol
    qol_scaled_data = scaling_data(qol_df)
    nan_qol_rows = np.isnan(qol_scaled_data).any(axis=1)
    qol_scaled_data = qol_scaled_data[~nan_qol_rows]
    qol_scaled_data = pd.DataFrame(qol_scaled_data, columns=qol_df.columns)
    factor_analysis(qol_scaled_data, 'QOL', n_components=3)
    # corr_heatmap([qol_scaled_data], ['QOL'])

    # FA on phone usage
    phone_scaled_data = scaling_data(phone_df)
    nan_phone_rows = np.isnan(phone_scaled_data).any(axis=1)
    phone_scaled_data = phone_scaled_data[~nan_phone_rows]
    phone_scaled_data = pd.DataFrame(phone_scaled_data, columns=phone_df.columns)
    factor_analysis(phone_scaled_data, 'phone', n_components=1, eigenvalues_plot=False)
    # corr_heatmap([phone_scaled_data], ['phone'])

    # FA on media
    media_scaled_data = scaling_data(media_df)
    media_scaled_data = pd.DataFrame(media_scaled_data, columns=media_df.columns)
    media_scaled_data['.םיילארשי -- םירז םיצורעהמ יתושדח עדימ ת/לבקמ ךנה המכ דע ןייצ'].fillna(7, inplace=True)
    factor_analysis(media_scaled_data, 'media_2_factor', n_components=2, eigenvalues_plot=False)
    factor_analysis(media_scaled_data, 'media_3_factor', n_components=3, eigenvalues_plot=False)
    factor_analysis(media_scaled_data, 'media_4_factor', n_components=4, eigenvalues_plot=False)
    # corr_heatmap([media_scaled_data], ['media'])

    # FA on stress
    stress_scaled_data = scaling_data(stress_df)
    nan_stress_rows = np.isnan(stress_scaled_data).any(axis=1)
    stress_scaled_data = stress_scaled_data[~nan_stress_rows]
    stress_scaled_data = pd.DataFrame(stress_scaled_data, columns=stress_df.columns)
    factor_analysis(stress_scaled_data, 'stress', n_components=1, eigenvalues_plot=False)
    # corr_heatmap([stress_scaled_data], ['stress'])

    # FA on support
    support_scaled_data = scaling_data(support_df)
    nan_support_rows = np.isnan(support_scaled_data).any(axis=1)
    support_scaled_data = support_scaled_data[~nan_support_rows]
    support_scaled_data = pd.DataFrame(support_scaled_data, columns=support_df.columns)
    factor_analysis(support_scaled_data, 'support', n_components=1, eigenvalues_plot=False)
    # corr_heatmap([support_scaled_data], ['support'])

    # FA on previous study qol
    # previous_qol_df = pd.read_csv(PREVIOUS_STUDY_DATA_PATH)
    # previous_qol_df = previous_qol_df.loc[:, previous_qol_df.columns.str.contains('y')]
    # previous_qol_scaled_data = scaling_data(previous_qol_df)
    # previous_qol_scaled_data = pd.DataFrame(previous_qol_scaled_data, columns=previous_qol_df.columns)
    # factor_analysis(previous_qol_scaled_data, 'Previous study QOL', n_components=3, eigenvalues_plot=False)


if __name__ == "__main__":
    # Path to the directory where the script is located
    script_dir = Path(__file__).parent

    # Path to the 'processed_responses.xlsx' file in the 'data' folder
    FILE_PATH = script_dir / '..' / 'data' / 'processed_responses.xlsx'

    # Path to the 'items_maps' folder
    ITEM_MAPS_PATH = script_dir / '..' / 'items_maps'

    # Create a directory for the factor loadings
    LOADINGS_PATH = script_dir / '..' / 'loadings'
    LOADINGS_PATH.mkdir(parents=True, exist_ok=True)

    # Path to the previous study folder
    # PREVIOUS_STUDY_DATA_PATH = script_dir / '..' / 'previous_study'

    main()
