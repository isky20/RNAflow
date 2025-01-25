process RunMetricsCheck {

    
    input:
    path params.output_directory    // Directory containing input files (e.g., results_dragen)
    path params.check_script         // Path to the check_metrics.py script

    output:
    path "accepted_id.csv" // Output file written to accepted_id.csv

    script:
    """
    python3 ${params.check_script} ${params.output_directory} accepted_id.csv
    """
}


