import os
import pandas as pd
from pathlib import Path

# ✅ Your folder setup
ascii_folder = Path("/Users/mouizkisma/Downloads/Predictive project/Bearing Data/BearingsData/IMS/1st_test")
output_folder = Path("/Users/mouizkisma/Downloads/Predictive project/Bearing Data/Python_scripts")
all_data = []

# ✅ Check paths
if not ascii_folder.exists():
    print(f"❌ ASCII folder not found: {ascii_folder}")
    exit()
if not output_folder.exists():
    print(f"❌ Output folder not found: {output_folder}")
    exit()

# ✅ Load all files
files_found = list(ascii_folder.iterdir())
print(f"🔍 Total files found: {len(files_found)}")

for file in sorted(files_found):
    if file.is_file():
        print(f"📄 Processing: {file.name}")
        try:
            # ✅ Correctly read tab-separated file
            df = pd.read_csv(file, sep='\t', header=None, engine='python')

            # ✅ Expecting 8 channels
            if df.shape[1] != 8:
                raise ValueError(f"⚠️ File has {df.shape[1]} columns instead of 8")

            # ✅ Assign channels per bearing
            df.columns = [
                'bearing1_ch1', 'bearing1_ch2',
                'bearing2_ch3', 'bearing2_ch4',
                'bearing3_ch5', 'bearing3_ch6',
                'bearing4_ch7', 'bearing4_ch8'
            ]

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

# ✅ Reorder columns
combined_df = combined_df[
    ['index', 'timestamp',
     'bearing1_ch1', 'bearing1_ch2',
     'bearing2_ch3', 'bearing2_ch4',
     'bearing3_ch5', 'bearing3_ch6',
     'bearing4_ch7', 'bearing4_ch8']
]

output_csv = output_folder / "combined_bearings_data_2ch.csv"
combined_df.to_csv(output_csv, index=False)

print(f"✅ Data saved to: {output_csv}")
