nextflow.enable.dsl=2

include { DRAGEN_RNAseq } from './Script_nf/01.dragen.nf'
include { RunMetricsCheck } from './Script_nf/02.check_qc.nf'
include { Margequant } from './Script_nf/03.merge_quant_files.nf'
include { CheckSD } from './Script_nf/04.check_SD.nf'
include { DEGane} from './Script_nf//05.DEG.nf'

workflow {
    Channel
        .fromFilePairs(params.reads, flat: false)
        .set { paired_reads }

    // Step 1: Run the DRAGEN RNA-seq process
    DRAGEN_RNAseq(
        paired_reads,
        file(params.annotation),
        file(params.output_directory)
    )


    // Step 2: Run the Metrics Check process (depends on Step 1)
    sampleqccheck = RunMetricsCheck(
         file(params.output_directory),           // Output from DRAGEN RNA-seq
         file(params.check_script) // Path to the check_metrics.py script
        
    )
    // Step 3 : Merge the quantification files
    quant = Margequant(
        file(params.output_directory),
        file(params.merge_script ),
        sampleqccheck
    )

    // Step 4 : Check the SD
    accSD = CheckSD (
        file(params.r_script_ckSD),
        file(params.study_desgin),
        quant

    )
    // Step 5 : Run the DEG analysiss 
   DEGane(
        file(params.r_script),
        accSD,
        quant
    )

}


