# SQL-layoffs-analysis
SQL data cleaning and exploratory analysis of global company layoffs.

The raw dataset contained issues such as duplicate rows, inconsistent company and industry names, blank values, and date fields stored as text.

After cleaning the data:

- Duplicate records were identified and removed
- Company names were trimmed and standardized
- Industry values were standardized
- Blank and NULL values were reviewed and handled
- Date values were converted into SQL date format
- Unnecessary rows and columns were removed

### Example Before and After

| Before | After |
|---|---|
| `DÃ¼sseldorf` | `Dusseldorf` |
| `Crypto Currency` | `Crypto` |
| `03/15/2023` | `2023-03-15` |
