import pandas as pd
from pathlib import Path
import csv
import re


def excel_column_number(col_str):
    """Convert Excel-style column letters to zero-based column index."""
    expn = 0
    col_num = 0
    for char in reversed(col_str.upper()):
        col_num += (ord(char) - ord('A') + 1) * (26 ** expn)
        expn += 1
    return col_num - 1


def detect_uniform_responses(df_name, dataframe, std_threshold=0.0, range_threshold=0, verbose=0):
    """
    find rows with uniform responses for a specific DataFrame (represent specific part of the entire questionnaire).
    Use std and range to detect rows with almost uniform responses in a specific DataFrame.
    """
    # rows with uniform responses
    uniform_reply = dataframe.apply(lambda x: x.nunique() == 1, axis=1)

    # rows range of values
    rng = dataframe.max(axis=1) - dataframe.min(axis=1)

    # rows std
    std = dataframe.std(axis=1)

    if verbose > 0:
        print(df_name)
        print(f"N rows with uniform responses: {uniform_reply[uniform_reply].shape[0]}\n,"
              f" Indexes: {uniform_reply[uniform_reply].index}")
        print(f"N rows with low range: {rng[rng < range_threshold].shape[0]}\n,"
              f" Indexes: {rng[rng < range_threshold].index}")
        print(f"N rows with low std: {std[std < std_threshold].shape[0]}\n,"
              f" Indexes: {std[std < std_threshold].index}\n")

    # return indexes of rows with uniform responses, or with low range, or with low std.
    return uniform_reply[uniform_reply].index.union(rng[rng < range_threshold].index).union(
        std[std < std_threshold].index)


def create_and_save_mapping(partial_df, full_df, prefix, output_directory):
    """
    This function creates a mapping between the original column names and the new column names.
    The mapping is saved to a CSV file. The function also renames the columns in the provided DataFrame,
    to save the responses later on with the encoded column names.

    :param prefix: The letter which encodes the original item (column) names
    :return: The full DataFrame with the renamed columns
    """
    mapping = {}
    excel_data = []

    for i, col in enumerate(partial_df.columns):
        # Extract text within square brackets if present using regex. This part is relevant for parts of the questionnaire
        # where the column names are in the format: "general text [question]"
        match = re.search(r'\[(.*?)]', col)
        if match:
            col_name = match.group(1)  # Use text within brackets
        else:
            col_name = col  # Use the original column name if no brackets are found

        # Create the mapping
        mapping[col] = f"{prefix}{i + 1}"
        excel_data.append({'Questions': col_name, 'Variable': f"{prefix}{i + 1}"})

        dataframe = pd.DataFrame(excel_data)

        dataframe.to_excel(output_directory, index=False)


    # Rename columns in the provided DataFrame
    full_df = full_df.rename(columns=mapping)

    return full_df


def main():
    """
    This code contains mostly manual work, due to the need of interpreting each item in the
    questionnaire differently. Each preprocessing step in this main function is explained separately.
    """

    # Load the responses file
    df_not_full_qol = pd.read_excel(RESPONSES_PATH)
    df_full_qol = pd.read_excel(RESPONSES_FULL_QOL_PATH)
    df = pd.concat([df_not_full_qol, df_full_qol], axis=0)

    # Split the DataFrame into question type seperated, columns are chosen by specific questions organization.
    stress_df = pd.concat([df.iloc[:, excel_column_number('H'):excel_column_number('N') + 1],
                           df.iloc[:, excel_column_number('R'):excel_column_number('S') + 1]], axis=1)
    support_df = pd.concat([df.iloc[:, excel_column_number('F')],
                            df.iloc[:, excel_column_number('O'):excel_column_number('Q') + 1]], axis=1)
    phone_df = df.iloc[:, excel_column_number('T'):excel_column_number('Y') + 1]
    media_df = df.iloc[:, excel_column_number('Z'):excel_column_number('AR') + 1]
    resilience_df = df.iloc[:, excel_column_number('AS'):excel_column_number('BB') + 1]
    QOL_df = df.iloc[:, excel_column_number('BC'):excel_column_number('BU') + 1]

    df_list = [stress_df, support_df, phone_df, media_df, resilience_df, QOL_df]

    # Get df of the rest of the columns from the original df using the df_list
    unchanged_df = df.drop(pd.concat(df_list, axis=1).columns, axis=1)

    # Mapping all QOL responds from categorical to numerical
    qol_val_mapping = {
        "כמעט אף פעם": 1,
        "לעיתים רחוקות": 2,
        "לפעמים": 3,
        "לעיתים קרובות": 4,
        "כמעט תמיד": 5
    }
    QOL_df = QOL_df.map(lambda x: qol_val_mapping.get(x, x))

    # Drop rows with uniform responses in qol_df
    qol_index_to_drop = detect_uniform_responses('QOL_df', QOL_df, std_threshold=0.2, range_threshold=2,
                                                 verbose=1)  # Some questions have different sentiment

    # Change QOL negative questions values to positive TODO: adjust for new data when questions are added
    columns_to_change = [
        "באיזו תדירות המצבים הבאים רלוונטיים עבורך? \n(לממלאים בפלאפון- מומלץ לסובב את המסך) [תחושת כאב]",
        "באיזו תדירות המצבים הבאים רלוונטיים עבורך? \n(לממלאים בפלאפון- מומלץ לסובב את המסך) [תחושת חוסר בטחון, חוסר בהירות]",
        "באיזו תדירות המצבים הבאים רלוונטיים עבורך? \n(לממלאים בפלאפון- מומלץ לסובב את המסך) [חרדה / פחד]",
        "באיזו תדירות המצבים הבאים רלוונטיים עבורך? \n(לממלאים בפלאפון- מומלץ לסובב את המסך) [דיכאון / עצב]",
        "באיזו תדירות המצבים הבאים רלוונטיים עבורך? \n(לממלאים בפלאפון- מומלץ לסובב את המסך) [מתח / חוסר שקט]"
    ]
    for col in columns_to_change:
        QOL_df[col] = QOL_df[col].map(lambda x: 6 - x)

    # Mapping specific questions value for stress_df
    stress_n_kids_mapping = {
        0: 0,
        1: 1,
        2: 2,
        "3-4": 3,
        "5-6": 4,
        "7+": 5
    }
    stress_df['מספר ילדים'] = stress_df['מספר ילדים'].map(stress_n_kids_mapping)
    stress_df[' מספר ילדים המשרתים בשרות צבאי (חובה/מילואים)'] = stress_df[
        ' מספר ילדים המשרתים בשרות צבאי (חובה/מילואים)'].map(lambda x: 3 if x == '3+' else x)

    # mapping specific questions to binary according to stress cause reply
    stress_df['בקרב האנשים הקרובים אלי ביותר (המשפחה הגרעינית או חברים קרובים מאוד)  יש משרתי מילואים במלחמה. '] = \
        stress_df[
            'בקרב האנשים הקרובים אלי ביותר (המשפחה הגרעינית או חברים קרובים מאוד)  יש משרתי מילואים במלחמה. '].map(
            lambda x: 1 if x == 'כן, בחזית' or x == 'כן, בחזית, כן, בעורף' else 0)
    stress_df['בעקבות המלחמה התפניתי מביתי'] = stress_df['בעקבות המלחמה התפניתי מביתי'].map(
        lambda x: 0 if x == 'לא התפניתי' else 1)
    stress_df['במקום המגורים שלי יש מרחב מוגן'] = stress_df['במקום המגורים שלי יש מרחב מוגן'].map(
        lambda x: 0 if x == 'כן, ממ"ד' or x == 'כן, מקלט / ממ"ק' else 1)
    stress_df['תעסוקה'] = stress_df['תעסוקה'].map(
        lambda x: 1 if x == 'בחל"ת' or x == 'עצמאי/ת' else 0)  # TODO: varify assumption
    military_service_mapping = {
        "לא": 0,
        "תומך לחימה / משרת בעורף": 1,
        "תפקיד קרבי - מילואים": 2,
        "תפקיד קרבי - סדיר": 2
    }
    stress_df['הנני משרת / שירתתי בצבא בזמן המלחמה (קרבי או לא)'] = \
        stress_df['הנני משרת / שירתתי בצבא בזמן המלחמה (קרבי או לא)'].map(military_service_mapping)
    stress_shelter_time = {
        "איני יודע/ת": 0,
        'הנני שוהה בחו"ל בזמן המלחמה': 0,
        "עד דקה וחצי": 1,
        "עד דקה": 2,
        "עד 45 שניות": 3,
        "עד 30 שניות": 4,
        "עד 15 שניות": 5,
        "מיידי": 5
    }
    stress_df['מרחק מקום מגורים מרצועת עזה / גבול הצפון (זמן כניסה למרחב המוגן)'] = \
        stress_df['מרחק מקום מגורים מרצועת עזה / גבול הצפון (זמן כניסה למרחב המוגן)'].map(stress_shelter_time)
    income_loss = {
        'לא נפגעו כלל': 0,
        'נפגעו במידת מה': 1,
        'נפגעו משמעותית': 2
    }
    stress_df['הכנסותי / הכנסות משק הבית שלי נפגעו כתוצאה מהמלחמה'] = \
        stress_df['הכנסותי / הכנסות משק הבית שלי נפגעו כתוצאה מהמלחמה'].map(income_loss)

    # Mapping all resilience responds from categorical to numerical
    resilience_val_mapping = {
        "כלל לא מסכים": 1,
        "לא מסכים": 2,
        "ניטרלי (לא מסכים ולא מתנגד)": 3,
        "מסכים": 4,
        "מסכים במידה רבה": 5
    }
    resilience_df = resilience_df.map(lambda x: resilience_val_mapping.get(x, x))

    # Mapping specific questions value for phone_df
    phone_hours_use_mapping = {
        "עד שעה": 1,
        "1-3 שעות": 2,
        "3-6 שעות": 3,
        "6-9 שעות": 4,
        "9+ שעות": 5
    }
    phone_unaware_use_mapping = {
        "כלל לא": 1,
        "לעיתים רחוקות": 2,
        "מדי פעם": 3,
        "לעיתים קרובות": 4,
        "כל הזמן": 5
    }
    phone_df.iloc[:, 0] = phone_df.iloc[:, 0].map(lambda x: phone_hours_use_mapping[x]).astype(int)
    phone_df.iloc[:, 1:] = phone_df.iloc[:, 1:].apply(lambda x: x.map(phone_unaware_use_mapping.get)).astype(int)
    phone_df = phone_df.astype(int)

    # Mapping specific questions value for media_df
    media_val_mapping = {
        "כלל לא": 1,
        "מעט מאוד": 2,
        "מעט": 3,
        "הרבה": 4,
        "הרבה מאוד": 5
    }
    media_df.drop('במידה וסימנת "כן" בשאלה הקודמת, ציין/ני מה הוא מקור זה. ', axis=1, inplace=True)
    media_df.drop('בזמן מילוי שאלון זה מצב הלחימה הינו', axis=1,
                  inplace=True)
    for col in media_df.columns:
        if 'עד כמה' in col:
            media_df[col] = media_df[col].map(lambda x: media_val_mapping.get(x, x))
        elif col == 'ציין עד כמה הנך מקבל/ת מידע חדשותי מהערוצים זרים -- ישראליים.':
            media_df[col] = media_df[col].astype(int)

    # mapping specific questions to binary according to stress cause reply
    media_df['האם במהלך המלחמה התחלתי לצרוך חדשות ברשת/ערוץ מדיה חדש שלא צרכתי לפני המלחמה'] = media_df[
        'האם במהלך המלחמה התחלתי לצרוך חדשות ברשת/ערוץ מדיה חדש שלא צרכתי לפני המלחמה'].map(
        lambda x: 1 if x == 'כן' else 0)
    media_df['האם הנך מקבל/ת בטלפון התראות מאתרי חדשות?'] = media_df['האם הנך מקבל/ת בטלפון התראות מאתרי חדשות?'].map(
        lambda x: 1 if x == 'כן' else 0)
    media_df['ציין עד כמה הנך מקבל/ת מידע חדשותי מהערוצים זרים -- ישראליים.'] = \
        media_df['ציין עד כמה הנך מקבל/ת מידע חדשותי מהערוצים זרים -- ישראליים.'].map(lambda x: 8-x)

    # Mapping specific questions value for support_df
    support_df['שיוך דתי'] = support_df['שיוך דתי'].map(lambda x: 1 if x == 'דתי' else 0)
    volunteer_mapping = {
        "לא": 0,
        "כן, למספר ימים": 1,
        "כן, מעל שבוע": 2
    }
    support_df['האם התנדבת במהלך המלחמה?'] = support_df['האם התנדבת במהלך המלחמה?'].map(volunteer_mapping)
    support_df["האם תרמת באופן כלכלי (כסף / ציוד / בגדים /מזון וכו'..) במהלך המלחמה"] = \
        support_df["האם תרמת באופן כלכלי (כסף / ציוד / בגדים /מזון וכו'..) במהלך המלחמה"].map(
            lambda x: 1 if x == 'כן' else 0)
    # create new columns in support df using dummies for specific column
    support_df = pd.concat([support_df, pd.get_dummies(support_df['באיזה סוג של יישוב קהילתי הנך מתגורר/ת'],
                                                   prefix='באיזה סוג של יישוב קהילתי הנך מתגורר/ת').astype(int)], axis=1)
    support_df.drop('באיזה סוג של יישוב קהילתי הנך מתגורר/ת', axis=1, inplace=True)

    # Concatenate all the DataFrames
    combined_df = pd.concat([resilience_df, QOL_df, stress_df, support_df, phone_df, media_df], axis=1)

    # Normalize all data to scale of 0-1
    combined_df = combined_df.apply(lambda x: (x - x.min()) / (x.max() - x.min()))

    combined_df = pd.concat([combined_df, unchanged_df], axis=1)

    # creating list again because of changed dataframes. create list of letter encoding for each dataframe
    df_list = [stress_df, support_df, phone_df, media_df, resilience_df, QOL_df]
    letters_mapping_list = ['u', 'v', 'w', 'x', 'z', 'y']

    # Create and save the mappings of columns for sem analysis
    for df, prefix in zip(df_list, letters_mapping_list):
        combined_df = create_and_save_mapping(df, combined_df, prefix, ITEM_MAPS_PATH / f'{prefix}_mapping.xlsx')

    # Drop rows of qol_index_to_drop and save dropped lines to a excel file named 'dropped_lines.xlsx'
    dropped_lines = combined_df.loc[qol_index_to_drop, :]
    dropped_lines.to_excel(ITEM_MAPS_PATH / 'dropped_lines.xlsx', index=False)
    combined_df.drop(qol_index_to_drop, inplace=True)

    # Save the combined DataFrame to an Excel file
    combined_df.to_excel(data_folder_path / 'processed_responses.xlsx', index=False)


if __name__ == "__main__":
    # Path to the directory where the script is located
    script_dir = Path(__file__).parent

    # Path to the 'responses.xlsx' file in the 'data' folder
    data_folder_path = script_dir / '..' / 'data'
    RESPONSES_PATH = data_folder_path / 'responses210124.xlsx'
    RESPONSES_FULL_QOL_PATH = data_folder_path / 'responses_full_qol300124.xlsx'

    # Create a directory for the items maps
    ITEM_MAPS_PATH = script_dir / '..' / 'items_maps'
    ITEM_MAPS_PATH.mkdir(parents=True, exist_ok=True)

    main()
