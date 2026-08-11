import pandas as pd
from sqlalchemy.util import to_list

# The path to my Excel file
file_path = r'C:\Users\helen\Documents\EV adoption project\Weekly_Oil_Bulletin_Prices_History_maticni_4web.xlsx'

# Read the sheet, skipping the 2 junk rows (the description + units rows)
# skiprows=[1, 2] skips them but keeps row 0 as the real column headers

df = pd.read_excel(file_path, sheet_name='Prices with taxes', skiprows=[1,2])

# Rename the first column to something simple — it's the date
df = df.rename(columns={df.columns[0]: 'date'})

#Keep only the columns we need: date + any column containing 'euro 95' or 'diesel' data

columns_to_keep = ['date']

for col in df.columns:
    if 'euro95' in col or 'diesel' in col:
        columns_to_keep.append(col)

df_filtered = df[columns_to_keep]

#Make sure the date column is recognised as a real date. If can't convert to date, don't throw an error,
# place NaT (empty date) instead, errors = 'coerce'

df_filtered ['date'] = pd.to_datetime(df_filtered['date'], errors='coerce')

#Keep only the rows for years 2015-2024
df_years = df_filtered [
    (df_filtered['date'].dt.year >= 2015) &
    (df_filtered['date'].dt.year <= 2024)
]

#Reshape from wide to long - one row per date/column combination (unpivot)
df_long = df_years.melt(
    id_vars=['date'],
    var_name='country_fuel',
    value_name='price'
)

#Extract country - everything before the first underscore
df_long['country'] = df_long['country_fuel'].str.split('_').str[0]

#Extract fuel_type - everything after the LAST underscore
df_long['fuel_type'] = df_long['country_fuel'].str.split('_').str[-1]

#Drop the messy combined column, we don't need it anymore
df_long = df_long.drop(columns=['country_fuel'])

# Reorder the columns into a logical order
df_long = df_long[['date', 'country', 'fuel_type', 'price']]

# Extract just the year from each date
df_long['year'] = df_long['date'].dt.year

# Group by country, fuel_type, year - and average weekly prices
df_annual = df_long.groupby(['country', 'fuel_type', 'year'])['price'].mean().reset_index()

print(df_annual.head())
print('\nShape after annual average:', df_annual.shape)

from sqlalchemy import create_engine

#Connection details - adjust password if yours is different
engine = create_engine(
    'postgresql+psycopg2://postgres:YOUR_PASSWORD@localhost:5432/EV_adoption',
connect_args={'client_encoding': 'utf8'})

#Write the dataframe into Bronze layer
df_annual.to_sql('raw_fuel_prices', engine, if_exists='replace', index=False)

print('Loaded into PostgreSQL successfully!')

