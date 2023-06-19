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
    tuple val(sample), path("*R1_sub.fq.gz"), path("*R2_sub.fq.gz")

    script:
    """
    seqtk sample -s100 $fastq_1 $downsize > ${sample}_R1_sub.fq
    seqtk sample -s100 $fastq_2 $downsize > ${sample}_R2_sub.fq
    pigz *.fq
    """
    
}

workflow {
    subsample(reads)
}
