reads = Channel.from( params.input )
                .splitCsv( header:false, sep:',' )
                ..map ({ row-> tuple(row.sample, row.fastq_1, row.fastq_2, row.strand, row.downsize })

process subsample {
    debug true
    machineType "${params.machineType}"
    disk "${params.disk} GB"
    tag "${sample}"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(sample), path(fastq_1), path(fastq_2), val(strand), val(downsize)

    output:
    tuple val(sample), path("*R1_sub*"), path("*R2_sub*")

    script:
    """
    /SARS-CoV-2_Multi-PCR_v1.0/tools/seqtk sample -s100 $ $fastq_1 > ${sample}_R1_sub.fq
    /SARS-CoV-2_Multi-PCR_v1.0/tools/seqtk sample -s100 $ $fastq_2 > ${sample}_R2_sub.fq
    """
    
}

workflow {
    subsample(reads)
}
