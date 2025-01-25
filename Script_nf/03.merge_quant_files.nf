process Margequant {

    publishDir "${params.output_directory}"
    input:
    path params.output_directory      // Directory containing input files (results_dragen)
    path params.merge_script    // Path to the check_metrics.py script
    path "accepted_id.csv"

    output:
    path  "accepted_id_quant.csv" // Output will be written to accepted_id.csv

    script:
    """
    python3 ${params.merge_script} ${params.output_directory}   accepted_id.csv accepted_id_quant.csv
    """
}
