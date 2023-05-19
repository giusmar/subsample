reads = Channel.fromPath( params.input )
                .splitCsv( header:false, sep:',' )
                .map( { row -> [sample = row[0], fastq_1 = row[1], fastq_2 = row[2], strand = row[3], downsize = row[4]] } )

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
    /SARS-CoV-2_Multi-PCR_v1.0/tools/seqtk sample -s100 $fastq_1 $downsize > ${sample}_R1_sub.fq
    /SARS-CoV-2_Multi-PCR_v1.0/tools/seqtk sample -s100 $fastq_2 $downsize > ${sample}_R2_sub.fq
    """
    
}

workflow {
    subsample(reads)
}
