process DEGane {
    publishDir "${params.output_directory}"

    input:
    path params.r_script   // Path to the check_metrics.py script
    path "go_next_SD_accepted.csv"   
    path "accepted_id_quant.csv"


    output:
    path  "the_aim/*" 

    script:
    """
    mkdir -p the_aim
    Rscript ${params.r_script}    go_next_SD_accepted.csv accepted_id_quant.csv the_aim
    """
}