process DRAGEN_RNAseq {


    input:
    tuple val(pair_id), path(reads)
    path annotation_file
    path output_directory

    output:
    path "${output_directory}/${pair_id}/result.txt"

    script:
    """
    
    mkdir -p ${output_directory}/${pair_id}
    
    echo "dragen \\
        --enable-rna true \\
        --annotation-file ${annotation_file} \\
        --enable-rna-quantification true \\
        --rna-quantification-library-type IU \\
        --rna-quantification-gc-bias true \\
        --enable-rna-gene-fusion false \\
        --rna-gf-restrict-genes true \\
        --enable-duplicate-marking true \\
        --rrna-filter-enable true \\
        --trim-polya-min-trim 20 \\
        --output-dir ${output_directory}/${pair_id} \\
        --input-file1 ${reads[0]} \\
        --input-file2 ${reads[1]}
    " > ${output_directory}/${pair_id}/result.txt
    """
}
