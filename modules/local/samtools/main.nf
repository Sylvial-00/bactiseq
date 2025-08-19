
process SAMTOOLS {
    tag "$meta.id"
    label 'process_single'
    //     Copy bam and bai to input directory so bamdash caqn find it
    publishDir "results/bamdash", mode: 'copy'

    // TODO nf-core: See section in main README for further information regarding finding and adding container addresses to the section below.
    conda "${moduleDir}/environment.yml"
    //     container "${ workflow.containerEngine == 'docker' && !task.ext.singularity_pull_docker_container ?
    //     'https://depot.galaxyproject.org/singularity/ncbi-amrfinderplus:3.12.8--h283d18e_0':
    //     'biocontainers/ncbi-amrfinderplus:3.12.8--h283d18e_0' }"
    container "staphb/samtools:1.22.1" //--5fbbd7a07fc865335571e5589773157bd08c77b483e75e828b85f65919071bd3"
    // container 'community.wave.seqera.io/library/samtools:1.22.1--eccb42ff8fb55509'

    input:
        tuple val(meta), path(bam_file)

    output:
        path "seq_ids.txt" , emit: seq_ids
        path "*.bam.bai", emit: bai

    script:
    """
    #sort the bam file for bai file
    samtools sort "${bam_file}" -o sorted_output.bam
    #create the bai file
    samtools index sorted_output.bam output.bam.bai
    # create .bai
    samtools index ${bam_file}
    # Extract sequence ID from BAM file using samtools
    samtools view -H ${bam_file} | grep '^@SQ' | cut -f 2 | cut -d ':' -f 2 > seq_ids.txt
    """
}

// removed the | head -1 | pipe section so we get mutliple 
