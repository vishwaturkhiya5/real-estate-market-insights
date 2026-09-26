# Dataset setup

The source CSV is not stored in this repository because it is approximately 425 MB.

1. Download or copy `City_tracker(2).csv` from the original project source.
2. Place it in this folder so the final path is:

   `real-estate-market-insights/data/City_tracker(2).csv`

3. Do not rename the columns. The four SQL files use the actual 58 source-column names.
4. Keep the CSV out of GitHub. The root `.gitignore` already excludes `data/*.csv`.

Expected validation values for this exact file:

- File size: about 425 MB
- Rows: 1,048,575 excluding the header
- Columns: 58
- Source period: January 2012 through May 2026
- Extract timestamp: 2 June 2026

The published dashboard deliberately stops at 31 October 2025 so it remains consistent with the September–October 2025 project period.

