	#!/usr/bin/env nextflow
params.reads = "/home/ubuntu/fastqc/SRR14609304_2.fastq"
params.outdir = "results"

log.info """\
 TRIM-GALORE-NF PIPELINE
 ===================================
 reads        : ${params.reads}
 outdir       : ${params.outdir}
 """


Channel
    .fromFilePairs( params.reads )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }
    .into { read_pairs_ch; read_pairs2_ch }

process trimgalore {
    tag "TRIM galore on $sample_id"
    publishDir params.outdir

    input:
    set sample_id, file(reads) from read_pairs2_ch

    output:
    file("trimmed_${sample_id}_logs") into trim_ch


    script:
    """
    mkdir trimmed_${sample_id}_logs
    trim_galore  ${reads} -o trimmed_${sample_id}_logs
    """
}

workflow.onComplete {
        println ( workflow.success ? "\nDone! --> $params.outdir/\n" : "Oops .. something went wrong" )
}
