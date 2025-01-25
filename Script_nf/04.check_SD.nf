process CheckSD {
    
    input:
    path params.r_script_ckSD   // Path to the check_metrics.py script
    path params.study_desgin    
    path "accepted_id_quant.csv"


    output:
    path  "go_next_SD_accepted.csv"

    script:
    """
    mkdir -p the_aim
    Rscript ${params.r_script_ckSD}   accepted_id_quant.csv ${params.study_desgin} go_next_SD_accepted.csv
    """
}