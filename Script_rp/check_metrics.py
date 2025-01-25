import os
import pandas as pd
import sys

# Define the directory containing the CSV files and the pair ID
directory_path = sys.argv[1]  # Expecting 'results_dragen/{pair_id}' directory
output_file = sys.argv[2]    # Output file to save results

def check_conditions(row):
    conditions = [
        row['total_reads'] > 5000000,
        row['duplication_rate'] < 90,
        row['base_quality'] > 30,
        row['mapped_reads'] > 90,
        row['MAPQs'] > 80
    ]
    return all(conditions)

accepted_files = []

# Traverse the specified directory
for root, _, files in os.walk(directory_path):
    for filename in files:
        # Process only files that match the pair_id and have the correct suffix
        if filename and filename.endswith(".mapping_metrics.csv"):
            file_path = os.path.join(root, filename)
            df = pd.read_csv(file_path, sep="\t", header=None)
            metrics_row = {
                'total_reads': int(df.iloc[0, 0].split(',')[3]),
                'duplication_rate': float(df.iloc[1, 0].split(',')[4]),
                'base_quality': float(df.iloc[55, 0].split(',')[4]),
                'mapped_reads': float(df.iloc[10, 0].split(',')[4]),
                'MAPQs': float(df.iloc[30, 0].split(',')[4]),
            }
            if check_conditions(metrics_row):
                accepted_files.append(filename.replace(".mapping_metrics.csv", ""))

# Save accepted file IDs to the output CSV
Accepted_id = pd.DataFrame(accepted_files, columns=["Accepted_Files_id"]).sort_values(by="Accepted_Files_id")
Accepted_id.to_csv(output_file, index=False)




