import os
import pandas as pd
from pathlib import Path

# ✅ Your folder setup
ascii_folder = Path("/Users/mouizkisma/Downloads/Predictive project/Bearing Data/Bearings/IMS/2nd_test")
output_folder = Path("/Users/mouizkisma/Downloads/Predictive project/Bearing Data/Python_scripts")
all_data = []

# ✅ Check paths
if not ascii_folder.exists():
    print(f"❌ ASCII folder not found: {ascii_folder}")
    exit()
if not output_folder.exists():
    print(f"❌ Output folder not found: {output_folder}")
    exit()

# ✅ Load all files with no extension
files_found = list(ascii_folder.iterdir())
print(f"🔍 Total files found: {len(files_found)}")

for file in sorted(files_found):
    if file.is_file():
        print(f"📄 Processing: {file.name}")
        try:
            # ✅ Correctly read tab-separated file
            df = pd.read_csv(file, sep='\t', header=None, engine='python')

            if df.shape[1] != 4:
                raise ValueError(f"⚠️ File has {df.shape[1]} columns instead of 4")

            df.columns = ['bearing1', 'bearing2', 'bearing3', 'bearing4']
            df['timestamp'] = file.name
            all_data.append(df)

        except Exception as e:
            print(f"❌ Failed to process {file.name}: {e}")

# ✅ Combine and save
if not all_data:
    print("❌ No files were processed. Check tab format again.")
    exit()

combined_df = pd.concat(all_data, ignore_index=True)
combined_df['index'] = range(len(combined_df))
combined_df = combined_df[['index', 'timestamp', 'bearing1', 'bearing2', 'bearing3', 'bearing4']]

output_csv = output_folder / "combined_bearings_data.csv"
combined_df.to_csv(output_csv, index=False)

print(f"✅ Data saved to: {output_csv}")
