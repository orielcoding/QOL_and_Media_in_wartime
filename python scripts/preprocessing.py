import pandas as pd
from pathlib import Path
import re
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer
from sklearn.impute import KNNImputer
import json


def excel_column_number(col_str):
    """Convert Excel-style column letters to zero-based column index."""
    expn = 0
    col_num = 0
    for char in reversed(col_str.upper()):
        col_num += (ord(char) - ord('A') + 1) * (26 ** expn)
        expn += 1
    return col_num - 1


def detect_uniform_responses(dataframe: pd.DataFrame, std_threshold: float = 0.0, range_threshold: int = 0, verbose=0):
    """
    Find rows with uniform responses for the provided dataframe argument.
    Define uniform responses (rows) by two arguments: std and range. default std_threshold=0.0, range_threshold=0.
    The default values indicate that only rows with identical values in all columns will be considered uniform responses.

    :param dataframe: The DataFrame to check for uniform responses.
    :param std_threshold: The threshold for the standard deviation of the row values.
    :param range_threshold: The threshold for the range of the row values.
    :param verbose: If set above 0, Print information about the number of detected uniform responses.
    :return: Indexes of rows with uniform responses, or with low range, or with low std.
    """
    # rows with completely uniform responses
    uniform_reply: pd.DataFrame = dataframe.apply(lambda x: x.nunique() == 1, axis=1)

    # rows range of values
    rng: pd.Series = dataframe.max(axis=1) - dataframe.min(axis=1)

    # rows std
    std: pd.Series = dataframe.std(axis=1)

    # print information about the number of detected uniform responses
    if verbose > 0:
        print(f"N rows with uniform responses: {uniform_reply[uniform_reply].shape[0]}\n,"
              f" Indexes: {uniform_reply[uniform_reply].index}")
        print(f"N rows with low range: {rng[rng < range_threshold].shape[0]}\n,"
              f" Indexes: {rng[rng < range_threshold].index}")
        print(f"N rows with low std: {std[std < std_threshold].shape[0]}\n,"
              f" Indexes: {std[std < std_threshold].index}\n")

    # return indexes of rows with uniform responses, or with low range, or with low std.
    return uniform_reply[uniform_reply].index.union(rng[rng < range_threshold].index).union(
        std[std < std_threshold].index)


def create_and_save_mapping(dataframe: pd.DataFrame, prefix: str, output_directory: str):
    """
    Creates a mapping between the dataframe column names (questions) and the new column names (prefix+integer).
    The mapping is saved to a CSV file. Renaming the columns as the new names.

    :param dataframe: The DataFrame to create the mapping for.
    :param output_directory: The path to save the mapping to.
    :param prefix: The letter which encodes the original item (column) names (e.g., 'u', 'v', 'w', 'x', 'y', 'z').
    :return: The full DataFrame with the renamed columns
    """
    mapping = {}  # Dictionary to store the mapping
    excel_data = []  # List to store the mapping for the Excel file

    for i, col in enumerate(dataframe.columns):
        # some column names (questions) are in square brackets. Extract the text within the brackets if exists.
        match_question = re.search(r'\[(.*?)]', col)
        if match_question:  # If brackets are found
            col_name = match_question.group(1)  # Use text within brackets
        else:
            col_name = col  # Use the original column name if no brackets are found

        # Create the mapping
        mapping[col] = f"{prefix}{i + 1}"

        # adding dict items allows to save to excel as proper table
        excel_data.append({'Questions': col_name, 'Variable': f"{prefix}{i + 1}"})

        dataframe_for_excel = pd.DataFrame(excel_data)

        # Save the mapping to an Excel file
        dataframe_for_excel.to_excel(output_directory, index=False)

    # Rename columns in the provided DataFrame
    dataframe.rename(columns=mapping, inplace=True)


def main():
    # Load all responses files (until febuary)
    df_not_full_qol = pd.read_excel(RESPONSES_PATH)
    df_full_qol = pd.read_excel(RESPONSES_FULL_QOL_PATH)
    df = pd.concat([df_not_full_qol, df_full_qol], axis=0)

    df.drop(df.columns[-4], axis=1, inplace=True)  # Dropping email column

    # Split the DataFrame into question type seperated
    QOL_df, media_df, phone_df, resilience_df, stress_df, support_df = extracting_df_parts(df)

    # dropping irrelevant columns
    media_df.drop('במידה וסימנת "כן" בשאלה הקודמת, ציין/ני מה הוא מקור זה. ', axis=1, inplace=True)
    media_df.drop('בזמן מילוי שאלון זה מצב הלחימה הינו', axis=1, inplace=True)
    unchanged_df = df[['גיל', 'מגדר', 'מצב משפחתי', 'מהי רמת ההשכלה שלך?']].copy()

    # Change qol column order back to original. -3 -> 3, -2 -> 12, -1 -> 15
    QOL_df = QOL_df[list(QOL_df.columns[: 2]) + list([QOL_df.columns[-3]]) + list(QOL_df.columns[2:7]) +
                    list([QOL_df.columns[-2]]) + list(QOL_df.columns[7:9]) + list([QOL_df.columns[-1]]) + list(
        QOL_df.columns[9:19])]

    # map the unchanged_df according to config file
    unchanged_df.rename(columns=config["general_questions"]["rename"], inplace=True)

    unchanged_df['age'] = unchanged_df['age'].map(lambda x: config['general_questions']['age'][x])
    unchanged_df['gender'] = unchanged_df['gender'].map(lambda x: config['general_questions']['gender'][x])
    unchanged_df['status'] = unchanged_df['status'].map(lambda x: config['general_questions']['family_status'][x])
    unchanged_df['education'] = unchanged_df['education'].map(lambda x: config['general_questions']['education'][x])

    # creating list again because of changed dataframes. create list of letter encoding for each dataframe
    df_list = [stress_df, support_df, phone_df, media_df, resilience_df, QOL_df]
    letters_mapping_list = ['u', 'v', 'w', 'x', 'z', 'y']

    # Create and save the mappings of columns for sem analysis
    for df, prefix in zip(df_list, letters_mapping_list):
        create_and_save_mapping(df, prefix, ITEM_MAPS_PATH / f'{prefix}_mapping.xlsx')

    # Mapping all QOL responds from categorical to numerical based on QOL_MAPPING
    QOL_df = QOL_df.map(lambda x: config["QOL_MAPPING"].get(x, x))

    # Drop rows with uniform responses in qol_df
    qol_index_to_drop = detect_uniform_responses(QOL_df, std_threshold=0.2, range_threshold=2,
                                                 verbose=1)  # Some questions have different sentiment

    # Change QOL negative questions values to positive
    for col in config['QOL_NEGATIVE_QUESTIONS']:
        QOL_df[col] = QOL_df[col].map(lambda x: 6 - x)

    # Impute 3 missing items in QOL_df
    knn_imputer = KNNImputer(n_neighbors=3)
    QOL_df = pd.DataFrame(knn_imputer.fit_transform(QOL_df), columns=QOL_df.columns, index=QOL_df.index)

    # Mapping specific questions value for stress_df
    stress_df['u2'] = stress_df['u2'].map(lambda x: config["STRESS"]["n_kids_alternative_1"][str(x)])
    stress_df['u4'] = stress_df['u4'].map(config["STRESS"]["military_service_alternative_1"])
    stress_df['u6'] = stress_df['u6'].map(config["STRESS"]["shelter_time_alternative_1"])
    stress_df['u7'] = stress_df['u7'].map(config["STRESS"]["income_loss"])

    # stress_df['u3'] = stress_df['u3'].map(lambda x: 0 if x == '3+' else x)
    stress_df['u3'] = stress_df['u3'].map(lambda x: 0 if x == 0 else 1)
    # stress_df['u5'] = stress_df['u5'].map(lambda x: 1 if x == 'כן, בחזית' or x == 'כן, בחזית, כן, בעורף' else 0)
    stress_df['u5'] = stress_df['u5'].map(lambda x: 1 if x == 'כן, בחזית' else 0)
    stress_df['u8'] = stress_df['u8'].map(lambda x: 0 if x == 'לא התפניתי' else 1)
    # stress_df['u9'] = stress_df['u9'].map(lambda x: 0 if x == 'כן, ממ"ד' or x == 'כן, מקלט / ממ"ק' else 1)
    stress_df['u9'] = stress_df['u9'].map(lambda x: 1 if x == 'לא' else 0)
    # use pd get_dummies for u1
    stress_df = pd.concat([stress_df, pd.get_dummies(stress_df['u1'], prefix='u1').astype(int)],
                          axis=1)  # .drop('u1', axis=1)
    stress_df['u1'] = stress_df['u1'].map(lambda x: 1 if x == 'בחל"ת' or x == 'עצמאי/ת' or x == 'מובטל/ת' else 0)

    # Mapping all resilience responds from categorical to numerical
    resilience_df = resilience_df.map(lambda x: config["RESILIENCE"].get(x, x))

    # Mapping specific questions value for phone_df
    phone_df.iloc[:, 0] = phone_df.iloc[:, 0].map(lambda x: config["PHONE"]["hours_use"][x]).astype(int)
    phone_df.iloc[:, 1:] = phone_df.iloc[:, 1:].apply(lambda x: x.map(config["PHONE"]["unaware_use"].get)).astype(int)
    phone_df = phone_df.astype(int)

    # Mapping media items
    media_df['x8'] = media_df['x8'].map(lambda x: 1 if x == 'כן' else 0)
    media_df['x9'] = media_df['x9'].map(lambda x: 1 if x == 'כן' else 0)
    media_df['x17'] = media_df['x17'].fillna(7).map(lambda x: 8 - x)

    for col in media_df.columns:
        if col not in ["x8", "x9", "x17"]:
            media_df[col] = media_df[col].map(lambda x: config["MEDIA"].get(x, x))

    # Mapping specific questions value for support_df
    support_df = pd.concat([support_df, pd.get_dummies(support_df['v1'], prefix='v1').astype(int)],
                           axis=1)  # .drop('v1', axis=1)
    support_df['v1'] = support_df['v1'].map(lambda x: 1 if x == 'דתי' else 0)
    support_df['v2'] = support_df['v2'].map(config["SUPPORT_VOULENTEER"])
    support_df["v3"] = support_df["v3"].map(lambda x: 1 if x == 'כן' else 0)
    support_df = pd.concat([support_df, pd.get_dummies(support_df['v4'], prefix='v4').astype(int)],
                           axis=1)  # .drop('v4', axis=1)
    support_df['v4'] = support_df['v4'].map(lambda x: 0 if x == 'עיר' else 1)

    # Concatenate all the DataFrames
    combined_df = pd.concat([resilience_df, QOL_df, stress_df, support_df, phone_df, media_df, unchanged_df], axis=1)

    # check which of the combined_df column is object / not numerical
    object_columns = combined_df.select_dtypes(include=['object']).columns
    print(f"Columns with object type: {object_columns}")

    # normalize
    combined_df = combined_df.apply(lambda x: (x - x.min()) / (x.max() - x.min()))

    # Drop rows of qol_index_to_drop and save dropped lines to a excel file named 'dropped_lines.xlsx'
    dropped_lines = combined_df.loc[qol_index_to_drop, :]
    dropped_lines.to_excel(ITEM_MAPS_PATH / 'dropped_lines.xlsx', index=False)
    combined_df.drop(qol_index_to_drop, inplace=True)

    # Save the combined DataFrame to an Excel file
    combined_df.to_excel(data_folder_path / 'processed_responses.xlsx', index=False)


def extracting_df_parts(df):
    stress_df = pd.concat([df.iloc[:, excel_column_number('H'):excel_column_number('N') + 1],
                           df.iloc[:, excel_column_number('R'):excel_column_number('S') + 1]], axis=1)
    support_df = pd.concat([df.iloc[:, excel_column_number('F')],
                            df.iloc[:, excel_column_number('O'):excel_column_number('Q') + 1]], axis=1)
    phone_df = df.iloc[:, excel_column_number('T'):excel_column_number('Y') + 1]
    media_df = df.iloc[:, excel_column_number('Z'):excel_column_number('AR') + 1]
    resilience_df = df.iloc[:, excel_column_number('AS'):excel_column_number('BB') + 1]
    QOL_df = df.iloc[:, excel_column_number('BC'):excel_column_number('BX') + 1]
    return QOL_df, media_df, phone_df, resilience_df, stress_df, support_df


if __name__ == "__main__":
    # Path to the directory where the script is located
    script_dir = Path(__file__).parent

    # Path to the 'responses.xlsx' file in the 'data' folder
    data_folder_path = script_dir / '..' / 'data'
    RESPONSES_PATH = data_folder_path / 'responses210124.xlsx'
    RESPONSES_FULL_QOL_PATH = data_folder_path / 'responses_full_qol060224.xlsx'

    # Create a directory for the items maps
    ITEM_MAPS_PATH = script_dir / '..' / 'items_maps'
    ITEM_MAPS_PATH.mkdir(parents=True, exist_ok=True)

    with open('config.json', encoding='utf-8') as f:
        config = json.load(f)

    main()
