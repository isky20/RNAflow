import os
import pandas as pd
import sys


directory = sys.argv[1]
accepted_file = sys.argv[2]
output_file = sys.argv[3]

merged_df = pd.DataFrame()

# Assuming 'directory' and 'accepted_file' are defined
for root, _, files in os.walk(directory):
    for filename in files:
        print(pd.read_csv(accepted_file))

        # Process only files that match the pair_id and have the correct suffix
        df_id = [item[0] + '.quant.genes.sf' for item in pd.read_csv(accepted_file).values.tolist()]
        
        if filename.endswith('.quant.genes.sf') and filename in df_id:
            # Now 'filename' is in both the folder and df_id
            file_path = os.path.join(root, filename)
            
            # Read the current file
            df = pd.read_csv(file_path, sep='\t')
            
            # Set the gene names as the index
            df.set_index('Name', inplace=True)
            
            # Extract the relevant column (e.g., NumReads)
            column_data = df[["NumReads"]]
            
            # Rename the column to avoid conflicts (use the file name as the column name)
            sample_name = filename.replace('.quant.genes.sf', '')
            column_data = column_data.rename(columns={"NumReads": sample_name})
            
            # Merge with the main DataFrame
            if merged_df.empty:
                merged_df = column_data
            else:
                merged_df = merged_df.join(column_data, how='outer')

# Sort the columns alphabetically according to the smaple name 
sorted_df = merged_df[sorted(merged_df.columns)]

# Save the merged DataFrame to a CSV file
sorted_df.to_csv(output_file)